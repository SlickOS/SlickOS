#include <Driver/ACPI/Tables.hpp>
#include <Driver/Memory.hpp>

namespace ACPI = Driver::ACPI;
using Memory = Driver::Memory;

ACPI::Tables::RSDP *ACPI::RSDP(void) {
    static ACPI::Tables::RSDP *RSDP = (ACPI::Tables::RSDP *)(0x00000000);
    if (!RSDP) {
        for (uint64_t address = 0x00000000; address < 0x00100000; address += 0x10) {
            if (Memory::Equal((const uint8_t *)"RSD PTR ", (const uint8_t *)(address), 8)) {
                RSDP = (ACPI::Tables::RSDP *)(address);
                break;
            }
        }
    }
    return RSDP;
}