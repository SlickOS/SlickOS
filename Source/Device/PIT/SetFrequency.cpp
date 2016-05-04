#include <Device/PIT.hpp>
#include <Device/Port.hpp>

#include <stdint.h>

using namespace Device;

void PIT::SetFrequency(uint32_t Frequency) {
    uint32_t divisor = 1193180 / Frequency;
    Port::OutputByte(0x43, 0x36);

    uint8_t low = (uint8_t)(divisor & 0xFF);
    uint8_t high = (uint8_t)((divisor >> 8) & 0xFF);
    Port::OutputByte(0x40, low);
    Port::OutputByte(0x40, high);
}