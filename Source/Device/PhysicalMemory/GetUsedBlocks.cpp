#include <Device/PhysicalMemory.hpp>

using namespace Device;

uint64_t PhysicalMemory::GetUsedBlocks(void) {
    return PhysicalMemory::UsedBlocks_;
}