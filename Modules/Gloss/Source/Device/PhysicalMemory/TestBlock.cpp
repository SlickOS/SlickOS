#include <Device/PhysicalMemory.hpp>

using namespace Device;

bool PhysicalMemory::TestBlock(uint64_t Page) {
    return PhysicalMemory::MemoryMap_[Page / 0x40] & (1 << (Page % 0x40));
}