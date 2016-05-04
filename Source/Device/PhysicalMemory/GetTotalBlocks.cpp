#include <Device/PhysicalMemory.hpp>

using namespace Device;

uint64_t PhysicalMemory::GetTotalBlocks(void) {
    return PhysicalMemory::TotalBlocks_;
}