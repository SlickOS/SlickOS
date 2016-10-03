#include <Console.hpp>

void Console::Print(const char *val) {
    while (*val != 0x00) {
        Console::Print(*val);
        val++;
    }
}

void Console::Print(char val) {
    uint16_t *screenAddress = m_ScreenBuffer + (m_YScreen * m_XMax) + m_XScreen;

    *screenAddress = (val | m_TerminalColor << 8);
    m_XScreen++;
}

Console::Console(void) : m_ScreenBuffer((uint16_t *)0xB8000), m_XScreen(0), m_YScreen(0), m_TerminalColor(0x07), m_XMax(80), m_YMax(25) {}
Console::~Console(void) {}