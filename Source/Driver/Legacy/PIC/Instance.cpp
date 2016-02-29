#include <Driver/Legacy/PIC.hpp>

using PIC = Driver::Legacy::PIC;

PIC &PIC::Instance(void) {
    if (!Instance_) {
        PIC();
    }
    return *Instance_;
}

PIC *PIC::Instance_;