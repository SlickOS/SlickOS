#include <Device/PIC.hpp>
#include <stdint.h>

using namespace Device;

extern "C" {
    extern void AMD64_PIC_EnableIRQ(uint64_t IRQ);
}

void PIC::EnableIRQ(uint8_t IRQ) {
    AMD64_PIC_EnableIRQ(IRQ);
}