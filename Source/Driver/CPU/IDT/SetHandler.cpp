#include <Driver/CPU/IDT.hpp>

using IDT = Driver::CPU::IDT;

void IDT::SetHandler(uint8_t Vector, ISRCallback Handler) {
    Callbacks_[Vector] = Handler;
}