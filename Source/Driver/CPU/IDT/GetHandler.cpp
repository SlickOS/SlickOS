#include <Driver/CPU/IDT.hpp>

using IDT = Driver::CPU::IDT;

IDT::ISRCallback IDT::GetHandler(uint8_t Vector) {
    return Callbacks_[Vector];
}