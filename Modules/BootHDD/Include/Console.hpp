#pragma once

#include <stdint.h>

class Console {
public:
    Console(void);
    ~Console(void);

    void Print(const char *val);
    void Print(char val);

    void Clear(void);

    void Scroll(int val);

private:
    uint16_t *m_ScreenBuffer;
    uint8_t m_XScreen;
    uint8_t m_YScreen;
    uint8_t m_TerminalColor;
    uint8_t m_XMax;
    uint8_t m_YMax;
};