#include <Device/PS2Controller.hpp>
#include <Device/Port.hpp>

#include <stdint.h>

using namespace Device;

void PS2Controller::BufferOutput(void) {
    while (true) {
        if ((Port::InputByte(0x64) & 0x01) != 0x00) break;
    }
}