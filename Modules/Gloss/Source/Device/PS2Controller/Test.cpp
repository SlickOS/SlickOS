#include <Device/PS2Controller.hpp>
#include <Device/Port.hpp>

#include <stdint.h>

using namespace Device;

bool PS2Controller::Test(void) {
    Port::OutputByte(0x64, 0xAA);
    PS2Controller::BufferOutput();
    uint8_t status = Port::InputByte(0x60);
    if (status != 0x55) {
        return false;
    }
    return true;
}