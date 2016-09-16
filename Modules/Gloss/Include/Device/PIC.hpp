#pragma once

#include <stdint.h>

namespace Device {
    class PIC {
    public:
        static void EnableIRQ(uint8_t IRQ);
        static void DisableIRQ(uint8_t IRQ);
        static void AcknowledgeIRQ(uint8_t IRQ);
    };
}