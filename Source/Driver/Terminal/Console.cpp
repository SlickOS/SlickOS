#include <stdint.h>
#include <stddef.h>
#include <Driver/Console.hpp>

using Console = Driver::Console;

Console::TextColor Console::ColorBackground_;
Console::TextColor Console::ColorForeground_;

unsigned char Console::CursorX_;
unsigned char Console::CursorY_;

uint16_t *VideoMemory = (uint16_t *)0xB8000;

void Console::Clear(void) {
    uint8_t colorB = (uint8_t)ColorBackground_ << 4;
    uint8_t colorF = (uint8_t)ColorForeground_ & 0x0F;
    uint16_t attribute = (colorB | colorF) << 8;
    for (int i = 0; i < 80 * 25; ++i) {
        VideoMemory[i] = ' ' | attribute;
    }
}

void Console::Print(const char *Text) {
    while (*Text != 0) {
        PutChar(*(Text++));
    }
}

// template <typename T1, typename... ArgT>
// void Console::Print(const char *Text, T1 Arg1, ArgT... Args) {
//     size_t NumberArgs = sizeof...(Args);
//     if (NumberArgs >= 1) {
//         Console::Print(Text, Args...);
//     }
// }

void Console::PutChar(char Char) {
    uint8_t colorB = (uint8_t)ColorBackground_ << 4;
    uint8_t colorF = (uint8_t)ColorForeground_ & 0x0F;
    uint16_t attribute = (colorB | colorF) << 8;

    if (Char == 0x08 && CursorX_) {
        CursorX_--;
    }
    else if (Char == 0x09) {
        CursorX_ = (CursorX_ + 8) & 0xF8;
    }
    else if (Char == '\r') {
        CursorX_ = 0;
    }
    else if (Char == '\n') {
        CursorX_ = 0;
        CursorY_++;
    }
    else if (Char >= ' ') {
        uint16_t *location = VideoMemory + (CursorY_ * 80 + CursorX_);
        *location = Char | attribute;
        CursorX_++;
    }

    if (CursorX_ >= 80) {
        CursorX_ = 0;
        CursorY_++;
    }

    if (CursorY_ >= 25) {
        Scroll();
    }

    UpdateHardwareCursor();
}

void Console::SetForeground(Console::TextColor Color) {
    ColorForeground_ = Color;
}

void Console::SetBackground(Console::TextColor Color) {
    ColorBackground_ = Color;
}

void Console::Scroll(void) {
    if (CursorY_ >= 25) {
        uint8_t colorB = (uint8_t)ColorBackground_ << 4;
        uint8_t colorF = (uint8_t)ColorForeground_ & 0x0F;
        uint16_t attribute = (colorB | colorF) << 8;

        for (int i = 0; i < 1920; ++i) {
            VideoMemory[i] = VideoMemory[i + 80];
        }
        for (int i = 1920; i < 2000; ++i) {
            VideoMemory[i] = ' ' | attribute;
        }
        CursorY_ = 24;
    }
}

void Console::UpdateHardwareCursor(void) {
    uint16_t location = CursorY_ * 80 + CursorX_;

    // TODO: Update Hardware Cursor!
}

void Console::Init(void) {
    CursorY_ = 0;
    CursorX_ = 0;
    ColorForeground_ = TextColor::LightGray;
    ColorBackground_ = TextColor::Black;
}

void Console::PrintHex(uint64_t Number) {
    Console::Print("0x");
    uint64_t digit = 0x0F;
    for (int i = 60; i >= 0; i -= 4) {
        uint8_t val = (uint8_t)((Number & (digit << i)) >> i);
        Console::PutChar((char)(val <= 9 ? '0' + val : 'A' - 10 + val));
    }
}
void Console::PrintHex(uint32_t Number) {
    Console::Print("0x");
    uint64_t digit = 0x0F;
    for (int i = 28; i >= 0; i -= 4) {
        uint8_t val = (uint8_t)((Number & (digit << i)) >> i);
        Console::PutChar((char)(val <= 9 ? '0' + val : 'A' - 10 + val));
    }
}
void Console::PrintHex(uint16_t Number) {
    Console::Print("0x");
    uint64_t digit = 0x0F;
    for (int i = 12; i >= 0; i -= 4) {
        uint8_t val = (uint8_t)((Number & (digit << i)) >> i);
        Console::PutChar((char)(val <= 9 ? '0' + val : 'A' - 10 + val));
    }
}
void Console::PrintHex(uint8_t Number) {
    Console::Print("0x");
    uint64_t digit = 0x0F;
    for (int i = 4; i >= 0; i -= 4) {
        uint8_t val = (uint8_t)((Number & (digit << i)) >> i);
        Console::PutChar((char)(val <= 9 ? '0' + val : 'A' - 10 + val));
    }
}

void Console::PrintDecimal(uint64_t Number) {
    if (Number == 0) {
        Console::PutChar('0');
        return;
    }

    int64_t num = Number;
    char reversed[32];
    int i = 0;
    while (num > 0) {
        reversed[i] = '0' + num % 10;
        num /= 10;
        i++;
    }
    reversed[i] = 0;

    char actual[32];
    actual[i--] = 0;
    int j = 0;
    while(i >= 0) {
        actual[i--] = reversed[j++];
    }
    Console::Print(actual);
}