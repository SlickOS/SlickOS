#include <Driver/CPU/IDT.hpp>

using IDT = Driver::CPU::IDT;

extern "C" {
    extern void FlushIDT(uint32_t);
}

void IDT::Flush(void) {
    FlushIDT((uint64_t)&Descriptor_);
}