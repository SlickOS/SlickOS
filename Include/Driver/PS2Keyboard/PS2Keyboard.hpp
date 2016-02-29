#pragma once

#include <stdint.h>
#include "../Core/IDT.hpp"

class PS2Keyboard {
public:
	static void Handler(IDT::ISRPack Pack);
	static void Init(void);
};