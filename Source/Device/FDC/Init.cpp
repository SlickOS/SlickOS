#include <Device/FDC.hpp>
#include <Device/IDT.hpp>
#include <Device/PIC.hpp>

using namespace Device;

bool FDC::Init(void) {
    IDT::SetHandler(0x26, (uint64_t)&FDC::Handler);
    PIC::EnableIRQ(0x06);

    Reset();
    
    return true;
}