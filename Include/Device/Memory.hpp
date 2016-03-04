#pragma once

#include <stdint.h>

namespace Device {
    class Memory {
    public:
        static bool Equal(const uint8_t *Dest, const uint8_t *Src, uint64_t Length);
        static void Copy(uint8_t *Dest, const uint8_t *Src, uint64_t Length);
        static void Set(uint8_t *Dest, uint8_t Value, uint64_t Length);

        static void *Allocate(void);
        static void Free(void *Address);
    };
}