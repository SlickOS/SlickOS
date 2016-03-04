#pragma once

#include <stdint.h>

namespace Device {
    class FDC {
    public:
        enum class Register : uint16_t {
            StatusA = 0x00,
            StatusB = 0x01,
            DigitalOutput = 0x02,
            TapeDrive = 0x03,
            Status = 0x04,
            RateSelect = 0x04,
            Data = 0x05,
            DigitalInput = 0x07,
            Control = 0x07
        };
        enum class Controller : uint16_t {
            Primary = 0x03F0,
            Secondary = 0x0370
        };

        enum class DigitalOutputMask : uint8_t {
            Drive0 = 0x00,
            Drive1 = 0x01,
            Drive2 = 0x02,
            Drive3 = 0x03,
            Reset = 0x04,
            DMA = 0x08,
            MotorDrive0 = 0x10,
            MotorDrive1 = 0x20,
            MotorDrive2 = 0x40,
            MotorDrive3 = 0x80
        };
        enum class StatusMask : uint8_t {
            SeekBusyDrive0 = 0x01,
            SeekBusyDrive1 = 0x02,
            SeekBusyDrive2 = 0x04,
            SeekBusyDrive3 = 0x08,
            Busy = 0x10,
            DMA = 0x20,
            Direction = 0x40,
            DataReady = 0x80
        };

        enum class Command : uint8_t {
            ReadTrack = 0x02,
            Specify = 0x03,
            CheckStatus = 0x04,
            WriteSector = 0x05,
            ReadSector = 0x06,
            Calibrate = 0x07,
            CheckInterrupt = 0x08,
            Seek = 0x0F
        };

        enum class CommandExtension : uint8_t {
            SkipDeleted = 0x20,
            Density = 0x40,
            Multitrack = 0x80
        };

        static void Handler(uint64_t Error, uint64_t Vector);
        static bool Init(void);

        static void Reset(void);

        static void Wait(void);

        static void LBACHS(uint64_t LBA, uint8_t *Head, uint8_t *Track, uint8_t *Sector);
        static uint8_t *ReadSector(uint64_t LBA);

        // Convienence Functions
        static void WriteDOR(uint8_t Value);
        static void WriteControl(uint8_t Value);
        static void WriteData(uint8_t Value);

        static uint8_t ReadStatus(void);
        static uint8_t ReadData(void);

        static void Enable(void);
        static void Disable(void);

        static void EnableMotor(uint8_t Drive);
        static void DisableMotor(uint8_t Drive);

        // DMA Functions
        static void DMAInit(void);
        static void DMARead(void);
        static void DMAWrite(void);

        // Commands
        static void CommandSpecify(uint8_t StepRate, uint8_t LoadTime, uint8_t UnloadTime, bool DMA);
        static uint8_t CommandCheckStatus(uint8_t Head, uint8_t Drive);
        static void CommandReadSector(uint64_t Address, uint8_t Head, uint8_t Track, uint8_t Cylinder, uint8_t Drive);
        static int CommandCalibrate(uint8_t Drive);
        static void CommandCheckInterrupt(uint8_t *Status, uint8_t *Cylinder);
        static int CommandSeek(uint8_t Cylinder, uint8_t Head, uint8_t Drive);

    private:
        static uint8_t CurrentDrive_;
        static uint64_t DMAAddress_;
        static bool IRQOccurance;
    };
}