#include <Device/Keyboard.hpp>
#include <Device/Port.hpp>
#include <Device/PIC.hpp>
#include <Device/PS2Controller.hpp>

#include <Device/Console.hpp>

#include <stdint.h>

using namespace Device;

void Keyboard::Handler(uint64_t Error, uint64_t Vector) {
    // Console::Print("In-Handler!\n");

    PS2Controller::BufferOutput();
    uint8_t scancode = Port::InputByte(0x60);

    // Console::PrintHex(scancode);
    // Console::Print("\n");

    KeyCode key = ScancodeSet1[scancode];

    if (key == KeyCode::Down_LShift || key == KeyCode::Down_RShift) {
        ShiftDown_ = true;
    }
    else if (key == KeyCode::Up_LShift || key == KeyCode::Up_RShift) {
        ShiftDown_ = false;
    }
    else {
        if ((uint16_t)(key) < 0x100) {
            // if (KeyCode_ == KeyCode::Down_Q) {
                Buffer_[Count_] = key;
            // }
            // else {
            //     KeyCode_ = KeyCode::Null;
            // }
        }
        else {
            Buffer_[Count_] = KeyCode::Null;
        }
        Count_++;
        // Count_ &= (4096 * 100 / sizeof(KeyCode)) - 1;
    }

    PIC::AcknowledgeIRQ(0x01);
}