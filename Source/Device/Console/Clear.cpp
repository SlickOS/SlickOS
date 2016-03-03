#include <Device/Console.hpp>
#include <stdint.h>

using namespace Device;

extern "C" {
    extern void AMD64_Console_Clear(void);
}

void Console::Clear(void) {
    AMD64_Console_Clear();
}