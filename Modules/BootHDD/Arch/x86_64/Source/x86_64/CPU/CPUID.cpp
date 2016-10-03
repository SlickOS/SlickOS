#include <CPU/CPU86.hpp>
#include <Console.hpp>

using namespace Gloss;

void CPU86::ID(uint32_t *eax, uint32_t *ebx, uint32_t *ecx, uint32_t *edx) {
    asm volatile("cpuid"
        : "=a" (*eax),
          "=b" (*ebx),
          "=c" (*ecx),
          "=d" (*edx)
        : "0"  (*eax),
          "2"  (*ecx));

    ::Console Console;
    Console.Print("   ");
}