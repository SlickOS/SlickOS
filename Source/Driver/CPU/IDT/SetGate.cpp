#include <Driver/CPU/IDT.hpp>

using IDT = Driver::CPU::IDT;

void IDT::SetGate(uint8_t Vector, uint64_t Offset, uint16_t Selector, uint8_t Flags) {
    Entries_[Vector].OffsetLow = Offset & 0xFFFF;
    Entries_[Vector].OffsetHigh = (Offset >> 16) & 0xFFFF;
    Entries_[Vector].OffsetLong = (Offset >> 32) & 0xFFFFFFFF;

    Entries_[Vector].Selector = Selector;
    Entries_[Vector].Flags = Flags;
}