#pragma once

#include <stdint.h>

namespace Gloss {
    class CPU86 {
    public:
        static void ID(uint32_t *a, uint32_t *b, uint32_t *c, uint32_t *d);
    };
}