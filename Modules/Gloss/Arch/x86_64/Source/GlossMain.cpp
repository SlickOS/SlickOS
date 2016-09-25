#include <Device/Console.hpp>
#include <Device/IDT.hpp>
#include <Device/PIC.hpp>
#include <Device/Port.hpp>
#include <Device/PIT.hpp>
#include <Device/PS2Controller.hpp>
#include <Device/Keyboard.hpp>
#include <Device/FDC.hpp>
#include <Device/PhysicalMemory.hpp>
#include <Device/VirtualMemory.hpp>
#include <Device/Memory.hpp>

using namespace Device;


// Stolen atoi (cuz I'm lazy :P)
int atoic(char *str, int digits) {
    int res = 0; // Initialize result

    // Iterate through all characters of input string and
    // update result
    for (int i = 0; i < digits; ++i)
        res = res * 10 + str[i] - '0';

    // return result.
    return res;
}

extern "C" void GlossMain(void) {
    Console::Print("Initializing Hardware\n");


    // Console::Print("  (1) Initializing PIT - ");
    // if (PIT::Init()) {
    //     Console::SetForeground(Console::TextColor::Green);
    //     Console::Print("Successful\n");
    //     Console::SetForeground(Console::TextColor::LightGray);
    // } else {
    //     Console::SetForeground(Console::TextColor::Red);
    //     Console::Print("Failed\n");
    //     Console::SetForeground(Console::TextColor::LightGray);
    // }
    // Console::Print("    * Test 1 (1.000 Seconds) - ");
    // PIT::Sleep(1000);
    // Console::Print("Finished\n");
    // Console::Print("    * Test 2 (0.050 Seconds) - ");
    // PIT::Sleep(50);
    // Console::Print("Finished\n");
    // Console::Print("    * Test 3 (0.500 Seconds) - ");
    // PIT::Sleep(500);
    // Console::Print("Finished\n");
    // Console::Print("    * Test 4 (0.277 Seconds) - ");
    // PIT::Sleep(277);
    // Console::Print("Finished\n");


    Console::Print("  (2) Initializing PS/2 Controller - ");
    if (PS2Controller::Init()) {
        Console::SetForeground(Console::TextColor::Green);
        Console::Print("Successful\n");
        Console::SetForeground(Console::TextColor::LightGray);
    } else {
        Console::SetForeground(Console::TextColor::Red);
        Console::Print("Failed\n");
        Console::SetForeground(Console::TextColor::LightGray);
    }
    if (PS2Controller::Available(Device::PS2Controller::Device::Primary)) {
        Console::Print("    * Primary PS/2 Device Available\n");
    }
    if (PS2Controller::Available(Device::PS2Controller::Device::Secondary)) {
        Console::Print("    * Secondary PS/2 Device Available\n");
    }


    Console::Print("  (3) Initializing Keyboard - ");
    if (Keyboard::Init()) {
        Console::SetForeground(Console::TextColor::Green);
        Console::Print("Successful\n");
        Console::SetForeground(Console::TextColor::LightGray);
        Console::Print("    * Connected to Channel: Primary\n");
    } else {
        Console::SetForeground(Console::TextColor::Red);
        Console::Print("Failed\n");
        Console::SetForeground(Console::TextColor::LightGray);
    }


    Console::Print("  (4) Initializing Physical Memory Manager - ");
    if (PhysicalMemory::Init()) {
        Console::SetForeground(Console::TextColor::Green);
        Console::Print("Successful\n");
        Console::SetForeground(Console::TextColor::LightGray);
        Console::Print("    * Total Memory Available: ");
        Console::PrintHex(PhysicalMemory::GetTotalMemorySize());
        Console::Print("\n");
    } else {
        Console::SetForeground(Console::TextColor::Red);
        Console::Print("Failed\n");
        Console::SetForeground(Console::TextColor::LightGray);
    }

    Console::Print("Hardware Initialized\n");


    uint8_t *buffer = (uint8_t *)0x4000000;
    uint8_t *head = buffer;
    uint8_t *tail = buffer;
    uint64_t count = 0x00;


    Console::Print(" > ");

    char c;

    while (true) {
        c = Keyboard::GetCharASCII();
        if (c) {
            if (tail > head) tail = head;
            if (c == 0x08) {
                if ((uint64_t)head > 0x4000000) {
                    head--;
                    if (tail > head) tail = head;
                    Console::PutChar(0x08);
                }
            } else {
                *head = c;
                head++;
                Console::PutChar(*tail);
                tail++;
            }
            if (c == 0x0A) {
                if (Memory::Equal(buffer, (const uint8_t *)"clear", 5)) {
                    Console::Clear();
                } else if (Memory::Equal(buffer, (const uint8_t *)"echo", 4)) {
                    tail = buffer + 5;
                    while (tail < head) {
                        Console::PutChar(*tail);
                        tail++;
                    }
                } else if (Memory::Equal(buffer, (const uint8_t *)"sleep", 5)) {
                    tail = buffer + 6;
                    int val = atoic((char *)tail, head - tail - 1);
                    PIT::Sleep(val);
                } else if (Memory::Equal(buffer, (const uint8_t *)"keytest", 7)) {
                    Port::OutputByte(0x64, 0xD2);
                    Port::OutputByte(0x60, 0x10);
                } else {
                    Console::Print("Invalid Command. Please Try Again!\n");
                }
                head = buffer;
                tail = buffer;
                count = 0x00;
                Console::Print(" > ");
            }
        }
        // asm volatile("hlt");
    }
}