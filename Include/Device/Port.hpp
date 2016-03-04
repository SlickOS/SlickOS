#pragma once

#include <stdint.h>

namespace Device {
    class Port {
    public:
        static inline void OutputByte(uint16_t Port, uint8_t Value) {
            asm volatile ( "outb %0, %1" : : "a"(Value), "Nd"(Port) );
        }
        static inline void OutputShort(uint16_t Port, uint16_t Value) {
            asm volatile ( "outw %0, %1" : : "a"(Value), "Nd"(Port) );
        }
        static inline void OutputInt(uint16_t Port, uint32_t Value) {
            asm volatile ( "outd %0, %1" : : "a"(Value), "Nd"(Port) );
        }
        static inline void OutputLong(uint16_t Port, uint64_t Value) {
            asm volatile ( "outq %0, %1" : : "a"(Value), "Nd"(Port) );
        }

        static inline uint8_t InputByte(uint16_t Port) {
            uint8_t value;
            asm volatile ( "inb %[Port], %[value]" : [value] "=a"(value) : [Port] "Nd"(Port) );
            return value;
        }
        static inline uint16_t InputWord(uint16_t Port) {
            uint16_t value;
            asm volatile ( "inw %[Port], %[value]" : [value] "=a"(value) : [Port] "Nd"(Port) );
            return value;
        }
        static inline uint32_t InputInt(uint16_t Port){
            uint32_t value;
            asm volatile ( "ind %[Port], %[value]" : [value] "=a"(value) : [Port] "Nd"(Port) );
            return value;
        }
        static inline uint64_t InputLong(uint16_t Port){
            uint64_t value;
            asm volatile ( "inq %[Port], %[value]" : [value] "=a"(value) : [Port] "Nd"(Port) );
            return value;
        }
    };
}