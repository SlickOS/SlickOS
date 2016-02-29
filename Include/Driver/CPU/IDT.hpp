#pragma once

#include <stdint.h>

namespace Driver{
    namespace CPU {
        class IDT {
        public:
            struct ISRPack {
                uint64_t DS;
                uint64_t RDI;
                uint64_t RSI;
                uint64_t RBP;
                uint64_t RSP;
                uint64_t RBX;
                uint64_t RDX;
                uint64_t RCX;
                uint64_t RAX;
                uint64_t Vector;
                uint64_t Error;
                uint64_t RIP;
                uint64_t CS;
                uint64_t EFlags;
                uint64_t UserESP;
                uint64_t SS;
            };
            struct Entry {
                uint16_t OffsetLow;
                uint16_t Selector;
                uint8_t Reserved;
                uint8_t Flags;
                uint16_t OffsetHigh;
                uint32_t OffsetLong;
                uint32_t Zero;
            };
            struct IDTR {
                uint16_t Limit;
                uint64_t Offset;
            } __attribute__((packed));
            typedef void (*ISRCallback)(ISRPack); // TODO: Replace with 'Delegate' class.

            IDT(void);
            static IDT &Instance(void);

            void Handler(ISRPack Pack);
            void IRQHandler(ISRPack Pack);

            void SetGate(uint8_t Vector, uint64_t Base, uint16_t Selector, uint8_t Flags);
            void Flush(void);

            void SetHandler(uint8_t Vector, ISRCallback Handler);
            ISRCallback GetHandler(uint8_t Vector);

        private:
            ISRCallback Callbacks_[256];
            Entry Entries_[256];
            IDTR Descriptor_;

            static IDT *Instance_;
        };
    }
}