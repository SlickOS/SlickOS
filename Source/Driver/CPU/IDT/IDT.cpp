#include <Driver/CPU/IDT.hpp>
#include <Driver/Memory.hpp>

using IDT = Driver::CPU::IDT;
using Memory = Driver::Memory;

extern "C" {
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
}

IDT::IDT(void) {
    Descriptor_.Limit = (sizeof(IDT::Entry) * 0x0100) - 0x01;
    Descriptor_.Offset = (uint64_t)&Entries_;

    Memory::Set((uint8_t *)(Entries_), 0x00, sizeof(IDT::Entry) * 0x0100);
    Memory::Set((uint8_t *)(Callbacks_), 0x00, sizeof(ISRCallback) * 0x0100);

    // Initialize CPU Exception Handlers
    SetGate(0x00, (uint64_t)ISRCallx00, 0x08, 0x8E);
    SetGate(0x01, (uint64_t)ISRCallx01, 0x08, 0x8E);
    SetGate(0x02, (uint64_t)ISRCallx02, 0x08, 0x8E);
    SetGate(0x03, (uint64_t)ISRCallx03, 0x08, 0x8E);
    SetGate(0x04, (uint64_t)ISRCallx04, 0x08, 0x8E);
    SetGate(0x05, (uint64_t)ISRCallx05, 0x08, 0x8E);
    SetGate(0x06, (uint64_t)ISRCallx06, 0x08, 0x8E);
    SetGate(0x07, (uint64_t)ISRCallx07, 0x08, 0x8E);
    SetGate(0x08, (uint64_t)ISRCallx08, 0x08, 0x8E);
    SetGate(0x09, (uint64_t)ISRCallx09, 0x08, 0x8E);
    SetGate(0x0A, (uint64_t)ISRCallx0A, 0x08, 0x8E);
    SetGate(0x0B, (uint64_t)ISRCallx0B, 0x08, 0x8E);
    SetGate(0x0C, (uint64_t)ISRCallx0C, 0x08, 0x8E);
    SetGate(0x0D, (uint64_t)ISRCallx0D, 0x08, 0x8E);
    SetGate(0x0E, (uint64_t)ISRCallx0E, 0x08, 0x8E);
    SetGate(0x0F, (uint64_t)ISRCallx0F, 0x08, 0x8E);
    SetGate(0x10, (uint64_t)ISRCallx10, 0x08, 0x8E);
    SetGate(0x11, (uint64_t)ISRCallx11, 0x08, 0x8E);
    SetGate(0x12, (uint64_t)ISRCallx12, 0x08, 0x8E);
    SetGate(0x13, (uint64_t)ISRCallx13, 0x08, 0x8E);
    SetGate(0x14, (uint64_t)ISRCallx14, 0x08, 0x8E);
    SetGate(0x15, (uint64_t)ISRCallx15, 0x08, 0x8E);
    SetGate(0x16, (uint64_t)ISRCallx16, 0x08, 0x8E);
    SetGate(0x17, (uint64_t)ISRCallx17, 0x08, 0x8E);
    SetGate(0x18, (uint64_t)ISRCallx18, 0x08, 0x8E);
    SetGate(0x19, (uint64_t)ISRCallx19, 0x08, 0x8E);
    SetGate(0x1A, (uint64_t)ISRCallx1A, 0x08, 0x8E);
    SetGate(0x1B, (uint64_t)ISRCallx1B, 0x08, 0x8E);
    SetGate(0x1C, (uint64_t)ISRCallx1C, 0x08, 0x8E);
    SetGate(0x1D, (uint64_t)ISRCallx1D, 0x08, 0x8E);
    SetGate(0x1E, (uint64_t)ISRCallx1E, 0x08, 0x8E);
    SetGate(0x1F, (uint64_t)ISRCallx1F, 0x08, 0x8E);

    Flush();

    Instance_ = this;
}