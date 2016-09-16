#include <Device/Console.hpp>
#include <stdint.h>

using namespace Device;

extern "C" {
    extern void AMD64_Console_SetForegroundColor(uint64_t Address);
}

void Console::SetForeground(TextColor Color) {
    AMD64_Console_SetForegroundColor((uint64_t)Color);
}