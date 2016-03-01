#pragma once

#include <stdint.h>

namespace Driver {
    class Console {
    public:
        enum class TextColor : unsigned char {
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

        static void Clear(void);

        //static void Print(const char *Text);
        static void Print(const char *Text, ...);

        static void PutChar(char Char);

        static void PrintHex(uint64_t Number);
        static void PrintHex(uint32_t Number);
        static void PrintHex(uint16_t Number);
        static void PrintHex(uint8_t Number);
        static void PrintDecimal(uint64_t Number);

        static void DrawBox(uint8_t x, uint8_t y, uint8_t width, uint8_t height);

        static void SetForeground(TextColor Color);
        static void SetBackground(TextColor Color);
        static void SetCursorX(uint8_t X);
        static void SetCursorY(uint8_t Y);

        static void Init(void);
    private:
        static void Scroll(void);
        static void UpdateHardwareCursor(void);

        static TextColor ColorBackground_;
        static TextColor ColorForeground_;

        static unsigned char CursorX_;
        static unsigned char CursorY_;
    };
}
