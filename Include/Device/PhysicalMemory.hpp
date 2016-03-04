#pragma once

#include <stdint.h>

namespace Device {
    class PhysicalMemory {
    public:
        static bool Init(void);

        static void *AllocateBlock(void);
        static void *AllocateBlock(uint64_t Size);
        static void DeallocateBlock(void *Address);
        static void DeallocateBlock(void *Address, uint64_t Size);

        static uint64_t GetTotalMemorySize(void);
        static uint64_t GetBlockSize(void);
        static uint64_t GetTotalBlocks(void);
        static uint64_t GetUsedBlocks(void);
        static uint64_t GetFreeBlocks(void);

    private:
        static void SetBlock(uint64_t Page);
        static void ClearBlock(uint64_t Page);
        static bool TestBlock(uint64_t Page);

        static uint64_t FirstAvailable(void);
        static uint64_t FirstAvailable(uint64_t Size);

        static void SetRegion(uint64_t Address, uint64_t Size);
        static void ClearRegion(uint64_t Address, uint64_t Size);

        static uint64_t TotalPhysicalMemory_;
        static uint64_t TotalBlocks_;
        static uint64_t UsedBlocks_;
        static uint64_t *MemoryMap_;
    };
}