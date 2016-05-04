#include <Device/PS2Controller.hpp>
#include <Device/Port.hpp>

#include <stdint.h>

using namespace Device;

void PS2Controller::WriteConfiguration(uint8_t Value) {
    Port::OutputByte(0x64, 0x60);
    PS2Controller::BufferInput();
    Port::OutputByte(0x60, Value);
}