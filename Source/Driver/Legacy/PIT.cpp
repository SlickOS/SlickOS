#include <Driver/Legacy/PIT.hpp>
#include <Driver/Legacy/PIC.hpp>
#include <Driver/Port.hpp>

#include <Driver/Console.hpp>
using Console = Driver::Console;

using Port = Driver::Port;
using PIT = Driver::Legacy::PIT;
using PIC = Driver::Legacy::PIC;

void PIT::Handler(IDT::ISRPack Pack) {
//    Console::Print("Handler, Bitch!\n");
    Tick_++;
}
void PIT::Init(void) {
    PIC::Instance().SetHandler(0x00, &PIT::Handler);
    SetFrequency(1000);
}
void PIT::SetFrequency(uint32_t Frequency) {
    uint32_t divisor = 1193180 / Frequency;
    Port::OutputByte(0x0043, 0x36);
    uint8_t low = (uint8_t)(divisor & 0xFF);
    uint8_t high = (uint8_t)((divisor >> 8) & 0xFF);
    Port::OutputByte(0x0040, low);
    Port::OutputByte(0x0040, high);
    Tick_ = 0x00;
}

void PIT::Sleep(uint64_t Time) {
    uint64_t tick = Tick_ + Time;
    while (Tick_ < tick) {
        asm volatile("hlt");
        Console::PutChar(0);
    }
}

uint64_t PIT::Tick_;