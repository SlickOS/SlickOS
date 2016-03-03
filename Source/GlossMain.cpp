#include <Device/Console.hpp>
#include <Device/IDT.hpp>
#include <Device/PIC.hpp>
#include <Device/Port.hpp>
// #include <Device/PIT.hpp>
// #include <Device/Keyboard.hpp>

namespace Device {
    class PIT {
    public:
        static void Handler(uint64_t Error, uint64_t Vector) {
            Tick_++;
            Console::Print("Tick: ");
            Console::PrintHex((uint64_t)Tick_);
        }
        static void Init(void) {
            Tick_ = 0x00;
            Device::IDT::SetHandler(0x20, (uint64_t)&PIT::Handler);
            PIT::SetFrequency(1000);
            PIC::EnableIRQ(0x00);
        }
        static void SetFrequency(uint32_t Frequency) {
            uint32_t divisor = 1193180 / Frequency;
            Device::Port::OutputByte(0x0043, 0x36);
            uint8_t low = (uint8_t)(divisor & 0xFF);
            uint8_t high = (uint8_t)((divisor >> 8) & 0xFF);
            Device::Port::OutputByte(0x0040, low);
            Device::Port::OutputByte(0x0040, high);
        }

    private:
        static volatile int64_t Tick_;
    };
    volatile int64_t PIT::Tick_;
}

extern "C" void GlossMain(void) {
    Device::Console::Print("Hello, World!");
    Device::PIT::Init();
    asm volatile("int $0x25");
}