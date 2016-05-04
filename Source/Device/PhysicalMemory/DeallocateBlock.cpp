#include <Device/PhysicalMemory.hpp>

using namespace Device;

void PhysicalMemory::DeallocateBlock(void *Address) {
    uint64_t address = (uint64_t)Address;
    uint64_t page = address / PhysicalMemory::GetBlockSize();

    ClearBlock(page);

    PhysicalMemory::UsedBlocks_--;
}

void PhysicalMemory::DeallocateBlock(void *Address, uint64_t Size) {
    uint64_t address = (uint64_t)Address;
    uint64_t page = address / PhysicalMemory::GetBlockSize();

    for (uint64_t i = 0; i < Size; ++i) {
        ClearBlock(page + i);
    }

    PhysicalMemory::UsedBlocks_ -= Size;
}