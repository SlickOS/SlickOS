#include <stdint.h>
#include <Driver/Core/HardwarePort.hpp>
#include <Driver/Core/IDT.hpp>
#include <Driver/PS2Keyboard/PS2Keyboard.hpp>
#include <Driver/Terminal/Console.hpp>

#define BACKSPACE 0x0E

// Stolen from http://www.osdever.net/bkerndev/Docs/keyboard.htm
unsigned char scancode[128] = {
	0,  27, '1', '2', '3', '4', '5', '6', '7', '8',
	'9', '0', '-', '=', '\b',	/* Backspace */
	'\t',			/* Tab */
	'q', 'w', 'e', 'r',	/* 19 */
	't', 'y', 'u', 'i', 'o', 'p', '[', ']', '\n',	/* Enter key */
	0,			/* 29   - Control */
	'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';',	/* 39 */
	'\'', '`',  0,		/* Left shift */
	'\\', 'z', 'x', 'c', 'v', 'b', 'n',			/* 49 */
	'm', ',', '.', '/',   0,				/* Right shift */
	'*',
	0,	/* Alt */
	' ',	/* Space bar */
	0,	/* Caps lock */
	0,	/* 59 - F1 key ... > */
	0,   0,   0,   0,   0,   0,   0,   0,
	0,	/* < ... F10 */
	0,	/* 69 - Num lock*/
	0,	/* Scroll Lock */
	0,	/* Home key */
	0,	/* Up Arrow */
	0,	/* Page Up */
	'-',
	0,	/* Left Arrow */
	0,
	0,	/* Right Arrow */
	'+',
	0,	/* 79 - End key*/
	0,	/* Down Arrow */
	0,	/* Page Down */
	0,	/* Insert Key */
	0,	/* Delete Key */
	0,   0,   0,
	0,	/* F11 Key */
	0,	/* F12 Key */
	0,	/* All other keys are undefined */
};

void PS2Keyboard::Handler(IDT::ISRPack Pack) {

	// On interrupt received for keypress, print it out. Basically as simple as it can get.
	// To add: modifier keys (shift)
	//         Change it so that instead of writing to the console, it will either send the char to active process
	//             or write to a singular active buffer. We'll see. Maybe something completely different.
	uint8_t rcvd = HardwarePort::InputByte(0x60);

	if (rcvd < 0x7D) {
		// Console::Print("Keyboard Interrupt: got ");
		const char c = scancode[rcvd];
		Console::PutChar(c);

		// Probably a terrible way of doing backspace. But it's the first way I thought of.
		// Can be changed later, obviously.
		if (rcvd == BACKSPACE) {
			Console::PutChar(' ');
			Console::PutChar(c);
		}
	}
}

void PS2Keyboard::Init() {
	IDT::SetHandler(0x21, &PS2Keyboard::Handler);
	// Console::Print("Keyboard Initialized!\n");
}
