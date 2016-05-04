#include <Device/Console.hpp>
#include <stdint.h>

using namespace Device;

extern "C" {
    extern void AMD64_Console_Scroll(void);
}

void Console::Scroll(void) {
    AMD64_Console_Scroll();
}