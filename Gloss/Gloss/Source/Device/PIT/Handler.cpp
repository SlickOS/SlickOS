#include <Device/PIT.hpp>
#include <Device/PIC.hpp>

#include <stdint.h>

using namespace Device;

void PIT::Handler(uint64_t Error, uint64_t Vector) {
    PIT::Tick_++;
    PIC::AcknowledgeIRQ(0x00);
}