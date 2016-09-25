#include <Device/PS2Controller.hpp>
#include <Device/Port.hpp>

#include <stdint.h>

using namespace Device;

uint8_t PS2Controller::ReadConfiguration(void) {
    Port::OutputByte(0x64, 0x20);
    PS2Controller::BufferOutput();
    return Port::InputByte(0x60);
}