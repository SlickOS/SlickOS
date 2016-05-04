#include <Device/FDC.hpp>
#include <Device/PIC.hpp>

#include <Device/Console.hpp>

using namespace Device;

void FDC::Handler(uint64_t Error, uint64_t Vector) {
    Console::Print("Floppy Interrupt!\n");
    IRQOccurance = true;
    PIC::AcknowledgeIRQ(0x06);
}

bool FDC::IRQOccurance;