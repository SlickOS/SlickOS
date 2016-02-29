#include <Driver/Memory.hpp>

using Memory = Driver::Memory;

bool Memory::Equal(const uint8_t *Dest, const uint8_t *Src, uint64_t Size) {
    for (; Size--; Src++, Dest++) {
        if (*Src != *Dest) {
            return false;
        }
    }
    return true;
}

void Memory::Copy(uint8_t *Dest, const uint8_t *Src, uint64_t Size) {
    for (; Size--; Src++, Dest++) {
        *Dest = *Src;
    }
}

void Memory::Set(uint8_t *Dest, uint8_t Value, uint64_t Size) {
    for (; Size--; Dest++) {
        *Dest = Value;
    }
}