#include <Driver/CPU/IDT.hpp>

using IDT = Driver::CPU::IDT;

IDT &IDT::Instance(void) {
    if (!Instance_) {
        IDT();
    }
    return *Instance_;
}

IDT *IDT::Instance_;