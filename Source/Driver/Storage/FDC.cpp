#include <Driver/Storage/FDC.hpp>
#include <Driver/CPU/IDT.hpp>
#include <Driver/Port.hpp>
#include <Driver/Legacy/PIT.hpp>

using FDC = Driver::Storage::FDC;
using IDT = Driver::CPU::IDT;
using Port = Driver::Port;
using PIT = Driver::Legacy::PIT;

bool IRQOccurance = false;

void FDC::Handler(IDT::ISRPack Pack) {
    IRQOccurance = true;
}

void FDC::Reset(void) {
    uint8_t status0;
    uint8_t cylinder;

    Disable();
    Enable();
//    Wait();

    for (uint8_t i = 0; i < 4; ++i) {
        CommandCheckInterrupt(&status0, &cylinder);
    }

    WriteControl(0x00);
    CommandSpecify(3, 16, 240, true);
    CommandCalibrate(CurrentDrive_);
}

void FDC::Init(void) {
    IDT::SetHandler(0x26, &FDC::Handler);
    CurrentDrive_ = 0;
    DMAAddress_ = 0x7000;
    DMAInit();
    Reset();
    CommandSpecify(13, 1, 0x0F, true);
}

void FDC::LBACHS(uint64_t LBA, uint8_t *Head, uint8_t *Track, uint8_t *Sector) {
    *Head = (uint8_t)((LBA % 36) / 18);
    *Track = (uint8_t)(LBA / 36);
    *Sector = (uint8_t)((LBA % 36) + 1);
}

uint8_t *FDC::ReadSector(uint64_t LBA) {
    if (CurrentDrive_ >= 4) {
        return 0;
    }
    uint8_t head = 0;
    uint8_t track = 0;
    uint8_t sector = 1;
    LBACHS(LBA, &head, &track, &sector);
    EnableMotor(CurrentDrive_);
    if (CommandSeek(track, head, CurrentDrive_) != 0) {
        return 0;
    }

    CommandReadSector(0, head, track, sector, CurrentDrive_);

    DisableMotor(CurrentDrive_);

    return (uint8_t*)(0x7000);
}

void FDC::Wait(void) {
    while(!IRQOccurance) {
//        asm("hlt");
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
            break;
        }
        PIT::Sleep(1);
    }
    Port::OutputByte((uint16_t)(Controller::Primary) + (uint16_t)(Register::Data), Value);
}

uint8_t FDC::ReadStatus(void) {
    return Port::InputByte((uint16_t)(Controller::Primary) + (uint16_t)(Register::Status));
}

uint8_t FDC::ReadData(void) {
    for (uint8_t i = 0; i < 255; ++i) {
        if (ReadStatus() & (uint8_t)StatusMask::DataReady) {
            break;
        }
        PIT::Sleep(1);
    }
    return Port::InputByte((uint16_t)(Controller::Primary) + (uint16_t)(Register::Data));
}

void FDC::Enable(void) {
    FDC::WriteDOR((uint16_t)(DigitalOutputMask::Reset) | (uint16_t)(DigitalOutputMask::DMA));
}
void FDC::Disable(void) {
    FDC::WriteDOR(0x00);
}

void FDC::EnableMotor(uint8_t Drive) {
    WriteDOR((0x01 << (Drive + 4)) | Drive | (uint8_t)(DigitalOutputMask::DMA) | (uint8_t)(DigitalOutputMask::Reset));
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

    DMARead();

    WriteData((uint8_t)(Command::ReadSector) | (uint8_t)(CommandExtension::Multitrack) | (uint8_t)(CommandExtension::SkipDeleted) | (uint8_t)(CommandExtension::Density));
    WriteData(Head << 2 | Drive);
    WriteData(Track);
    WriteData(Head);
    WriteData(Sector);
    WriteData(0x02);
    WriteData(0x12);
    WriteData(0x1B);
    WriteData(0xFF);

    Wait();

    for (int i = 0; i < 7; ++i) {
        ReadData();
    }

    CommandCheckInterrupt(&status0, &cylinder);

//    Memory::Copy((uint8_t *)(DMAAddress_), (uint8_t *)(Address), 512);
}

int FDC::CommandCalibrate(uint8_t Drive) {
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
//        Wait();
        CommandCheckInterrupt(&status0, &cylinder);

        if (!cylinder) {
            DisableMotor(Drive);
            return 0;
        }
    }

    DisableMotor(Drive);
    return -2;
}

void FDC::CommandCheckInterrupt(uint8_t *Status, uint8_t *Cylinder) {
    WriteData((uint8_t)Command::CheckInterrupt);
    *Status = ReadData();
    *Cylinder = ReadData();
}

int FDC::CommandSeek(uint8_t Cylinder, uint8_t Head, uint8_t Drive) {
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
//        Wait();
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