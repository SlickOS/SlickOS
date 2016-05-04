#include <Device/PS2Controller.hpp>
#include <Device/Port.hpp>

#include <stdint.h>

using namespace Device;

bool PS2Controller::TestChannel(PS2Controller::Device Channel) {
    if (Channel == Device::Primary) {
        Port::OutputByte(0x64, 0xAB);
    }
    else if (Channel == Device::Secondary) {
        Port::OutputByte(0x64, 0xA9);
    }
    PS2Controller::BufferOutput();
    uint8_t status = Port::InputByte(0x60);
    if (status != 0x00) {
        return false;
    }
    return true;
}