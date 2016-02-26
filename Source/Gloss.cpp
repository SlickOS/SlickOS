#include <stdint.h>
#include "Driver/Terminal/Console.hpp"
#include "Driver/Core/IDT.hpp"
#include "Driver/Core/PIT.hpp"

const char *text = "Hello, World!";

extern "C" void GlossMain(void) {
    IDT::Init();
    PIT::SetFrequency(1000);

    Console::Init();
    Console::SetForeground(Console::TextColor::Green);
    Console::SetBackground(Console::TextColor::Black);
    Console::Clear();
    Console::Print(text);
    Console::PutChar('\n');
    Console::Print("Goodbye, World!\n\nA New Beginning\n\n");

    //PIT::SetFrequency(50);

    asm volatile("int $0x3");

    for(;;) {
        asm("hlt");
    }
}