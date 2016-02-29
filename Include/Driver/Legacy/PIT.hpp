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

            static void Sleep(uint64_t Time);

        private:
            static uint64_t Tick_;
        };
    }
}