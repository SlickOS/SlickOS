#pragma once

#include <stdint.h>

namespace Driver {
    namespace ACPI {
        namespace Tables {
            struct RSDP {
                char Signature[8];
                uint8_t Checksum;
                char Manufacturer[6];
                uint8_t Version;
                uint32_t Address32;
                uint32_t Length;
                uint64_t Address64;
                uint8_t ChecksumExtended;
                uint8_t Reserved[3];
            };
        }

        Tables::RSDP *RSDP(void);
    }
}