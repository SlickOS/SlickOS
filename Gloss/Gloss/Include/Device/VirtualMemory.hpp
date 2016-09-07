#pragma once

namespace Device {
    class VirtualMemory {
    public:
        static bool Init(void);

        static void Reload(void);

        static bool Map(uint64_t Physical, uint64_t Virtual);
        static bool Unmap(uint64_t Virtual);

    private:
        static bool SetPML4(uint64_t Address);
    };
}