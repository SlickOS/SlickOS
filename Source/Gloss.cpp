#include <stdint.h>
#include "Driver/Terminal/Console.hpp"

const char *text = "Hello, World!";

extern "C" void GlossMain(void) {
    Console::Init();
    Console::SetForeground(Console::TextColor::Green);
    Console::SetBackground(Console::TextColor::Black);
    Console::Clear();
    Console::Print(text);
    Console::PutChar('\n');
    Console::Print("Goodbye, World!\n\nA New Beginning");
}