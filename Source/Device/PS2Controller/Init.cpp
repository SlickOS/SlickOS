#include <Device/PS2Controller.hpp>
#include <Device/Port.hpp>

#include <Device///Console.hpp>

#include <stdint.h>

using namespace Device;

bool PS2Controller::Init(void) {
    //Console::Print("Disabling Channels.\n");
    PS2Controller::DisableChannel(Device::Primary);
    PS2Controller::DisableChannel(Device::Secondary);

    //Console::Print("Flushing Channels.\n");
    Port::InputByte(0x60);

    //Console::Print("Disabling Interrupts.\n");
    uint8_t config = PS2Controller::ReadConfiguration();
    config &= 0xBC;
    PS2Controller::WriteConfiguration(config);

    //Console::Print("Checking Secondary Channel Status.\n");
    PrimaryAvailable_ = true;
    SecondaryAvailable_ = (config & 0x20) ? true : false;
    // SecondaryAvailable_ = false;

    //Console::Print("Testing PS/2 Controller.\n");
    if (!PS2Controller::Test()) {
        return false;
    }

    //Console::Print("Checking Secondary Channel Status.\n");
    PS2Controller::EnableChannel(Device::Secondary);
    config = PS2Controller::ReadConfiguration();
    SecondaryAvailable_ = (config & 0x20) ? false : true;
    PS2Controller::DisableChannel(Device::Secondary);

    //Console::Print("Testing Primary Channel.\n");
    if (PrimaryAvailable_) {
        if (!PS2Controller::TestChannel(Device::Primary)) {
            PrimaryAvailable_ = false;
        }
        if (PrimaryAvailable_) {
            PS2Controller::EnableChannel(Device::Primary);
            config = PS2Controller::ReadConfiguration();
            config |= 0x01;
            PS2Controller::WriteConfiguration(config);
        }
    }
    //Console::Print("Testing Secondary Channel.\n");
    if (SecondaryAvailable_) {
        if (!PS2Controller::TestChannel(Device::Secondary)) {
            SecondaryAvailable_ = false;
        }
        if (SecondaryAvailable_) {
            PS2Controller::EnableChannel(Device::Secondary);
            config = PS2Controller::ReadConfiguration();
            config |= 0x02;
            PS2Controller::WriteConfiguration(config);
        }
    }
    if (!PrimaryAvailable_ && !SecondaryAvailable_) {
        return false;
    }

    //Console::Print("Resetting Primary Channel.\n");
    uint8_t retries = 4;
    bool acknowledged = false;
    if (PrimaryAvailable_) {
        while (!acknowledged && retries > 0) {
            PS2Controller::BufferInput();
            Port::OutputByte(0x60, 0xFF);
            PS2Controller::BufferOutput();
            uint8_t response = Port::InputByte(0x60);
            // if (response == 0xAA) {
            //     PS2Controller::BufferOutput();
            //     response = Port::InputByte(0x60);
                if (response == 0xFA) acknowledged = true;
            // }
            --retries;
        }
        if (!acknowledged) {
            PS2Controller::DisableChannel(Device::Primary);
            config = PS2Controller::ReadConfiguration();
            config &= 0xBE;
            PS2Controller::WriteConfiguration(config);
            PrimaryAvailable_ = false;
        }
    }

    //Console::Print("Resetting Secondary Channel.\n");
    retries = 4;
    acknowledged = false;
    if (SecondaryAvailable_) {
        while (!acknowledged && retries > 0) {
            //Console::Print("  Setting Channel.\n");
            Port::OutputByte(0x64, 0xD4);
            //Console::Print("  Buffering Input.\n");
            // PS2Controller::BufferInput();
            //Console::Print("  Outputting Reset Command.\n");
            Port::OutputByte(0x60, 0xFF);
            //Console::Print("  Buffering Output.\n");
            // Port::OutputByte(0x64, 0xD3);
            PS2Controller::BufferOutput();
            //Console::Print("  Reading Response.\n");
            uint8_t response = Port::InputByte(0x60);
            // if (response == 0xAA) {
            //     Port::OutputByte(0x64, 0xD3);
            //     PS2Controller::BufferOutput();
            //     response = Port::InputByte(0x60);
                if (response == 0xFA) acknowledged = true;
            // }
            --retries;
        }
        if (!acknowledged) {
            PS2Controller::DisableChannel(Device::Secondary);
            config = PS2Controller::ReadConfiguration();
            config &= 0xBD;
            PS2Controller::WriteConfiguration(config);
            SecondaryAvailable_ = false;
        }
    }

    //Console::Print("Initialization Finished.\n");

    if (!PrimaryAvailable_ && !SecondaryAvailable_) {
        return false;
    }
    return true;
}