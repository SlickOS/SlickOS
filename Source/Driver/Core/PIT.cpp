#include <Driver/Legacy/PIT.hpp>
#include <Driver/Port.hpp>

using IDT = Driver::CPU::IDT;
using Port = Driver::Port;
using PIT = Driver::Legacy::PIT;

void PIT::Handler(IDT::ISRPack Pack) {
    Tick_++;
}
void PIT::Init(void) {
    IDT::SetHandler(0x20, &PIT::Handler);
    SetFrequency(1000);
}
void PIT::SetFrequency(uint32_t Frequency) {
    uint32_t divisor = 1193180 / Frequency;
    Port::OutputByte(0x0043, 0x36);
    uint8_t low = (uint8_t)(divisor & 0xFF);
    uint8_t high = (uint8_t)((divisor >> 8) & 0xFF);
    Port::OutputByte(0x0040, low);
    Port::OutputByte(0x0040, high);
}

uint64_t PIT::Tick_;