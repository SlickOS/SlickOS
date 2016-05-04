#include <Device/PhysicalMemory.hpp>

using namespace Device;

void PhysicalMemory::ClearBlock(uint64_t Page) {
    PhysicalMemory::MemoryMap_[Page / 0x40] &= ~(1 << (Page % 0x40));
}