#include <Device/PhysicalMemory.hpp>

using namespace Device;

uint64_t PhysicalMemory::FirstAvailable(void) {
    for (uint64_t i = 0x00; i < PhysicalMemory::GetTotalBlocks(); ++i) {
        if (MemoryMap_[i] != 0xFFFFFFFFFFFFFFFF) {
            for (uint8_t j = 0x00; j < 0x40; ++j) {
                uint64_t bit = 0x01 << j;
                if (!MemoryMap_[i] & bit) {
                    return i * 0x40 + j;
                }
            }
        }
    }
    return ~(0x00);
}

uint64_t PhysicalMemory::FirstAvailable(uint64_t Size) {
    if (Size == 0x00) {
        return ~(0x00);
    }
    if (Size == 0x01) {
        return PhysicalMemory::FirstAvailable();
    }

    for (uint64_t i = 0x00; i < PhysicalMemory::GetTotalBlocks(); ++i) {
        if (MemoryMap_[i] != 0xFFFFFFFFFFFFFFFF) {
            for (uint8_t j = 0x00; j < 0x40; ++j) {
                uint64_t bit = 0x01 << j;
                if (!MemoryMap_[i] & bit) {
                    int firstPage = i * 0x40 + j;
                    uint64_t available = 0x00;
                    for (uint64_t k = 0; k < Size; ++k) {
                        if (!PhysicalMemory::TestBlock(firstPage + k)) {
                            available++;
                        }
                        if (available == Size) {
                            return firstPage;
                        }
                    }
                }
            }
        }
    }
    return ~(0x00);
}