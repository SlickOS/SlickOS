#include <Device/Console.hpp>
#include <Device/IDT.hpp>
#include <Device/PIC.hpp>
#include <Device/Port.hpp>
// #include <Device/PIT.hpp>
// #include <Device/Keyboard.hpp>

namespace Device {
    class PIT {
    public:
        static void Handler(uint64_t Error, uint64_t Vector) {
            Tick_++;
            // Console::Print("Tick: ");
            // Console::PrintHex((uint32_t)Tick_);
            // Console::Print("\n");
            Device::PIC::AcknowledgeIRQ(0x00);
        }
        static void Init(void) {
            Tick_ = 0x00;
            Device::IDT::SetHandler(0x20, (uint64_t)&PIT::Handler);
            Device::PIT::SetFrequency(1000);
            Device::PIC::EnableIRQ(0x00);
        }
        static void SetFrequency(uint32_t Frequency) {
            uint32_t divisor = 1193180 / Frequency;
            Device::Port::OutputByte(0x0043, 0x36);
            uint8_t low = (uint8_t)(divisor & 0xFF);
            uint8_t high = (uint8_t)((divisor >> 8) & 0xFF);
            Device::Port::OutputByte(0x0040, low);
            Device::Port::OutputByte(0x0040, high);
        }
        static void Sleep(uint64_t Time) {
            uint64_t tick = Time;
            Tick_ = 0x00;
            while (Tick_ < tick) {
                asm volatile("hlt");
                Console::PutChar(0);
            }
        }

    private:
        static int64_t Tick_;
    };
    int64_t PIT::Tick_;
}

#define BACKSPACE 0x0E

unsigned char scancode[128] = {
    0,  27, '1', '2', '3', '4', '5', '6', '7', '8',
    '9', '0', '-', '=', '\b',   /* Backspace */
    '\t',           /* Tab */
    'q', 'w', 'e', 'r', /* 19 */
    't', 'y', 'u', 'i', 'o', 'p', '[', ']', '\n',   /* Enter key */
    0,          /* 29   - Control */
    'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';',   /* 39 */
    '\'', '`',  0,      /* Left shift */
    '\\', 'z', 'x', 'c', 'v', 'b', 'n',         /* 49 */
    'm', ',', '.', '/',   0,                /* Right shift */
    '*',
    0,  /* Alt */
    ' ',    /* Space bar */
    0,  /* Caps lock */
    0,  /* 59 - F1 key ... > */
    0,   0,   0,   0,   0,   0,   0,   0,
    0,  /* < ... F10 */
    0,  /* 69 - Num lock*/
    0,  /* Scroll Lock */
    0,  /* Home key */
    0,  /* Up Arrow */
    0,  /* Page Up */
    '-',
    0,  /* Left Arrow */
    0,
    0,  /* Right Arrow */
    '+',
    0,  /* 79 - End key*/
    0,  /* Down Arrow */
    0,  /* Page Down */
    0,  /* Insert Key */
    0,  /* Delete Key */
    0,   0,   0,
    0,  /* F11 Key */
    0,  /* F12 Key */
    0,  /* All other keys are undefined */
};

bool Shift;

char ConvertShift(char c) {
    if (c >= 'a' && c <= 'z') {
        return c - 0x20;
    }
    if (c == '0') return ')';
    if (c == '1') return '!';
    if (c == '2') return '@';
    if (c == '3') return '#';
    if (c == '4') return '$';
    if (c == '5') return '%';
    if (c == '6') return '^';
    if (c == '7') return '&';
    if (c == '8') return '*';
    if (c == '9') return '(';

    if (c == '`') return '~';
    if (c == '[') return '{';
    if (c == ']') return '}';
    if (c == ',') return '<';
    if (c == '.') return '>';
    if (c == '/') return '?';
    if (c == ';') return ':';
    if (c == '-') return '_';
    if (c == '=') return '+';

    if (c == '\'') return '"';
    if (c == '\\') return '|';

    return c;
}

// volatile char Key;
static volatile uint8_t ScanCode;

uint8_t ScanByte(void) {
    // uint8_t byte;
    // do {
    //     byte = Device::Port::InputByte(0x64);
    // } while ((byte & 0x01) == 0);
    return Device::Port::InputByte(0x60);
}

char ScanCodeToChar(uint8_t Code) {
    if (Code == 0x2A || Code == 0x36) {
        Shift = true;
        return 0x00;
    }
    else if (Code == 0xAA || Code == 0xB6) {
        Shift = false;
        return 0x00;
    }

    if (Code < 0x7D) {
        char c = scancode[Code];
        // if (Shift) {
        //     c = ConvertShift(c);
        // }
        return c;
    }
    return 0x00;
}

uint8_t MyChar;

class PS2Keyboard {
public:
    static void Handler(uint64_t Error, uint64_t Vector) {

        // On interrupt received for keypress, print it out. Basically as simple as it can get.
        // To add: modifier keys (shift)
        //         Change it so that instead of writing to the console, it will either send the char to active process
        //             or write to a singular active buffer. We'll see. Maybe something completely different.
        // uint8_t rcvd = Device::Port::InputByte(0x60);

    uint8_t Code = ScanByte();

    if (Code == 0x2A || Code == 0x36) {
        Shift = true;
    }
    else if (Code == 0xAA || Code == 0xB6) {
        Shift = false;
    }

    if (Code < 0x7D) {
        char c = scancode[Code];
        if (Shift) {
            c = ConvertShift(c);
        }
        MyChar = c;
    }

        // if (rcvd < 0x7D) {
        //     // Console::Print("Keyboard Interrupt: got ");
        //     const char c = scancode[rcvd];
        //     Device::Console::PutChar(c);

        //     // Probably a terrible way of doing backspace. But it's the first way I thought of.
        //     // Can be changed later, obviously.
        //     if (rcvd == BACKSPACE) {
        //         Device::Console::PutChar(' ');
        //         Device::Console::PutChar(c);
        //     }
        // }
        // ScanCode = ScanByte();

        Device::PIC::AcknowledgeIRQ(0x01);
    }

    static int GetChar() {
        // // if (ScanCode == 0x1E) Console::Print("Tha Fuck?!?");
        // char c = ScanCodeToChar(ScanCode);
        // // if (c == 'a') Console::PutChar(c);
        // ScanCode = 0x00;
        // // IDT::Enable();
        char c = MyChar;
        MyChar = 0x00;
        return c;
    }

    static void Init() {
        Device::IDT::SetHandler(0x21, (uint64_t)&PS2Keyboard::Handler);
        Device::PIC::EnableIRQ(0x01);
        // Console::Print("Keyboard Initialized!\n");
    }
private:
};

extern "C" void GlossMain(void) {
    // Device::Console::PrintHex((uint32_t)0x12345678);
    Device::Console::Print("Hello, World!\n");
    Device::PIT::Init();

    Device::Console::Print("Sleep Test: (1 Second) ");
    Device::PIT::Sleep(1000);
    Device::Console::Print("Finished.\n");

    PS2Keyboard::Init();

    while (true) {
        char c = PS2Keyboard::GetChar();
        if (c) Device::Console::PutChar(c);
    }
}