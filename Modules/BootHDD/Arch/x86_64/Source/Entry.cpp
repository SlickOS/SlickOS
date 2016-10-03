#include <Console.hpp>
#include <CPU/CPU86.hpp>

extern "C" void Entry(void) {
    ::Console Console;

    uint32_t eax;
    uint32_t ebx;
    uint32_t ecx;
    uint32_t edx;

    eax = 0;
    Gloss::CPU86::ID(&eax, &ebx, &ecx, &edx);

    char *textArr;
    textArr[0] = (char)(ebx >> 0);
    textArr[1] = (char)(ebx >> 8);
    textArr[2] = (char)(ebx >> 16);
    textArr[3] = (char)(ebx >> 24);
    textArr[4] = (char)(edx >> 0);
    textArr[5] = (char)(edx >> 8);
    textArr[6] = (char)(edx >> 16);
    textArr[7] = (char)(edx >> 24);
    textArr[8] = (char)(ecx >> 0);
    textArr[9] = (char)(ecx >> 8);
    textArr[10] = (char)(ecx >> 16);
    textArr[11] = (char)(ecx >> 24);
    textArr[12] = 0;

    Console.Print("Processor Manufacturer String: ");
    Console.Print(textArr);
}