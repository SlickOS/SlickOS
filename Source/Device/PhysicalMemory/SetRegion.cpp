#include <Device/PhysicalMemory.hpp>

using namespace Device;

void PhysicalMemory::SetRegion(uint64_t Address, uint64_t Size) {
    uint64_t addressAlign = Address / PhysicalMemory::GetBlockSize();
    uint64_t blockCount = Size / PhysicalMemory::GetBlockSize();

    while (blockCount > 0) {
        PhysicalMemory::SetBlock(addressAlign++);
        PhysicalMemory::UsedBlocks_++;
        blockCount--;
    }
}