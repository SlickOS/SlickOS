#include <Driver/Memory.hpp>

namespace Memory = Driver::Memory;

bool Memory::Equal(const uint8_t *Src, const uint8_t *Dest, uint64_t Size) {
    for (; Size--; Src++, Dest++) {
        if (*Src != *Dest) {
            return false;
        }
    }
    return true;
}

void Memory::Copy(const uint8_t *Src, uint8_t *Dest, uint64_t Size) {
    for (; Size--; Src++, Dest++) {
        *Dest = *Src;
    }
}