#include <Driver/Legacy/PIC.hpp>
#include <Driver/CPU/IDT.hpp>
#include <Driver/Port.hpp>

using PIC = Driver::Legacy::PIC;
using IDT = Driver::CPU::IDT;
using Port = Driver::Port;

#include <Driver/Console.hpp>
using Console = Driver::Console;

extern "C" void IRQHandler(IDT::ISRPack Pack) {
    PIC::Instance().Handler(Pack);
}

extern "C" void SetIRQHandlers(void) {
    IDT::Instance().SetHandler(0x20, &IRQHandler);
    IDT::Instance().SetHandler(0x21, &IRQHandler);
    IDT::Instance().SetHandler(0x22, &IRQHandler);
    IDT::Instance().SetHandler(0x23, &IRQHandler);
    IDT::Instance().SetHandler(0x24, &IRQHandler);
    IDT::Instance().SetHandler(0x25, &IRQHandler);
    IDT::Instance().SetHandler(0x26, &IRQHandler);
    IDT::Instance().SetHandler(0x27, &IRQHandler);
    IDT::Instance().SetHandler(0x28, &IRQHandler);
    IDT::Instance().SetHandler(0x29, &IRQHandler);
    IDT::Instance().SetHandler(0x2A, &IRQHandler);
    IDT::Instance().SetHandler(0x2B, &IRQHandler);
    IDT::Instance().SetHandler(0x2C, &IRQHandler);
    IDT::Instance().SetHandler(0x2D, &IRQHandler);
    IDT::Instance().SetHandler(0x2E, &IRQHandler);
    IDT::Instance().SetHandler(0x2F, &IRQHandler);
}

void PIC::Handler(IDT::ISRPack Pack) {
//    Console::Print("Tha Fuck?\n");
    IDT::ISRCallback handler = Callbacks_[Pack.Vector - 0x20];
    if (handler != 0x00) {
//        Console::Print("Handler Found!\n");
        handler(Pack);
    }
    if (Pack.Vector >= 0x28) {
        Port::OutputByte(0x00A0, 0x20);
    }
    Port::OutputByte(0x0020, 0x20);
}