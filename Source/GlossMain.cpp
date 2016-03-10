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

// #define BACKSPACE 0x0E

// unsigned char scancode[128] = {
//     0,  27, '1', '2', '3', '4', '5', '6', '7', '8',
//     '9', '0', '-', '=', '\b',   /* Backspace */
//     '\t',           /* Tab */
//     'q', 'w', 'e', 'r', /* 19 */
//     't', 'y', 'u', 'i', 'o', 'p', '[', ']', '\n',   /* Enter key */
//     0,          /* 29   - Control */
//     'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';',   /* 39 */
//     '\'', '`',  0,      /* Left shift */
//     '\\', 'z', 'x', 'c', 'v', 'b', 'n',         /* 49 */
//     'm', ',', '.', '/',   0,                /* Right shift */
//     '*',
//     0,  /* Alt */
//     ' ',    /* Space bar */
//     0,  /* Caps lock */
//     0,  /* 59 - F1 key ... > */
//     0,   0,   0,   0,   0,   0,   0,   0,
//     0,  /* < ... F10 */
//     0,  /* 69 - Num lock*/
//     0,  /* Scroll Lock */
//     0,  /* Home key */
//     0,  /* Up Arrow */
//     0,  /* Page Up */
//     '-',
//     0,  /* Left Arrow */
//     0,
//     0,  /* Right Arrow */
//     '+',
//     0,  /* 79 - End key*/
//     0,  /* Down Arrow */
//     0,  /* Page Down */
//     0,  /* Insert Key */
//     0,  /* Delete Key */
//     0,   0,   0,
//     0,  /* F11 Key */
//     0,  /* F12 Key */
//     0,  /* All other keys are undefined */
// };

// bool Shift;

// char ConvertShift(char c) {
//     if (c >= 'a' && c <= 'z') {
//         return c - 0x20;
//     }
//     if (c == '0') return ')';
//     if (c == '1') return '!';
//     if (c == '2') return '@';
//     if (c == '3') return '#';
//     if (c == '4') return '$';
//     if (c == '5') return '%';
//     if (c == '6') return '^';
//     if (c == '7') return '&';
//     if (c == '8') return '*';
//     if (c == '9') return '(';

//     if (c == '`') return '~';
//     if (c == '[') return '{';
//     if (c == ']') return '}';
//     if (c == ',') return '<';
//     if (c == '.') return '>';
//     if (c == '/') return '?';
//     if (c == ';') return ':';
//     if (c == '-') return '_';
//     if (c == '=') return '+';

//     if (c == '\'') return '"';
//     if (c == '\\') return '|';

//     return c;
// }

// // volatile char Key;
// static volatile uint8_t ScanCode;

// uint8_t ScanByte(void) {
//     // uint8_t byte;
//     // do {
//     //     byte = Device::Port::InputByte(0x64);
//     // } while ((byte & 0x01) == 0);
//     return Device::Port::InputByte(0x60);
// }

// char ScanCodeToChar(uint8_t Code) {
//     if (Code == 0x2A || Code == 0x36) {
//         Shift = true;
//         return 0x00;
//     }
//     else if (Code == 0xAA || Code == 0xB6) {
//         Shift = false;
//         return 0x00;
//     }

//     if (Code < 0x7D) {
//         char c = scancode[Code];
//         // if (Shift) {
//         //     c = ConvertShift(c);
//         // }
//         return c;
//     }
//     return 0x00;
// }
// bool avail;
// uint8_t MyChar;

// class PS2Keyboard {
// public:
//     static void Handler(uint64_t Error, uint64_t Vector) {

//         // On interrupt received for keypress, print it out. Basically as simple as it can get.
//         // To add: modifier keys (shift)
//         //         Change it so that instead of writing to the console, it will either send the char to active process
//         //             or write to a singular active buffer. We'll see. Maybe something completely different.
//         // uint8_t rcvd = Device::Port::InputByte(0x60);

//     uint8_t Code = ScanByte();

//     if (Code == 0x2A || Code == 0x36) {
//         Shift = true;
//     }
//     else if (Code == 0xAA || Code == 0xB6) {
//         Shift = false;
//     }
//     avail = false;

//     if (Code < 0x7D) {
//         char c = scancode[Code];
//         if (Shift) {
//             c = ConvertShift(c);
//         }
//         // MyChar = c;
//         // avail = true;
//         Device::Console::PutChar(c);
//     }

//         // if (rcvd < 0x7D) {
//         //     // Console::Print("Keyboard Interrupt: got ");
//         //     const char c = scancode[rcvd];
//         //     Device::Console::PutChar(c);

//         //     // Probably a terrible way of doing backspace. But it's the first way I thought of.
//         //     // Can be changed later, obviously.
//         //     if (rcvd == BACKSPACE) {
//         //         Device::Console::PutChar(' ');
//         //         Device::Console::PutChar(c);
//         //     }
//         // }
//         // ScanCode = ScanByte();

//         Device::PIC::AcknowledgeIRQ(0x01);
//     }

//     static int GetChar() {
//         // // if (ScanCode == 0x1E) Console::Print("Tha Fuck?!?");
//         // char c = ScanCodeToChar(ScanCode);
//         // // if (c == 'a') Console::PutChar(c);
//         // ScanCode = 0x00;
//         // // IDT::Enable();
//         if (avail) {
//             avail = false;
//             return MyChar;
//         }
//     }

