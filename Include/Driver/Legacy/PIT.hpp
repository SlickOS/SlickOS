#pragma once

#include <stdint.h>
#include <Driver/CPU/IDT.hpp>

using IDT = Driver::CPU::IDT;

namespace Driver {
    namespace Legacy {
        class PIT {
        public:
            static void Handler(IDT::ISRPack Pack);
            static void Init(void);
            static void SetFrequency(uint32_t Frequency);

        private:
            static uint64_t Tick_;
        };
    }
}