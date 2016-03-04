#include <Device/Keyboard.hpp>
#include <Device/Port.hpp>
#include <Device/PS2Controller.hpp>

#include <stdint.h>

using namespace Device;

uint8_t Keyboard::GetScancodeSet(void) {
    Port::OutputByte(0x60, 0xF0);
    PS2Controller::BufferInput();
    Port::OutputByte(0x60, 0x00);

    PS2Controller::BufferOutput();
    uint8_t response = Port::InputByte(0x60);
    if (response == 0xFA) {
        PS2Controller::BufferOutput();
        response = Port::InputByte(0x60);
        return response;
    }
    return 0xFF;
}

constexpr const Keyboard::KeyCode Keyboard::ScancodeSet1[256];