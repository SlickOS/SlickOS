#include <Driver/Memory.hpp>

namespace Memory = Driver::Memory;

bool Memory::Equal(const uint8_t *A, const uint8_t *B, uint64_t Size) {
    for (; Size--; A++, B++) {
        if (*A != *B) {
            return false;
        }
    }
    return true;
}