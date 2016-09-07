#pragma once

#include <stdint.h>

namespace Device {
    class PS2Controller {
    public:
        enum class Device {
            Primary = 0x00,
            Secondary = 0x01
        };

        static void EnableChannel(Device Channel);
        static void DisableChannel(Device Channel);

        static bool Test(void);
        static bool TestChannel(Device Channel);

        // static void WriteData(uint8_t Value);
        // static uint8_t ReadData(void);

        // static void WriteCommand(uint8_t Value);
        // static uint8_t ReadStatus(void);

        static uint8_t ReadConfiguration(void);
        static void WriteConfiguration(uint8_t Value);

        static bool Init(void);

        static bool Available(Device Channel);

        static void BufferOutput(void);
        static void BufferInput(void);

    private:
        static bool PrimaryAvailable_;
        static bool SecondaryAvailable_;
    };
}