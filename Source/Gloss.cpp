#include <stdint.h>
#include <Driver/Console.hpp>
#include <Driver/CPU/IDT.hpp>
#include <Driver/Legacy/PIT.hpp>
#include <Driver/ACPI/Tables.hpp>
#include <Driver/Storage/FDC.hpp>

using PIT = Driver::Legacy::PIT;
using IDT = Driver::CPU::IDT;
using Console = Driver::Console;
namespace ACPI = Driver::ACPI;
using FDC = Driver::Storage::FDC;

struct BootInfo {
    uint64_t MemoryMapCount;
    uint64_t MemoryMapAddress;
    uint64_t GDTAddress;
    uint64_t PML4Address;
};

void Init(void) {
    IDT::Init();
    PIT::Init();
    Console::Init();

    PIT::SetFrequency(1000);
    Console::Clear();

    FDC::Init();
}

void PrintSector(uint64_t LBA) {
    uint8_t *addr = FDC::ReadSector(LBA);
    for (int i = 0; i < 16; ++i) {
        for (int j = 0; j < 16; ++j) {
            Console::PrintHex(addr[i * 16 + j]);
            Console::Print(" ");
        }
        Console::Print("\n");
    }
}

void PrintMemory(uint64_t Address, uint64_t Count) {
    uint64_t freeMem = 0;
    Console::Print("                        Memory Map\n");
    Console::Print("      Address             Length             Type\n");
    for (uint64_t addr = Address; addr < Address + (24 * Count); addr += 24) {
        uint64_t *ptr = (uint64_t *)addr;
        Console::PrintHex(*ptr); Console::Print("  ");
        Console::PrintHex(*(ptr + 1)); Console::Print("  ");

        uint64_t val = *(ptr + 2) & 0x00000000000000FF;
        if (val == 0x01) {
            Console::Print("Free Memory\n");
            freeMem += *(ptr + 1);
        }
        else if (val == 0x03) {
            Console::Print("Reclaimable Memory\n");
        }
        else {
            Console::Print("Unusable Memory\n");
        }
    }
    Console::Print("\n");
    Console::Print("Total Free Memory: ");
    Console::PrintDecimal(freeMem/1024/1024);
    Console::Print(" MiB (");
    Console::PrintDecimal(freeMem);
    Console::Print(" Bytes)\n");
}

extern "C" void GlossMain(BootInfo *Info) {
    Init();

    Console::Print("Boot Informtion Structure:\n");
    Console::Print("  (1) Memory Map Entries: "); Console::PrintDecimal(Info->MemoryMapCount); Console::Print("\n");
    Console::Print("  (2) Memory Map Address: "); Console::PrintHex((uint32_t)Info->MemoryMapAddress); Console::Print("\n");
    Console::Print("  (3) GDT Address:        "); Console::PrintHex((uint32_t)Info->GDTAddress); Console::Print("\n");
    Console::Print("  (4) PML4 Address:       "); Console::PrintHex((uint32_t)Info->PML4Address); Console::Print("\n");
    Console::Print("\n");

    PrintMemory(Info->MemoryMapAddress, Info->MemoryMapCount);
    Console::Print("\n");

    Console::Print("RSDP Address: "); Console::PrintHex((uint64_t)ACPI::RSDP()); Console::Print("  <<  ");
    Console::PutChar('"');
    Console::PutChar(*((uint8_t *)(ACPI::RSDP()) + 0));
    Console::PutChar(*((uint8_t *)(ACPI::RSDP()) + 1));
    Console::PutChar(*((uint8_t *)(ACPI::RSDP()) + 2));
    Console::PutChar(*((uint8_t *)(ACPI::RSDP()) + 3));
    Console::PutChar(*((uint8_t *)(ACPI::RSDP()) + 4));
    Console::PutChar(*((uint8_t *)(ACPI::RSDP()) + 5));
    Console::PutChar(*((uint8_t *)(ACPI::RSDP()) + 6));
    Console::PutChar(*((uint8_t *)(ACPI::RSDP()) + 7));
    Console::PutChar('"'); Console::Print("\n\n");

    Console::Print("Testing PIT Sleep Function\n");
    Console::Print("  (1) Wait 1.250 seconds ");
    PIT::Sleep(1250);
    Console::Print("Complete\n");
    Console::Print("  (2) Wait 0.400 seconds ");
    PIT::Sleep(400);
    Console::Print("Complete\n");
    Console::Print("  (3) Wait 0.777 seconds ");
    PIT::Sleep(777);
    Console::Print("Complete\n");
    Console::Print("PIT Sleep Test Complete\n");
    Console::Print("\n");
    PrintSector(0);

    while(true) {
        asm("hlt");
    }
}