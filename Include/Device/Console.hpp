#pragma once

#include <stdint.h>

namespace Device {
    class Console {
    public:
        enum class TextColor : uint8_t {
            Black = 0,
            Blue = 1,
            Green = 2,
            Cyan = 3,
            Red = 4,
            Magenta = 5,
            Brown = 6,
            LightGray = 7,
            DarkGray = 8,
            LightBlue = 9,
            LightGreen = 10,
            LightCyan = 11,
            LightRed = 12,
            Pink = 13,
            Yellow = 14,
            White = 15
        };

        //static void Print(const char *Text);
        static void Print(const char *Text, ...);
        static void PutChar(char Char);

        static void PrintHex(uint64_t Number);
        static void PrintHex(uint32_t Number);
        static void PrintHex(uint16_t Number);
        static void PrintHex(uint8_t Number);
        static void PrintDecimal(uint64_t Number);

        static void SetForeground(TextColor Color);
        static void SetBackground(TextColor Color);

        static void Clear(void);
        static void Scroll(void);
    };
}