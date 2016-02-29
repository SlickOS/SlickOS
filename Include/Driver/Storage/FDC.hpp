#pragma once

#include <stdint.h>
#include <Driver/CPU/IDT.hpp>

using IDT = Driver::CPU::IDT;

namespace Driver {
    namespace Storage {
        class FDC {
        public:
            enum class Register {
                StatusA = 0x00,
                StatusB = 0x01,
                DigitalOutput = 0x02,
                TapeDrive = 0x03,
                Status = 0x04,
                RateSelect = 0x04,
                Data = 0x05,
                DigitalInput = 0x07,
                Control = 0x07
            };
            enum class Controller {
                Primary = 0x03F0,
                Secondary = 0x0370
            };

            static void Handler(IDT::ISRPack Pack);
            static void Init(void);
            
            static void Reset(void);
            static void Wait(void);
        };
    }
}