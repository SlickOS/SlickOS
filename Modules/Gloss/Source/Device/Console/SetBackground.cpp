#include <Device/Console.hpp>
#include <stdint.h>

using namespace Device;

extern "C" {
    extern void AMD64_Console_SetBackgroundColor(uint64_t Address);
}

void Console::SetBackground(TextColor Color) {
    AMD64_Console_SetBackgroundColor((uint64_t)Color);
}