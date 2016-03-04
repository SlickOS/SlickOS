#pragma once

#include <stdint.h>

namespace Device {
    class FDC {
    public:
        static void Handler(uint64_t Error, uint64_t Vector);
        static bool Init(void);

        static void Reset(void);

    private:

    };
}