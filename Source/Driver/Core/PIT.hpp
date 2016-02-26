#pragma once

#include <stdint.h>
#include "HardwarePort.hpp"

class PIT {
public:
    static void Handler(IDT::ISRPack Pack) {
        tick++;
        if (tick % 1000 == 0x00) {
            Console::Print("PIT Interrupt: Tick #");
            Console::PrintDecimal(tick/1000);
            Console::PutChar('\n');
        }
    }
    static void SetFrequency(uint32_t Frequency) {
        IDT::SetHandler(0x20, &PIT::Handler);
        uint32_t divisor = 1193180 / Frequency;
        HardwarePort::OutputByte(0x0043, 0x36);
        uint8_t low = (uint8_t)(divisor & 0xFF);
        uint8_t high = (uint8_t)((divisor >> 8) & 0xFF);
        HardwarePort::OutputByte(0x0040, low);
        HardwarePort::OutputByte(0x0040, high);
    }

private:
    static uint64_t tick;
};

uint64_t PIT::tick;