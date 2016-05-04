#include <Device/PIT.hpp>

#include <Device/Console.hpp>

#include <stdint.h>

using namespace Device;

void PIT::Sleep(int64_t Time) {
    int64_t tNew = PIT::Tick_ + Time;
    while (Tick_ < tNew) {
        // asm volatile("hlt");
    }
}