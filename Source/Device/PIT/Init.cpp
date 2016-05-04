#include <Device/PIT.hpp>
#include <Device/PIC.hpp>
#include <Device/IDT.hpp>

#include <stdint.h>

using namespace Device;

bool PIT::Init(void) {
    PIT::Tick_ = 0x00;
    PIT::InterruptVector_ = 0x20;
    PIT::IRQNumber_ = 0x00;
    PIT::SetFrequency(1000);

    IDT::SetHandler(PIT::InterruptVector_, (uint64_t)&PIT::Handler);
    PIC::EnableIRQ(PIT::IRQNumber_);

    return true;
}

uint32_t PIT::Frequency_;
volatile int64_t PIT::Tick_;
uint8_t PIT::IRQNumber_;
uint8_t PIT::InterruptVector_;