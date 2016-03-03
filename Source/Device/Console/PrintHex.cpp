#include <Device/Console.hpp>
#include <stdint.h>

using namespace Device;

extern "C" {
    extern void AMD64_Console_PrintHex8(uint64_t Number);
    extern void AMD64_Console_PrintHex16(uint64_t Number);
    extern void AMD64_Console_PrintHex32(uint64_t Number);
    extern void AMD64_Console_PrintHex64(uint64_t Number);
}

void Console::PrintHex(uint8_t Number) {
    AMD64_Console_PrintHex8(Number);
}
void Console::PrintHex(uint16_t Number) {
    AMD64_Console_PrintHex16(Number);
}
void Console::PrintHex(uint32_t Number) {
    AMD64_Console_PrintHex32(Number);
}
void Console::PrintHex(uint64_t Number) {
    AMD64_Console_PrintHex64(Number);
}