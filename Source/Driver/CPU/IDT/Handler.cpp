#include <Driver/CPU/IDT.hpp>
#include <Driver/Legacy/PIC.hpp>

using IDT = Driver::CPU::IDT;
using PIC = Driver::Legacy::PIC;

#include <Driver/Console.hpp>
using Console = Driver::Console;

bool fucked = false;

extern "C" {
    void ISRHandler(IDT::ISRPack Pack) {
        IDT::Instance().Handler(Pack);
    }
}

void IDT::Handler(ISRPack Pack) {
//    if (!fucked) {
//        Console::Print("Vector: "); Console::PrintHex((uint8_t)Pack.Vector); Console::Print("\n");
//    }
//    if (!fucked && Pack.Vector == 0x0D) {
//        Console::Print("GPF: "); Console::PrintHex(Pack.Error); Console::Print("\n");
//        Console::Print("Address: "); Console::PrintHex((uint16_t)Pack.CS); Console::Print(":"); Console::PrintHex(Pack.RIP); Console::Print("\n");
//    }
//    if (Pack.Vector == 0x06) fucked = true;
    if (Pack.Vector >= 0x20 && Pack.Vector <= 0x2F) {
        PIC::Instance().Handler(Pack);
    }
}