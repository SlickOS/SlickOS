#include <Device/PIT.hpp>

#include <Device/Console.hpp>

#include <stdint.h>

using namespace Device;

void PIT::Sleep(int64_t Time) {
    PIT::Tick_ = Time;
    while (Tick_ > 0) {
        // asm volatile("hlt");
    }
}