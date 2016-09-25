#include <Device/PhysicalMemory.hpp>

using namespace Device;

uint64_t PhysicalMemory::GetTotalMemorySize(void) {
    return PhysicalMemory::TotalPhysicalMemory_;
}