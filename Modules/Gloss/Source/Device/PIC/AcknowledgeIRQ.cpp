#include <Device/PIC.hpp>
#include <stdint.h>

using namespace Device;

extern "C" {
    extern void AMD64_PIC_AcknowledgeIRQ(uint64_t IRQ);
}

void PIC::AcknowledgeIRQ(uint8_t IRQ) {
    AMD64_PIC_AcknowledgeIRQ(IRQ);
}