#include <Device/Keyboard.hpp>

using namespace Device;

Keyboard::KeyCode Keyboard::ScancodeToKeycode(uint8_t Set, uint8_t S0) {
    return ScancodeToKeycode(Set, S0, 0, 0, 0, 0, 0, 0, 0);
}
Keyboard::KeyCode Keyboard::ScancodeToKeycode(uint8_t Set, uint8_t S0, uint8_t S1) {
    return ScancodeToKeycode(Set, S0, S1, 0, 0, 0, 0, 0, 0);
}
Keyboard::KeyCode Keyboard::ScancodeToKeycode(uint8_t Set, uint8_t S0, uint8_t S1, uint8_t S2) {
    return ScancodeToKeycode(Set, S0, S1, S2, 0, 0, 0, 0, 0);
}
Keyboard::KeyCode Keyboard::ScancodeToKeycode(uint8_t Set, uint8_t S0, uint8_t S1, uint8_t S2, uint8_t S3) {
    return ScancodeToKeycode(Set, S0, S1, S2, S3, 0, 0, 0, 0);
}
Keyboard::KeyCode Keyboard::ScancodeToKeycode(uint8_t Set, uint8_t S0, uint8_t S1, uint8_t S2, uint8_t S3, uint8_t S4) {
    return ScancodeToKeycode(Set, S0, S1, S2, S3, S4, 0, 0, 0);
}
Keyboard::KeyCode Keyboard::ScancodeToKeycode(uint8_t Set, uint8_t S0, uint8_t S1, uint8_t S2, uint8_t S3, uint8_t S4, uint8_t S5) {
    return ScancodeToKeycode(Set, S0, S1, S2, S3, S4, S5, 0, 0);
}
Keyboard::KeyCode Keyboard::ScancodeToKeycode(uint8_t Set, uint8_t S0, uint8_t S1, uint8_t S2, uint8_t S3, uint8_t S4, uint8_t S5, uint8_t S6) {
    return ScancodeToKeycode(Set, S0, S1, S2, S3, S4, S5, S6, 0);
}
Keyboard::KeyCode Keyboard::ScancodeToKeycode(uint8_t Set, uint8_t S0, uint8_t S1, uint8_t S2, uint8_t S3, uint8_t S4, uint8_t S5, uint8_t S6, uint8_t S7) {
    if (Set == 2) {
        // Alpha
        if (S0 == 0x1C) return KeyCode::Down_A;
        if (S0 == 0xF0 && S1 == 0x1C) return KeyCode::Up_A;
        if (S0 == 0x32) return KeyCode::Down_B;
        if (S0 == 0xF0 && S1 == 0x32) return KeyCode::Up_B;
        if (S0 == 0x21) return KeyCode::Down_C;
        if (S0 == 0xF0 && S1 == 0x21) return KeyCode::Up_C;
        if (S0 == 0x23) return KeyCode::Down_D;
        if (S0 == 0xF0 && S1 == 0x23) return KeyCode::Up_D;
        if (S0 == 0x24) return KeyCode::Down_E;
        if (S0 == 0xF0 && S1 == 0x24) return KeyCode::Up_E;
        if (S0 == 0x2B) return KeyCode::Down_F;
        if (S0 == 0xF0 && S1 == 0x2B) return KeyCode::Up_F;
        if (S0 == 0x34) return KeyCode::Down_G;
        if (S0 == 0xF0 && S1 == 0x34) return KeyCode::Up_G;
        if (S0 == 0x33) return KeyCode::Down_H;
        if (S0 == 0xF0 && S1 == 0x33) return KeyCode::Up_H;
        if (S0 == 0x43) return KeyCode::Down_I;
        if (S0 == 0xF0 && S1 == 0x43) return KeyCode::Up_I;
        if (S0 == 0x3B) return KeyCode::Down_J;
        if (S0 == 0xF0 && S1 == 0x3B) return KeyCode::Up_J;
        if (S0 == 0x42) return KeyCode::Down_K;
        if (S0 == 0xF0 && S1 == 0x42) return KeyCode::Up_K;
        if (S0 == 0x4B) return KeyCode::Down_L;
        if (S0 == 0xF0 && S1 == 0x4B) return KeyCode::Up_L;
        if (S0 == 0x3A) return KeyCode::Down_M;
        if (S0 == 0xF0 && S1 == 0x3A) return KeyCode::Up_M;
        if (S0 == 0x31) return KeyCode::Down_N;
        if (S0 == 0xF0 && S1 == 0x31) return KeyCode::Up_N;
        if (S0 == 0x44) return KeyCode::Down_O;
        if (S0 == 0xF0 && S1 == 0x44) return KeyCode::Up_O;
        if (S0 == 0x4D) return KeyCode::Down_P;
        if (S0 == 0xF0 && S1 == 0x4D) return KeyCode::Up_P;
        if (S0 == 0x15) return KeyCode::Down_Q;
        if (S0 == 0xF0 && S1 == 0x15) return KeyCode::Up_Q;
        if (S0 == 0x2D) return KeyCode::Down_R;
        if (S0 == 0xF0 && S1 == 0x2D) return KeyCode::Up_R;
        if (S0 == 0x1B) return KeyCode::Down_S;
        if (S0 == 0xF0 && S1 == 0x1B) return KeyCode::Up_S;
        if (S0 == 0x2C) return KeyCode::Down_T;
        if (S0 == 0xF0 && S1 == 0x2C) return KeyCode::Up_T;
        if (S0 == 0x3C) return KeyCode::Down_U;
        if (S0 == 0xF0 && S1 == 0x3C) return KeyCode::Up_U;
        if (S0 == 0x2A) return KeyCode::Down_V;
        if (S0 == 0xF0 && S1 == 0x2A) return KeyCode::Up_V;
        if (S0 == 0x1D) return KeyCode::Down_W;
        if (S0 == 0xF0 && S1 == 0x1D) return KeyCode::Up_W;
        if (S0 == 0x22) return KeyCode::Down_X;
        if (S0 == 0xF0 && S1 == 0x22) return KeyCode::Up_X;
        if (S0 == 0x35) return KeyCode::Down_Y;
        if (S0 == 0xF0 && S1 == 0x35) return KeyCode::Up_Y;
        if (S0 == 0x1A) return KeyCode::Down_Z;
        if (S0 == 0xF0 && S1 == 0x1A) return KeyCode::Up_Z;
        
        // Numeric
        if (S0 == 0x45) return KeyCode::Down_0;
        if (S0 == 0xF0 && S1 == 0x45) return KeyCode::Up_0;
        if (S0 == 0x16) return KeyCode::Down_1;
        if (S0 == 0xF0 && S1 == 0x16) return KeyCode::Up_1;
        if (S0 == 0x1E) return KeyCode::Down_2;
        if (S0 == 0xF0 && S1 == 0x1E) return KeyCode::Up_2;
        if (S0 == 0x26) return KeyCode::Down_3;
        if (S0 == 0xF0 && S1 == 0x26) return KeyCode::Up_3;
        if (S0 == 0x25) return KeyCode::Down_4;
        if (S0 == 0xF0 && S1 == 0x25) return KeyCode::Up_4;
        if (S0 == 0x2E) return KeyCode::Down_5;
        if (S0 == 0xF0 && S1 == 0x2E) return KeyCode::Up_5;
        if (S0 == 0x36) return KeyCode::Down_6;
        if (S0 == 0xF0 && S1 == 0x36) return KeyCode::Up_6;
        if (S0 == 0x3D) return KeyCode::Down_7;
        if (S0 == 0xF0 && S1 == 0x3D) return KeyCode::Up_7;
        if (S0 == 0x3E) return KeyCode::Down_8;
        if (S0 == 0xF0 && S1 == 0x3E) return KeyCode::Up_8;
        if (S0 == 0x46) return KeyCode::Down_9;
        if (S0 == 0xF0 && S1 == 0x46) return KeyCode::Up_9;
        
        // Whitespace
        if (S0 == 0x29) return KeyCode::Down_Space;
        if (S0 == 0xF0 && S1 == 0x29) return KeyCode::Up_Space;
        if (S0 == 0x0D) return KeyCode::Down_Tab;
        if (S0 == 0xF0 && S1 == 0x0D) return KeyCode::Up_Tab;
        
        // Symbol
        if (S0 == 0x45) return KeyCode::Down_0;
        if (S0 == 0xF0 && S1 == 0x45) return KeyCode::Up_0;
        
        // Control
        if (S0 == 0x5A) return KeyCode::Down_Enter;
        if (S0 == 0xF0 && S1 == 0x5A) return KeyCode::Up_Enter;
        if (S0 == 0x66) return KeyCode::Down_Backspace;
        if (S0 == 0xF0 && S1 == 0x66) return KeyCode::Up_Backspace;
        
        if (S0 == 0xF0) return KeyCode::Resend;
        
        return KeyCode::Null;
    }
}