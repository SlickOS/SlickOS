#include <Device/Keyboard.hpp>
#include <Device/Port.hpp>
#include <Device/PS2Controller.hpp>
#include <Device/IDT.hpp>
#include <Device/PIC.hpp>
#include <Device/PhysicalMemory.hpp>

#include <Device/Console.hpp>

#include <stdint.h>

using namespace Device;

bool Keyboard::Init(void) {
    Buffer_ = (KeyCode *)0x100000;
    Count_ = 0x00;
    Index_ = 0x00;

    // Console::Print("\nOutputting Command Scancode Set.\n");
    Port::OutputByte(0x60, 0xF0);
    // Console::Print("Buffering Input.\n");
    PS2Controller::BufferInput();
    // Console::Print("Setting Scancode Number.\n");
    Port::OutputByte(0x60, 0x02);

    // Console::Print("Buffering Output.\n");
    PS2Controller::BufferOutput();
    // Console::Print("Reading Response.\n");
    uint8_t response = Port::InputByte(0x60);
    // Console::Print("Response: ");
    // Console::PrintHex(response);
    // Console::Print(".\n");
    // if (response == 0xAA) {
        // Console::Print("Buffering Output.\n");
        // PS2Controller::BufferOutput();
        // Console::Print("Reading Response.\n");
        // response = Port::InputByte(0x60);
        // Console::Print("Response: ");
        // Console::PrintHex(response);
        // Console::Print(".\n");
        if (response == 0xFA) {
            // Console::Print("Setting Handler.\n");
            IDT::SetHandler(0x21, (uint64_t)&Keyboard::Handler);
            // Console::Print("Enabling IRQ.\n");

            // uint8_t code = 0x00;
            // while (((code = Port::InputByte(0x64)) & 0x01) == 0x01) {
            //     Port::InputByte(0x60);
            // }
            
            PIC::EnableIRQ(0x01);
        // }

        // // uint8_t code = 0x00;
        // // while (((code = Port::InputByte(0x64)) & 0x01) == 0x01) {
        // //     Port::InputByte(0x60);
        // // }

        return true;
    }

    return false;
}