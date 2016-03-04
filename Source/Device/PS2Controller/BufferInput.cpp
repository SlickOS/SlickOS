#include <Device/PS2Controller.hpp>
#include <Device/Port.hpp>

#include <stdint.h>

using namespace Device;

void PS2Controller::BufferInput(void) {
    while (true) {
        if ((Port::InputByte(0x60) & 0x02) == 0x00) break;
    }
}