#include <Device/IDT.hpp>
#include <stdint.h>

using namespace Device;

extern "C" {
    extern void AMD64_IDT_SetHandler(uint64_t Interrupt, uint64_t Address);
}

void IDT::SetHandler(uint8_t Interrupt, uint64_t Address) {
    AMD64_IDT_SetHandler(Interrupt, Address);
}