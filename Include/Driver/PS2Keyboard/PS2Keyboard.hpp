#pragma once

using IDT = Driver::CPU::IDT;

class PS2Keyboard {
public:
	static void Handler(IDT::ISRPack Pack);
	static void Init(void);
};