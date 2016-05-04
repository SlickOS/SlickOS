#include <Device/Console.hpp>
#include <stdint.h>

using namespace Device;

extern "C" {
    extern void AMD64_Console_PutChar(uint64_t Char);
}

void Console::PutChar(char Char) {
    AMD64_Console_PutChar(Char);
}