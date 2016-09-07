#include <Device/PhysicalMemory.hpp>

#include <stdint.h>

using namespace Device;

extern "C" {
    extern uint64_t I8086_Memory_Map_Address;
    extern uint64_t I8086_Memory_Map_Count;
    extern uint64_t I8086_Memory_Map_End;
}

bool PhysicalMemory::Init(void) {
    PhysicalMemory::MemoryMap_ = (uint64_t *)0x1000000;

    TotalPhysicalMemory_ = 0x00;
    for (uint64_t i = 0x00; i < I8086_Memory_Map_Count; ++i) {
        uint64_t offset = i * 0x18;
        uint64_t linear = offset + I8086_Memory_Map_Address;

        TotalPhysicalMemory_ += *((uint64_t *)(linear + 0x08));
    }

    TotalBlocks_ = TotalPhysicalMemory_ / PhysicalMemory::GetBlockSize();

    PhysicalMemory::SetRegion(0x00, TotalPhysicalMemory_);

    for (uint64_t i = 0x00; i < I8086_Memory_Map_Count; ++i) {
        uint64_t offset = i * 0x18;
        uint64_t linear = offset + I8086_Memory_Map_Address;

        uint64_t base = *((uint64_t *)(linear + 0x00));
        uint64_t size = *((uint64_t *)(linear + 0x08));
        uint64_t type = *((uint64_t *)(linear + 0x10)) & 0x00FF;
        if (type == 0x01) {
            PhysicalMemory::ClearRegion(base, size);
        }
    }
    PhysicalMemory::SetRegion(0x0000000, 0x3000000);
    return true;
}

uint64_t PhysicalMemory::TotalPhysicalMemory_;
uint64_t PhysicalMemory::TotalBlocks_;
uint64_t PhysicalMemory::UsedBlocks_;
uint64_t *PhysicalMemory::MemoryMap_;