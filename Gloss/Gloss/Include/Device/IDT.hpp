#pragma once

#include <stdint.h>

namespace Device {
    class IDT {
    public:
        static void SetHandler(uint8_t Interrupt, uint64_t Address);
    };
}