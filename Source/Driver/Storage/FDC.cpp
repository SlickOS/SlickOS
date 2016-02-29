#include <Driver/Storage/FDC.hpp>
#include <Driver/CPU/IDT.hpp>
#include <Driver/Port.hpp>
#include <Driver/Legacy/PIT.hpp>

using FDC = Driver::Storage::FDC;
using IDT = Driver::CPU::IDT;
using Port = Driver::Port;
using PIT = Driver::Legacy::PIT;

bool FDCInitialized = false;
bool IRQOccurance = false;

void FDC::Handler(IDT::ISRPack Pack) {
    IRQOccurance = true;
}

void FDC::Reset(void) {
    uint8_t current = Port::InputByte((uint16_t)(Controller::Primary) + (uint16_t)(Register::DigitalOutput));
    Port::OutputByte((uint16_t)(Controller::Primary) + (uint16_t)(Register::DigitalOutput), 0x0000);
    PIT::Sleep(1);
    Port::OutputByte((uint16_t)(Controller::Primary) + (uint16_t)(Register::DigitalOutput), current);
}

void FDC::Init(void) {
    if (FDCInitialized) {
        FDC::Reset();
    }
    uint8_t status = Port::InputByte((uint16_t)(Controller::Primary) + (uint16_t)(Register::Status));
    if ((status & 0xC0) != 0x80) {

    }
}

void FDC::Wait(void) {
    while(!IRQOccurance) {
        asm("hlt");
    }
    IRQOccurance = false;
}