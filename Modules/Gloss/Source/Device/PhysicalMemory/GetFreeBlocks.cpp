#include <Device/PhysicalMemory.hpp>

using namespace Device;

uint64_t PhysicalMemory::GetFreeBlocks(void) {
    return PhysicalMemory::GetTotalBlocks() - PhysicalMemory::GetUsedBlocks();
}