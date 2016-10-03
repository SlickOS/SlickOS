#pragma once

#include <stdint.h>

class Memory {
public:
    static bool Equal(const uint8_t *Dest, const uint8_t *Src, uint64_t Length);
};