//     static void Init() {
//         Device::IDT::SetHandler(0x21, (uint64_t)&PS2Keyboard::Handler);
//         Device::PIC::EnableIRQ(0x01);
//         // Console::Print("Keyboard Initialized!\n");
//     }
// private:
// };
// 


// Stolen atoi (cuz I'm lazy :P)
int atoic(char *str, int digits)
{
    int res = 0; // Initialize result
  
    // Iterate through all characters of input string and
    // update result
    for (int i = 0; i < digits; ++i)
        res = res*10 + str[i] - '0';
  
    // return result.
    return res;
}

extern "C" void GlossMain(void) {
    Console::Print("Initializing Hardware\n");


    Console::Print("  (1) Initializing PIT - ");
    if (PIT::Init()) {
        Console::SetForeground(Console::TextColor::Green);
        Console::Print("Successful\n");
        Console::SetForeground(Console::TextColor::LightGray);
    }
    else {
        Console::SetForeground(Console::TextColor::Red);
        Console::Print("Failed\n");
        Console::SetForeground(Console::TextColor::LightGray);
    }
    Console::Print("    * Test 1 (1.000 Seconds) - ");
    PIT::Sleep(1000);
    Console::Print("Finished\n");
    Console::Print("    * Test 2 (0.050 Seconds) - ");
    PIT::Sleep(50);
    Console::Print("Finished\n");
    Console::Print("    * Test 3 (0.500 Seconds) - ");
    PIT::Sleep(500);
    Console::Print("Finished\n");
    Console::Print("    * Test 4 (0.277 Seconds) - ");
    PIT::Sleep(277);
    Console::Print("Finished\n");


    Console::Print("  (2) Initializing PS/2 Controller - ");
    if (PS2Controller::Init()) {
        Console::SetForeground(Console::TextColor::Green);
        Console::Print("Successful\n");
        Console::SetForeground(Console::TextColor::LightGray);
    }
    else {
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
        Console::Print("    * Connected to channel: Primary\n");
    }
    else {
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
    }
    else {
        Console::SetForeground(Console::TextColor::Red);
        Console::Print("Failed\n");
        Console::SetForeground(Console::TextColor::LightGray);
    }



    Console::Print("  (5) Initializing Floppy Disk Controller - ");
    if (FDC::Init()) {
        Console::SetForeground(Console::TextColor::Green);
        Console::Print("Successful\n");
        Console::SetForeground(Console::TextColor::LightGray);
    }
    else {
        Console::SetForeground(Console::TextColor::Red);
        Console::Print("Failed\n");
        Console::SetForeground(Console::TextColor::LightGray);
    }

    Console::Print("Hardware Initialized\n");

    uint8_t *ptr = FDC::ReadSector(0x00);
    for (uint64_t i = 0; i < 16; ++i) {
        for (uint64_t j = 0; j < 16; ++j) {
            Console::PrintHex(*ptr++);
            Console::Print(" ");
        }
        // Console::Print("\n");
    }

    // Device::Console::Print("Current Scancode Set: ");
    // uint8_t set = Device::Keyboard::GetScancodeSet();
    // Device::Console::PrintHex(set);
    // Device::Console::Print("\n");

    uint8_t *buffer = (uint8_t *)0x4000000;
    uint8_t *head = buffer;
    uint8_t *tail = buffer;
    uint64_t count = 0x00;

    // Console::Print("Buffer Location: ");
    // Console::PrintHex((uint64_t)buffer);
    // Console::Print("\n");
    
    Console::Print(" > ");

    while (true) {
        char c = Keyboard::GetCharASCII();
        // Console::PutChar(c);
        // Console::Print("\n");
        if (c) {
            // Console::PrintHex((uint8_t)c);
            // Console::PutChar(c);
            if (tail > head) tail = head;
            if (c == 0x08) {
                head--;
                if (tail > head) tail = head;
                Console::PutChar(c);
            }
            else {
                *head = c;
                head++;
                Console::PutChar(*tail);
                tail++;
            }
            if (c == 0x0A) {
                // head = 0x00;
                // head++;
                if (Memory::Equal(buffer, (const uint8_t *)"clear", 5)) {
                    Console::Clear();
                    // Console::Print("Clearing!\n");
                }
                else if (Memory::Equal(buffer, (const uint8_t *)"echo", 4)) {
                    tail = buffer + 5;
                    while (tail < head) {
                        Console::PutChar(*tail);
                        tail++;
                    }
                }
                else if (Memory::Equal(buffer, (const uint8_t *)"sleep", 5)) {
                    tail = buffer + 6;
                    // head = 0x00;
                    int val = atoic((char *)tail, head - tail - 1);
                    PIT::Sleep(val);
                }
                else if (Memory::Equal(buffer, (const uint8_t *)"keytest", 7)) {
                    Port::OutputByte(0x64, 0xD2);
                    Port::OutputByte(0x60, 0x10);
                }
                else {
                    Console::Print("Invalid Command. Please Try Again!\n");
                }
                head = buffer;
                tail = buffer;
                count = 0x00;
                Console::Print(" > ");
            }
            // asm volatile("hlt");
            // Console::Print("\n");
            // Console::PutChar(c);
            // if (c == 0x0A) {
            //     Console::Print(" > ");
            // }
        }
        asm volatile("hlt");
        // Console::PutChar('a');
        // PIT::Sleep(250);
    }
}