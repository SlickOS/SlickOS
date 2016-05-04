#include <Device/PhysicalMemory.hpp>

#include <Device/Console.hpp>

using namespace Device;

void *PhysicalMemory::AllocateBlock(void) {
    if (PhysicalMemory::GetFreeBlocks() == 0) {
        return 0x00;
    }

    uint64_t page = PhysicalMemory::FirstAvailable();

    if (page == ~(0x00)) {
        return 0x00;
    }

    SetBlock(page);
    uint64_t address = page * PhysicalMemory::GetBlockSize();
    PhysicalMemory::UsedBlocks_++;
    return (void *)(address);
}

void *PhysicalMemory::AllocateBlock(uint64_t Size) {
    if (Size == 0x00) {
        return 0x00;
    }

    if (Size == 0x01) {
        return PhysicalMemory::AllocateBlock();
    }

    if (PhysicalMemory::GetFreeBlocks() <= Size) {
        return 0x00;
    }

    uint64_t page = PhysicalMemory::FirstAvailable(Size);

    if (page == ~(0x00)) {
        return 0x00;
    }

    for (uint64_t i = 0; i < Size; ++i) {
        SetBlock(page + i);
    }

    uint64_t address = page * PhysicalMemory::GetBlockSize();
    PhysicalMemory::UsedBlocks_ += Size;
    return (void *)(address);
}