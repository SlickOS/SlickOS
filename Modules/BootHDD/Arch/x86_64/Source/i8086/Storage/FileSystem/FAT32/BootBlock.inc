//===========================================================================//
// Generic Loader for Operating System Software (GLOSS)                      //
//                                                                           //
// Copyright (C) 2015-2016 - Adrian J. Collado     <acollado@polaritech.net> //
//===========================================================================//
.ifndef X86_I8086_STORAGE_FILESYSTEM_FAT32_BOOTBLOCK_INC
.equ X86_I8086_STORAGE_FILESYSTEM_FAT32_BOOTBLOCK_INC, 0x01

// Seeing how AT&T assembly syntax is much more verbose than Intel assembly
// syntax, the assembly language code in this project will use Intel syntax.
.intel_syntax noprefix

// This code will be executed in a 16 bit real mode environment.
.code16

// This code is located in the .TEXT (executable) section of the binary.
.section .text

BootBlock.OEMIdentifier:            .skip   0x08, 0x00
BootBlock.BytesPerSector:           .word   0x0000
BootBlock.SectorsPerCluster:        .byte   0x00
BootBlock.ReservedSectors:          .word   0x0000
BootBlock.NumberOfFATs:             .byte   0x00
BootBlock.RootEntries:              .word   0x0000
BootBlock.TotalSectors:             .word   0x0000
BootBlock.Media:                    .byte   0x00
BootBlock.SectorsPerFAT:            .word   0x0000
BootBlock.SectorsPerTrack:          .word   0x0000
BootBlock.HeadsPerCylinder:         .word   0x0000
BootBlock.HiddenSectors:            .int    0x00000000
BootBlock.TotalSectorsLarge:        .int    0x00000000
BootBlock.SectorsPerFATLarge:       .int    0x00000000
BootBlock.Flags:                    .word   0x0000
BootBlock.VersionNumber:            .word   0x0000
BootBlock.RootDirectoryCluster:     .int    0x00000000
BootBlock.FileSystemInfoSector:     .word   0x0000
BootBlock.BackupBootSector:         .word   0x0000
BootBlock.Reserved:                 .skip   0x0C, 0x00
BootBlock.DriveNumber:              .byte   0x00
BootBlock.NTFlags:                  .byte   0x00
BootBlock.Signature:                .byte   0x00
BootBlock.Serial:                   .int    0x00000000
BootBlock.VolumeLabel:              .skip   0x0B, 0x00
BootBlock.FileSystem:               .skip   0x08, 0x00

.endif
// vim: set ft=intelasm:
