#include <Device/Console.hpp>
#include <stdint.h>

using namespace Device;

extern "C" {
    extern void AMD64_Console_Print(uint64_t Address);
}

void Console::Print(const char *Text) {
    AMD64_Console_Print((uint64_t)Text);
}