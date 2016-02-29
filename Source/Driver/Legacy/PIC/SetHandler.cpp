#include <Driver/Legacy/PIC.hpp>
#include <Driver/CPU/IDT.hpp>

using PIC = Driver::Legacy::PIC;
using IDT = Driver::CPU::IDT;

void PIC::SetHandler(uint8_t Vector, IDT::ISRCallback Handler) {
    Callbacks_[Vector] = Handler;
}