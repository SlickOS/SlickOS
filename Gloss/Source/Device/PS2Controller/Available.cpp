#include <Device/PS2Controller.hpp>

using namespace Device;

bool PS2Controller::Available(PS2Controller::Device Channel) {
    if (Channel == Device::Primary) return PrimaryAvailable_;
    if (Channel == Device::Secondary) return SecondaryAvailable_;
    return false;
}

bool PS2Controller::PrimaryAvailable_;
bool PS2Controller::SecondaryAvailable_;