#include <Driver/Core/IDT.hpp>
#include <Driver/Core/HardwarePort.hpp>
#include <Driver/Terminal/Console.hpp>

//#include "PIT.hpp"

extern "C" {
    extern void FlushIDT(uint32_t);
    extern void ISRCallx00(void);
    extern void ISRCallx01(void);
    extern void ISRCallx02(void);
    extern void ISRCallx03(void);
    extern void ISRCallx04(void);
    extern void ISRCallx05(void);
    extern void ISRCallx06(void);
    extern void ISRCallx07(void);
    extern void ISRCallx08(void);
    extern void ISRCallx09(void);
    extern void ISRCallx0A(void);
    extern void ISRCallx0B(void);
    extern void ISRCallx0C(void);
    extern void ISRCallx0D(void);
    extern void ISRCallx0E(void);
    extern void ISRCallx0F(void);
    extern void ISRCallx10(void);
    extern void ISRCallx11(void);
    extern void ISRCallx12(void);
    extern void ISRCallx13(void);
    extern void ISRCallx14(void);
    extern void ISRCallx15(void);
    extern void ISRCallx16(void);
    extern void ISRCallx17(void);
    extern void ISRCallx18(void);
    extern void ISRCallx19(void);
    extern void ISRCallx1A(void);
    extern void ISRCallx1B(void);
    extern void ISRCallx1C(void);
    extern void ISRCallx1D(void);
    extern void ISRCallx1E(void);
    extern void ISRCallx1F(void);
    extern void ISRCallx20(void);
    extern void ISRCallx21(void);
    extern void ISRCallx22(void);
    extern void ISRCallx23(void);
    extern void ISRCallx24(void);
    extern void ISRCallx25(void);
    extern void ISRCallx26(void);
    extern void ISRCallx27(void);
    extern void ISRCallx28(void);
    extern void ISRCallx29(void);
    extern void ISRCallx2A(void);
    extern void ISRCallx2B(void);
    extern void ISRCallx2C(void);
    extern void ISRCallx2D(void);
    extern void ISRCallx2E(void);
    extern void ISRCallx2F(void);

    void ISRHandler(IDT::ISRPack Pack) {
        IDT::Handler(Pack);
    }
}

IDT::Entry IDT::Entries_[256];
IDT::IDTR IDT::Descriptor_;
IDT::ISRCallback IDT::Callbacks_[256];

