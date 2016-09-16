#include <Device/Keyboard.hpp>

#include <Device/Console.hpp>

#include <stdint.h>

using namespace Device;

Keyboard::KeyCode *Keyboard::Buffer_;
uint64_t Keyboard::Count_;
uint64_t Keyboard::Index_;

uint8_t Keyboard::GetCharASCII(void) {
    // return 0x00;
    if (Index_ >= Count_) return 0x00;
    KeyCode key = Buffer_[Index_];
    Buffer_[Index_++] = KeyCode::Null;
    // Index_ &= (4096 * 100 / sizeof(KeyCode)) - 1;
    // if (key == KeyCode::Null) return 0x00;
    // if (Index_ == Count_ || Index_ == Count_ + 1) return 0x00;
    // KeyCode key = Buffer_[Index_];
    // Index_++;

    // Console::Print("Getting ASCII!!!\n");

    // Console::Print("Current KeyCode: ");
    // Console::PrintHex((uint16_t)key);
    // Console::Print(" - Key: ");

    switch(key) {
        case KeyCode::Down_A: {
            if (ShiftDown_) return 'A';
            else return 'a';
        }
        case KeyCode::Down_B: {
            if (ShiftDown_) return 'B';
            else return 'b';
        }
        case KeyCode::Down_C: {
            if (ShiftDown_) return 'C';
            else return 'c';
        }
        case KeyCode::Down_D: {
            if (ShiftDown_) return 'D';
            else return 'd';
        }
        case KeyCode::Down_E: {
            if (ShiftDown_) return 'E';
            else return 'e';
        }
        case KeyCode::Down_F: {
            if (ShiftDown_) return 'F';
            else return 'f';
        }
        case KeyCode::Down_G: {
            if (ShiftDown_) return 'G';
            else return 'g';
        }
        case KeyCode::Down_H: {
            if (ShiftDown_) return 'H';
            else return 'h';
        }
        case KeyCode::Down_I: {
            if (ShiftDown_) return 'I';
            else return 'i';
        }
        case KeyCode::Down_J: {
            if (ShiftDown_) return 'J';
            else return 'j';
        }
        case KeyCode::Down_K: {
            if (ShiftDown_) return 'K';
            else return 'k';
        }
        case KeyCode::Down_L: {
            if (ShiftDown_) return 'L';
            else return 'l';
        }
        case KeyCode::Down_M: {
            if (ShiftDown_) return 'M';
            else return 'm';
        }
        case KeyCode::Down_N: {
            if (ShiftDown_) return 'N';
            else return 'n';
        }
        case KeyCode::Down_O: {
            if (ShiftDown_) return 'O';
            else return 'o';
        }
        case KeyCode::Down_P: {
            if (ShiftDown_) return 'P';
            else return 'p';
        }
        case KeyCode::Down_Q: {
            if (ShiftDown_) return 'Q';
            else return 'q';
        }
        case KeyCode::Down_R: {
            if (ShiftDown_) return 'R';
            else return 'r';
        }
        case KeyCode::Down_S: {
            if (ShiftDown_) return 'S';
            else return 's';
        }
        case KeyCode::Down_T: {
            if (ShiftDown_) return 'T';
            else return 't';
        }
        case KeyCode::Down_U: {
            if (ShiftDown_) return 'U';
            else return 'u';
        }
        case KeyCode::Down_V: {
            if (ShiftDown_) return 'V';
            else return 'v';
        }
        case KeyCode::Down_W: {
            if (ShiftDown_) return 'W';
            else return 'w';
        }
        case KeyCode::Down_X: {
            if (ShiftDown_) return 'X';
            else return 'x';
        }
        case KeyCode::Down_Y: {
            if (ShiftDown_) return 'Y';
            else return 'y';
        }
        case KeyCode::Down_Z: {
            if (ShiftDown_) return 'Z';
            else return 'z';
        }
        case KeyCode::Down_0: {
            if (ShiftDown_) return ')';
            else return '0';
        }
        case KeyCode::Down_1: {
            if (ShiftDown_) return '!';
            else return '1';
        }
        case KeyCode::Down_2: {
            if (ShiftDown_) return '@';
            else return '2';
        }
        case KeyCode::Down_3: {
            if (ShiftDown_) return '#';
            else return '3';
        }
        case KeyCode::Down_4: {
            if (ShiftDown_) return '$';
            else return '4';
        }
        case KeyCode::Down_5: {
            if (ShiftDown_) return '%';
            else return '5';
        }
        case KeyCode::Down_6: {
            if (ShiftDown_) return '^';
            else return '6';
        }
        case KeyCode::Down_7: {
            if (ShiftDown_) return '&';
            else return '7';
        }
        case KeyCode::Down_8: {
            if (ShiftDown_) return '*';
            else return '8';
        }
        case KeyCode::Down_9: {
            if (ShiftDown_) return '(';
            else return '9';
        }
        case KeyCode::Down_Comma: {
            if (ShiftDown_) return '<';
            else return ',';
        }
        case KeyCode::Down_Period: {
            if (ShiftDown_) return '>';
            else return '.';
        }
        case KeyCode::Down_Forwardslash: {
            if (ShiftDown_) return '?';
            else return '/';
        }
        case KeyCode::Down_Quote: {
            if (ShiftDown_) return '\"';
            else return '\'';
        }
        case KeyCode::Down_Semicolon: {
            if (ShiftDown_) return ':';
            else return ';';
        }
        case KeyCode::Down_BackTick: {
            if (ShiftDown_) return '~';
            else return '`';
        }
        case KeyCode::Down_Backslash: {
            if (ShiftDown_) return '|';
            else return '\\';
        }
        case KeyCode::Down_LBracket: {
            if (ShiftDown_) return '{';
            else return '[';
        }
        case KeyCode::Down_RBracket: {
            if (ShiftDown_) return '}';
            else return ']';
        }
        case KeyCode::Down_Dash: {
            if (ShiftDown_) return '_';
            else return '-';
        }
        case KeyCode::Down_Equals: {
            if (ShiftDown_) return '+';
            else return '=';
        }
        case KeyCode::Down_Backspace: {
            return '\b';
        }
        case KeyCode::Down_Space: {
            return ' ';
        }
        case KeyCode::Down_Enter: {
            return '\n';
        }
        default: {
            return 0x00;
        }
    }
}

Keyboard::KeyCode Keyboard::KeyCode_;
bool Keyboard::ShiftDown_;