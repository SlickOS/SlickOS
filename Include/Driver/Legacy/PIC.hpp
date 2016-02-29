#pragma once

#include <Driver/CPU/IDT.hpp>

namespace Driver {
    namespace Legacy {
        class PIC {
        public:
            PIC(void);

            void Handler(Driver::CPU::IDT::ISRPack Pack);

            static PIC &Instance(void);

            void SetHandler(uint8_t Vector, Driver::CPU::IDT::ISRCallback Handler);
            Driver::CPU::IDT::ISRCallback GetHandler(uint8_t Vector);
        private:
            static PIC *Instance_;
            Driver::CPU::IDT::ISRCallback Callbacks_[0x10];
        };
    }
}