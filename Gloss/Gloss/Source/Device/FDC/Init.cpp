#include <Device/FDC.hpp>
#include <Device/IDT.hpp>
#include <Device/PIC.hpp>
#include <Device/PIT.hpp>
#include <Device/Port.hpp>

#include <Device/Console.hpp>

using namespace Device;

bool FDC::Init(void) {
    IDT::SetHandler(0x26, (uint64_t)&FDC::Handler);
    PIC::EnableIRQ(0x06);

    CurrentDrive_ = 0x00;

    Reset();

    // CommandSpecify(13, 1, 0x0F, true);

    return true;
}

void FDC::LBACHS(uint64_t LBA, uint8_t *Head, uint8_t *Track, uint8_t *Sector) {
    *Head = (uint8_t)((LBA % 36) / 18);
    *Track = (uint8_t)(LBA / 36);
    *Sector = (uint8_t)((LBA % 18) + 1);
}


uint8_t *FDC::ReadSector(uint64_t LBA) {
    if (CurrentDrive_ >= 4) {
        return 0;
    }
    Console::Print("Reading Sector From Disk.\n");
    uint8_t head = 0;
    uint8_t track = 0;
    uint8_t sector = 1;
    LBACHS(LBA, &head, &track, &sector);
    Console::Print("Starting Motor.\n");
    EnableMotor(CurrentDrive_);
    Console::Print("Seeking.\n");
    if (CommandSeek(track, head, CurrentDrive_) != 0) {
        return 0;
    }

    Console::Print("Reading Sector.\n");
    CommandReadSector(0, head, track, sector, CurrentDrive_);

    Console::Print("Disabling Motor.\n");
    DisableMotor(CurrentDrive_);

    return (uint8_t*)(0x7000);
}

void FDC::Wait(void) {
    while(!IRQOccurance) {
        asm volatile("hlt");
        // Console::PutChar(0);
    }
    IRQOccurance = false;
}

void FDC::WriteDOR(uint8_t Value) {
    Port::OutputByte((uint16_t)(Controller::Primary) + (uint16_t)(Register::DigitalOutput), Value);
}

void FDC::WriteControl(uint8_t Value) {
    Port::OutputByte((uint16_t)(Controller::Primary) + (uint16_t)(Register::Control), Value);
}

void FDC::WriteData(uint8_t Value) {
    for (uint8_t i = 0; i < 255; ++i) {
        if (ReadStatus() & (uint8_t)StatusMask::DataReady) {
            Port::OutputByte((uint16_t)(Controller::Primary) + (uint16_t)(Register::Data), Value);
            break;
        }
        // PIT::Sleep(1);
    }
    // Port::OutputByte((uint16_t)(Controller::Primary) + (uint16_t)(Register::Data), Value);
}

uint8_t FDC::ReadStatus(void) {
    return Port::InputByte((uint16_t)(Controller::Primary) + (uint16_t)(Register::Status));
}

uint8_t FDC::ReadData(void) {
    for (uint8_t i = 0; i < 255; ++i) {
        if (ReadStatus() & (uint8_t)StatusMask::DataReady) {
            return Port::InputByte((uint16_t)(Controller::Primary) + (uint16_t)(Register::Data));
            // break;
        }
        // PIT::Sleep(1);
    }
    return 0x00;
    // return Port::InputByte((uint16_t)(Controller::Primary) + (uint16_t)(Register::Data));
}

void FDC::Enable(void) {
    FDC::WriteDOR((uint16_t)(DigitalOutputMask::Reset) | (uint16_t)(DigitalOutputMask::DMA));
}
void FDC::Disable(void) {
    FDC::WriteDOR(0x00);
}

void FDC::EnableMotor(uint8_t Drive) {
    WriteDOR((0x10 /*<< (Drive + 4)*/) | Drive | (uint8_t)(DigitalOutputMask::DMA) | (uint8_t)(DigitalOutputMask::Reset));
    PIT::Sleep(20);
}
void FDC::DisableMotor(uint8_t Drive) {
    WriteDOR((uint8_t)DigitalOutputMask::Reset);
}

void FDC::CommandSpecify(uint8_t StepRate, uint8_t LoadTime, uint8_t UnloadTime, bool DMA) {
    WriteData((uint8_t)Command::Specify);
    WriteData(((StepRate & 0x0F) << 4) | (UnloadTime & 0x0F));
    WriteData(((LoadTime & 0x7F) << 1) | (DMA ? 1 : 0));
}

