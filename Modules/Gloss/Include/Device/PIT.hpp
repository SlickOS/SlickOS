#pragma once

#include <stdint.h>

namespace Device {
    class PIT {
    public:
        static void Handler(uint64_t Error, uint64_t Vector);
        static bool Init(void);
        static void SetFrequency(uint32_t Frequency);
        static void Sleep(int64_t Time);

    private:
        static uint32_t Frequency_;
        static volatile int64_t Tick_;
        static uint8_t IRQNumber_;
        static uint8_t InterruptVector_;
    };
}