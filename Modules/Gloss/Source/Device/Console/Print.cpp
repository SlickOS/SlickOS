#include <Device/Console.hpp>
#include <stdint.h>
#include <stddef.h>
#include <stdarg.h>

using namespace Device;

// extern "C" {
//     extern void AMD64_Console_Print(uint64_t Address);
// }

// void Console::Print(const char *Text) {
//     AMD64_Console_Print((uint64_t)Text);
// }

void Console::Print(const char *Text, ...) {
    va_list Args;
    size_t NumberArgs = sizeof(Args);
    va_start(Args, NumberArgs);

    while (*Text != 0) {
        if (*Text == 0x25) {
        ++Text;
        if (*Text == 0x69 || *Text == 0x75) { //int
            PrintDecimal(va_arg(Args, uint64_t));
        }
        else if (*Text == 0x63) { //char
            PutChar((char)va_arg(Args, int));
        }
        else if (*Text == 0x73) { //string
            Print(va_arg(Args, char*));
        }
        ++Text;
        }
        else {
        PutChar(*(Text++));
        }
    }
}