#pragma once

#include <stdint.h>
#include "IDT.hpp"

class PIT {
public:
    static void Handler(IDT::ISRPack Pack);
    static void Init(void);
    static void SetFrequency(uint32_t Frequency);

private:
    static uint64_t Tick_;
};