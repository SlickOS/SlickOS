#include <Device/PS2Controller.hpp>
#include <Device/Port.hpp>

using namespace Device;

void PS2Controller::EnableChannel(PS2Controller::Device Channel) {
    if (Channel == Device::Primary) {
        Port::OutputByte(0x64, 0xAE);
    }
    else if (Channel == Device::Secondary) {
        Port::OutputByte(0x64, 0xA8);
    }
}