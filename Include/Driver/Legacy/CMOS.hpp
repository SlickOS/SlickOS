#pragma once

#include <stdint.h>

namespace Driver {
    namespace Legacy {
        class CMOS {
        public:
            enum class Register {
                TimeSecond = 0x00,
                TimeMinute = 0x02,
                TimeHour = 0x04,
                TimeWeekday = 0x06,
                TimeDay = 0x07,
                TimeMonth = 0x08,
                TimeYear = 0x09,
                StatusA = 0x0A,
                StatusB = 0x0B,
                FloppyType = 0x10,
                TimeCentury = 0x32
            };
            enum class Port {
                Address = 0x70,
                Data = 0x71
            };

            uint8_t Read(Register Type);
        };
    }
}