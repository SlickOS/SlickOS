#include <Driver/Legacy/PIC.hpp>
#include <Driver/CPU/IDT.hpp>
#include <Driver/Port.hpp>
#include <Driver/Memory.hpp>

using PIC = Driver::Legacy::PIC;
using IDT = Driver::CPU::IDT;
using Port = Driver::Port;
using Memory = Driver::Memory;

extern "C" {
    extern void SetIRQHandlers();
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
}

PIC::PIC(void) {
    uint8_t PICMasterMask = Port::InputByte(0x0021);
    uint8_t PICSlaveMask = Port::InputByte(0x00A1);

    Memory::Set((uint8_t *)(Callbacks_), 0x00, sizeof(IDT::ISRCallback) * 0x10);

    SetIRQHandlers();

    Port::OutputByte(0x0020, 0x11);
    Port::OutputByte(0x00A0, 0x11);
    Port::OutputByte(0x0021, 0x20);
    Port::OutputByte(0x00A1, 0x28);
    Port::OutputByte(0x0021, 0x04);
    Port::OutputByte(0x00A1, 0x02);
    Port::OutputByte(0x0021, 0x01);
    Port::OutputByte(0x00A1, 0x01);
    Port::OutputByte(0x0021, PICMasterMask);
    Port::OutputByte(0x00A1, PICSlaveMask);

    IDT &instance = IDT::Instance();

    instance.SetGate(0x20, (uint64_t)ISRCallx20, 0x08, 0x8E);
    instance.SetGate(0x21, (uint64_t)ISRCallx21, 0x08, 0x8E);
    instance.SetGate(0x22, (uint64_t)ISRCallx22, 0x08, 0x8E);
    instance.SetGate(0x23, (uint64_t)ISRCallx23, 0x08, 0x8E);
    instance.SetGate(0x24, (uint64_t)ISRCallx24, 0x08, 0x8E);
    instance.SetGate(0x25, (uint64_t)ISRCallx25, 0x08, 0x8E);
    instance.SetGate(0x26, (uint64_t)ISRCallx26, 0x08, 0x8E);
    instance.SetGate(0x27, (uint64_t)ISRCallx27, 0x08, 0x8E);
    instance.SetGate(0x28, (uint64_t)ISRCallx28, 0x08, 0x8E);
    instance.SetGate(0x29, (uint64_t)ISRCallx29, 0x08, 0x8E);
    instance.SetGate(0x2A, (uint64_t)ISRCallx2A, 0x08, 0x8E);
    instance.SetGate(0x2B, (uint64_t)ISRCallx2B, 0x08, 0x8E);
    instance.SetGate(0x2C, (uint64_t)ISRCallx2C, 0x08, 0x8E);
    instance.SetGate(0x2D, (uint64_t)ISRCallx2D, 0x08, 0x8E);
    instance.SetGate(0x2E, (uint64_t)ISRCallx2E, 0x08, 0x8E);
    instance.SetGate(0x2F, (uint64_t)ISRCallx2F, 0x08, 0x8E);

    Instance_ = this;
}