#include <Driver/Legacy/PIC.hpp>
#include <Driver/CPU/IDT.hpp>

using PIC = Driver::Legacy::PIC;
using IDT = Driver::CPU::IDT;

IDT::ISRCallback PIC::GetHandler(uint8_t Vector) {
    return Callbacks_[Vector];
}