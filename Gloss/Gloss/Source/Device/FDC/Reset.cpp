#include <Device/FDC.hpp>

using namespace Device;

void FDC::Reset(void) {
    uint8_t status0;
    uint8_t cylinder;

    Disable();
    Enable();
    Wait();

    for (uint8_t i = 0; i < 4; ++i) {
        CommandCheckInterrupt(&status0, &cylinder);
    }

    WriteControl(0x00);
    CommandSpecify(3, 16, 240, true);
    CommandCalibrate(CurrentDrive_);
}