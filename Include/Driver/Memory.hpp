#pragma once

#include <stdint.h>

namespace Driver {
    class Memory {
    public:
        static bool Equal(const uint8_t *Dest, const uint8_t *Src, uint64_t Size);
        static void Copy(uint8_t *Dest, const uint8_t *Src, uint64_t Size);
        static void Set(uint8_t *Dest, uint8_t Value, uint64_t Size);
    };
}

// class Memory {
// public:
//     enum class PageEntryMask {
//         WriteEnable = 0x01,
//         UserEnable = 0x02,
//         WriteThrough = 0x04,
//         WriteCache = 0x08,
//         Accessed = 0x10,
//         Dirty = 0x20,
//         PAT = 0x40,
//         Size = 0x40,
//         Global = 0x80
//     };

//     static inline void FlushTLB(uint64_t Address) {
//         asm volatile("invlpg (%0)" : : "r"Address : "memory");
//     }

//     static void SetPML4(uint64_t Address);

//     static bool Map(uint64_t Address, uint64_t Physical);
//     static bool Unmap(uint64_t Address);
// }    