void IDT::Init(void) {
    Descriptor_.Limit = (sizeof(IDT::Entry) * 256) - 1;
    Descriptor_.Offset = (uint64_t)&Entries_;

    uint8_t PICMasterMask = HardwarePort::InputByte(0x0021);
    uint8_t PICSlaveMask = HardwarePort::InputByte(0x00A1);

    HardwarePort::OutputByte(0x0020, 0x11);
    HardwarePort::OutputByte(0x00A0, 0x11);
    HardwarePort::OutputByte(0x0021, 0x20);
    HardwarePort::OutputByte(0x00A1, 0x28);
    HardwarePort::OutputByte(0x0021, 0x04);
    HardwarePort::OutputByte(0x00A1, 0x02);
    HardwarePort::OutputByte(0x0021, 0x01);
    HardwarePort::OutputByte(0x00A1, 0x01);
    HardwarePort::OutputByte(0x0021, PICMasterMask);
    HardwarePort::OutputByte(0x00A1, PICSlaveMask);

    IDT::SetGate(0x00, (uint64_t)ISRCallx00, 0x08, 0x8E);
    IDT::SetGate(0x01, (uint64_t)ISRCallx01, 0x08, 0x8E);
    IDT::SetGate(0x02, (uint64_t)ISRCallx02, 0x08, 0x8E);
    IDT::SetGate(0x03, (uint64_t)ISRCallx03, 0x08, 0x8E);
    IDT::SetGate(0x04, (uint64_t)ISRCallx04, 0x08, 0x8E);
    IDT::SetGate(0x05, (uint64_t)ISRCallx05, 0x08, 0x8E);
    IDT::SetGate(0x06, (uint64_t)ISRCallx06, 0x08, 0x8E);
    IDT::SetGate(0x07, (uint64_t)ISRCallx07, 0x08, 0x8E);
    IDT::SetGate(0x08, (uint64_t)ISRCallx08, 0x08, 0x8E);
    IDT::SetGate(0x09, (uint64_t)ISRCallx09, 0x08, 0x8E);
    IDT::SetGate(0x0A, (uint64_t)ISRCallx0A, 0x08, 0x8E);
    IDT::SetGate(0x0B, (uint64_t)ISRCallx0B, 0x08, 0x8E);
    IDT::SetGate(0x0C, (uint64_t)ISRCallx0C, 0x08, 0x8E);
    IDT::SetGate(0x0D, (uint64_t)ISRCallx0D, 0x08, 0x8E);
    IDT::SetGate(0x0E, (uint64_t)ISRCallx0E, 0x08, 0x8E);
    IDT::SetGate(0x0F, (uint64_t)ISRCallx0F, 0x08, 0x8E);
    IDT::SetGate(0x10, (uint64_t)ISRCallx10, 0x08, 0x8E);
    IDT::SetGate(0x11, (uint64_t)ISRCallx11, 0x08, 0x8E);
    IDT::SetGate(0x12, (uint64_t)ISRCallx12, 0x08, 0x8E);
    IDT::SetGate(0x13, (uint64_t)ISRCallx13, 0x08, 0x8E);
    IDT::SetGate(0x14, (uint64_t)ISRCallx14, 0x08, 0x8E);
    IDT::SetGate(0x15, (uint64_t)ISRCallx15, 0x08, 0x8E);
    IDT::SetGate(0x16, (uint64_t)ISRCallx16, 0x08, 0x8E);
    IDT::SetGate(0x17, (uint64_t)ISRCallx17, 0x08, 0x8E);
    IDT::SetGate(0x18, (uint64_t)ISRCallx18, 0x08, 0x8E);
    IDT::SetGate(0x19, (uint64_t)ISRCallx19, 0x08, 0x8E);
    IDT::SetGate(0x1A, (uint64_t)ISRCallx1A, 0x08, 0x8E);
    IDT::SetGate(0x1B, (uint64_t)ISRCallx1B, 0x08, 0x8E);
    IDT::SetGate(0x1C, (uint64_t)ISRCallx1C, 0x08, 0x8E);
    IDT::SetGate(0x1D, (uint64_t)ISRCallx1D, 0x08, 0x8E);
    IDT::SetGate(0x1E, (uint64_t)ISRCallx1E, 0x08, 0x8E);
    IDT::SetGate(0x1F, (uint64_t)ISRCallx1F, 0x08, 0x8E);
    IDT::SetGate(0x20, (uint64_t)ISRCallx20, 0x08, 0x8E);
    IDT::SetGate(0x21, (uint64_t)ISRCallx21, 0x08, 0x8E);
    IDT::SetGate(0x22, (uint64_t)ISRCallx22, 0x08, 0x8E);
    IDT::SetGate(0x23, (uint64_t)ISRCallx23, 0x08, 0x8E);
    IDT::SetGate(0x24, (uint64_t)ISRCallx24, 0x08, 0x8E);
    IDT::SetGate(0x25, (uint64_t)ISRCallx25, 0x08, 0x8E);
    IDT::SetGate(0x26, (uint64_t)ISRCallx26, 0x08, 0x8E);
    IDT::SetGate(0x27, (uint64_t)ISRCallx27, 0x08, 0x8E);
    IDT::SetGate(0x28, (uint64_t)ISRCallx28, 0x08, 0x8E);
    IDT::SetGate(0x29, (uint64_t)ISRCallx29, 0x08, 0x8E);
    IDT::SetGate(0x2A, (uint64_t)ISRCallx2A, 0x08, 0x8E);
    IDT::SetGate(0x2B, (uint64_t)ISRCallx2B, 0x08, 0x8E);
    IDT::SetGate(0x2C, (uint64_t)ISRCallx2C, 0x08, 0x8E);
    IDT::SetGate(0x2D, (uint64_t)ISRCallx2D, 0x08, 0x8E);
    IDT::SetGate(0x2E, (uint64_t)ISRCallx2E, 0x08, 0x8E);
    IDT::SetGate(0x2F, (uint64_t)ISRCallx2F, 0x08, 0x8E);

//    IDT::SetHandler(0x20, &PIT::Handler);

    IDT::Flush();
}
void IDT::Flush(void) {
    FlushIDT((uint64_t)&Descriptor_);
}

void IDT::SetGate(uint8_t Vector, uint64_t Offset, uint16_t Selector, uint8_t Flags) {
    Entries_[Vector].OffsetLow = Offset & 0xFFFF;
    Entries_[Vector].OffsetHigh = (Offset >> 16) & 0xFFFF;
    Entries_[Vector].OffsetLong = (Offset >> 32) & 0xFFFFFFFF;

    Entries_[Vector].Selector = Selector;
    Entries_[Vector].Flags = Flags;
}

void IDT::Handler(ISRPack Pack) {
//    Console::Print("Recieved Interrupt: Vector ");
//    Console::PrintHex((uint8_t)Pack.Vector);
//    Console::PutChar('\n');
    if (Pack.Vector >= 0x20 && Pack.Vector <= 0x2F) {
        IDT::IRQHandler(Pack);
    }
}

void IDT::IRQHandler(ISRPack Pack) {
//    Console::Print("Recieved IRQ: Vector ");
//    Console::PrintHex((uint8_t)(Pack.Vector));
//    Console::PutChar('\n');
    if (Callbacks_[Pack.Vector] != 0x00) {
        ISRCallback handler = Callbacks_[Pack.Vector];
        handler(Pack);
    }
    if (Pack.Vector >= 0x28) {
        HardwarePort::OutputByte(0x00A0, 0x20);
    }
    HardwarePort::OutputByte(0x0020, 0x20);
}

void IDT::SetHandler(uint8_t Vector, ISRCallback Handler) {
    Callbacks_[Vector] = Handler;
}