uint8_t FDC::CommandCheckStatus(uint8_t Head, uint8_t Drive) {
    WriteData((uint8_t)Command::CheckStatus);
    WriteData(((Head) << 2) | (Drive & 0x03));
    return ReadData();
}

void FDC::CommandReadSector(uint64_t Address, uint8_t Head, uint8_t Track, uint8_t Sector, uint8_t Drive) {
    uint8_t status0;
    uint8_t cylinder;

    Console::Print("Starting DMA Read..\n");
    DMARead();

    Console::Print("Writing Data.\n");
    WriteData((uint8_t)(Command::ReadSector) | (uint8_t)(CommandExtension::Multitrack) | (uint8_t)(CommandExtension::SkipDeleted) | (uint8_t)(CommandExtension::Density));
    WriteData(Head << 2 | Drive);
    WriteData(Track);
    WriteData(Head);
    WriteData(Sector);
    WriteData(0x02);
    WriteData(((Sector + 1) >= 0x12) ? 0x12 : Sector + 1);
    WriteData(0x1B);
    WriteData(0xFF);

    Console::Print("Waiting..\n");
    Wait();

    Console::Print("Reading Data.\n");
    for (int i = 0; i < 7; ++i) {
        ReadData();
    }

    Console::Print("Checking Interrupts.\n");
    CommandCheckInterrupt(&status0, &cylinder);

//    Memory::Copy((uint8_t *)(DMAAddress_), (uint8_t *)(Address), 512);
}

int FDC::CommandCalibrate(uint8_t Drive) {
    Console::Print("Calibrating..\n");
    uint8_t status0;
    uint8_t cylinder;

    if (Drive >= 4) {
        return -1;
    }

    Console::Print("Enabling Motor.\n");
    EnableMotor(Drive);
    // PIT::Sleep(10);

    for (int i = 0; i < 10; ++i) {
        Console::Print("Writing Data.\n");
        WriteData((uint8_t)Command::Calibrate);
        Console::Print("Writing More Data.\n");
        WriteData(Drive);
        Console::Print("Waiting..\n");
        Wait();
        Console::Print("Checking Interrupt.\n");
        CommandCheckInterrupt(&status0, &cylinder);

        Console::Print("Checking Cylinder.\n");
        if (!cylinder) {
            Console::Print("Disabling Motor (Success).\n");
            DisableMotor(Drive);
            return 0;
        }
    }

    Console::Print("Disabling Motor (Failure).\n");
    DisableMotor(Drive);
    return -2;
}

void FDC::CommandCheckInterrupt(uint8_t *Status, uint8_t *Cylinder) {
    WriteData((uint8_t)Command::CheckInterrupt);
    *Status = ReadData();
    *Cylinder = ReadData();
}

int FDC::CommandSeek(uint8_t Cylinder, uint8_t Head, uint8_t Drive) {
    Console::Print("Seeking..\n");
    uint8_t status0;
    uint8_t cylinder;

    if (Drive >= 4) {
        return -1;
    }

    EnableMotor(Drive);
    PIT::Sleep(10);

    for (int i = 0; i < 10; ++i) {
        WriteData((uint8_t)Command::Calibrate);
        WriteData(Drive);
        Wait();
        CommandCheckInterrupt(&status0, &cylinder);

        if (cylinder == Cylinder) {
            DisableMotor(Drive);
            return 0;
        }
    }

    DisableMotor(Drive);
    return -2;
}

void FDC::DMAInit(void) {
    Port::OutputByte(0x0A, 0x06);
    Port::OutputByte(0xD8, 0xFF);
    Port::OutputByte(0x04, 0x00);
    Port::OutputByte(0x04, 0x70);
    Port::OutputByte(0xD8, 0xFF);
    Port::OutputByte(0x05, 0xFF);
    Port::OutputByte(0x05, 0x23);
    Port::OutputByte(0x80, 0x00);
    Port::OutputByte(0x0A, 0x02);
}

void FDC::DMARead(void) {
    Port::OutputByte(0x0A, 0x06);
    Port::OutputByte(0x0B, 0x56);
    Port::OutputByte(0x0A, 0x02);
}

void FDC::DMAWrite(void) {
    Port::OutputByte(0x0A, 0x06);
    Port::OutputByte(0x0B, 0x5A);
    Port::OutputByte(0x0A, 0x02);
}

uint8_t FDC::CurrentDrive_;
uint64_t FDC::DMAAddress_;