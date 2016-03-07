//===========================================================================//
// Generic Loader for Operating System Software (GLOSS)                      //
// Boot Sector Initialization                                                //
//                                                                           //
// Copyright 2015-2016 - Adrian J. Collado         <acollado@polaritech.com> //
// All Rights Reserved                                                       //
//                                                                           //
// This file is licensed under the MIT license, see the LICENSE file in the  //
// root of this project for more information. If this file was not included  //
// with the this project, see http://choosealicense.com/licenses/mit.        //
//===========================================================================//

// Seeing as how AT&T assembly syntax is much more obscure and difficult to
// read than Intel assembly syntax, the assembly language code in this project
// for x86 based architectures will be using Intel syntax.
.intel_syntax noprefix

// This code will be executed in a 16 bit real mode environment.
.code16

// This code is located in the .TEXT (executable) section of the binary.
.section .text

.global BootEntry
BootEntry:
        jmp BootStart

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

DataPacket:
    DataPacket.StructSize:  .byte   0x00
    DataPacket.Reserved:    .byte   0x00
    DataPacket.Count:       .word   0x0080
    DataPacket.Address:     .word   0x0000
    DataPacket.Segment:     .word   0x0800
    DataPacket.BlockLow:    .int    0x00000001
    DataPacket.BlockHigh:   .int    0x00000000

BootStart:
    jmp 0x0000:BootMain

BootMain:
        cli
        xor ax, ax
        mov ds, ax
        mov es, ax
        mov fs, ax
        mov gs, ax
        mov ss, ax
        mov sp, 0x7C00

        mov byte ptr [BootBlock.DriveNumber], dl

        mov si, offset DataPacket
        mov ah, 0x42
        mov dl, 0x80
        int 0x13
        jc BootError

// This function checks the A20 line status by observing if memory accesses
// wrap around at 1MiB.
I8086.A20.Check:
    // This function checks the status of the A20 line by observing the effect
    // of writing a byte value at the edge of the IBM PC's memory span. If the
    // word wraps around to the start of memory, then the A20 line is disabled.
    // We start by storing some state.
    push ax
    push ds
    push es
    push di
    push si

    // Next we disable interrupts. If memory does wrap around in this function,
    // then (very) bad things will happen if a CPU interrupt occurs, as the
    // start of memory on an x86 system is the location of the real mode IVT
    // (Interrupt Vector Table). If an interrupt occurs, it will attempt to use
    // the function addresses stored in the table, and if those addresses are
    // invalid, junk code will execute.
    cli

    // Next we set two segment registers, the data segment register and the
    // extra segment register, to 0x0000 and 0xFFFF, respectively. We do this
    // since we will soon want to access the first byte of memory and the first
    // byte of memory after 1MiB of total memory.
    xor ax, ax
    mov es, ax
    not ax
    mov ds, ax

    // Next we set two index registers, the destinatin index register and the
    // source index register, to 0x0500 and 0x0510, respectively. These
    // registers have values, when used in the proper segment, refer to
    // locations exactly 1 MiB apart.
    mov di, 0x0500
    mov si, 0x0510

    // We now store the current bytes at our test memory locations. We do this
    // because, as stated above, we don't want to mess up the real mode IVT. At
    // this point in the bootloader, we will still need BIOS interrupts.
    mov al, es:[di]
    push ax
    mov al, ds:[si]
    push ax

    // Now we write two distinct bytes to both memory locations. This allows us
    // to check to see if, when we wrote the second value, that the first value
    // was overwritten. If this is the case, then our memory wraps around, and
    // the A20 line is not enabled. If it doesn't overwrite the first value,
    // then the A20 line is enabled.
    mov byte ptr es:[di], 0x00
    mov byte ptr ds:[si], 0xFF
    cmp byte ptr es:[di], 0xFF

    // Now we restore the original values that were at the memory locations. We
    // don't have to worry about corrupting the result of the previous
    // comparison, as none of the instructions that we execute right now affect
    // the FLAGS register.
    pop ax
    mov ds:[si], al
    pop ax
    mov es:[di], al

    // Now we set a status value by using the carry flag. If memory did not
    // wrap around, then we clear the carry flag. If it did wrap around, then
    // we set the carry flag.
    clc
    je I8086.A20.Check.Exit
    stc

    I8086.A20.Check.Exit:
        // Now we can re-enable interrupts, as the real mode IVT was returned
        // to normal.
        sti

        // We finally reset all of the registers that we used back to their
        // previous values and return to the calling function.
        pop si
        pop di
        pop es
        pop ds
        pop ax
        ret

// This function toggles the A20 line using standard BIOS functions.
I8086.A20.Toggle.BIOS:
    // The fastest, and arguably the safest (and most modern) method we have to
    // enable the A20 line is by using the BIOS itself. The nice thing about
    // this function is that the operation, if supported, almost always works
    // (due to being tied to the underlying hardware quite closely), and is
    // supported on most computers since the mid 1990's. Therefore, we use this
    // method befoe all others, and then if it doesn't work we move onto some
    // other method. Before proceeding, we store some state.
    push ax
    push bx

    // Next we load the function numbers 0x2401 and 0x2402. The second function
    // queries about the status of the A20 line. The first function is used to
    // enable the A20 line. Another function, 0x2400, is used to disable the
    // A20 line. The nice thing about the query function is that it returns a
    // status code, 0x00 for disabled, and 0x01 for enabled in the AX register.
    // If we subtract the status code from the register that stores the
    // function number for enabling the A20 line, we have created a toggle
    // switch for the A20 line status. If, for example, the A20 line is
    // enabled, the query function will return 0x01. We can then subtract that
    // return value from 0x2401, which is the function number for enabling the
    // A20 line. The result is 0x2400, which is the function for disabling the
    // A20 line. The process is the same if the query function returns 0x00,
    // in which case the chosen function will be 0x2401.
    mov bx, 0x2401
    mov ax, 0x2402

    // Now we simply call the query interrupt. If the function fails, the carry
    // flag will be set, allowing us to exit the function gracefully and try
    // another method.
    int 0x15
    jmp I8086.A20.Toggle.BIOS.Exit

    // Now we perform the calculation to get the correct BIOS function to call.
    // We do this, as stated above, by subtracting the return code from the
    // function number. We then swap the registers they are stored in so we can
    // call the correct BIOS function.
    sub bl, ax
    xchg bx, ax

    // Then it is just a matter of performing the interrupt. We don't have to
    // check for a carry flag this time, since if one of the A20 line functions
    // exists (and succeeds), then all of the A20 line functions exist (and
    // will succeed). However, we will still want to verify that the A20 line
    // was actually toggled, in the case of extenuating circumstances.
    int 0x15

    I8086.A20.Toggle.BIOS.Exit:
        // We finally restore the pre-function state, and return to the calling
        // function.
        pop bx
        pop ax
        ret

// This function toggles the A20 line using the "Fast" A20 method (System
// Control Port 0x92).
I8086.A20.Toggle.Fast:
    // This function, while called the Fast A20 method, is actually quite slow
    // (although it is much faster than enabling the A20 line using the PS/2
    // keyboard controller), and on some systems is quite dangerous. This
    // function is the least recommended of all of the functions we use to
    // toggle the A20 line. What this function does is outputs a value through
    // system control port 0x92. The problem with this method is that on some
    // computers it is unsupported, and may do something entirely unexpected
    // (such as clearing the screen or eating your laundry). Therefore, we
    // should only use this method if we have no other choice.
    push ax
    in al, 0x92
    xor al, 0x02
    and al, 0xFE
    out 0x92, al
    pop ax
    ret

// This function toggles the A20 line using the 8042 PS/2 controller.
I8086.A20.Toggle.PS2:
    // Before starting the toggle function, a bit about the 8042 PS/2
    // controller should be discussed. The 8042 PS/2 controller is the
    // controller used for the keyboard on IBM PC-AT compatible computers, as
    // well as the mouse on anything from the IBM PS/2 onward (a second channel
    // was added to the controller to support a second device). Back when
    // hardware was limited and the IBM PC was being designed, it was found
    // that the 8042 chip had an extra pin that wasn't being used. The
    // designers, in their infinite wisdom, chose that pin for controlling the
    // the A20 line memory extensions (they also added a method to reset the
    // entire computer through another pin). Since the x86 architecture is
    // notorious for backwards compatibility, we can still toggle the A20 line
    // using the 8042 PS/2 controller.

    // Nowadays, the functions of the 8042 PS/2 controller are integrated into
    // a device called the AIP (Advanced Integrated Peripheral), and in many
    // cases, is directly integrated into the motherboard's southbridge. The
    // methods of using the controller, however, remain the same.

    // When we modify the A20 line, rather than explicitly enabling or
    // disabling the A20 line, it is actually much easier and provides more
    // code reusability (and thus saves space in our binary) if we toggle the
    // current value, as enabling and disabling are virtually the same. When
    // using this method, the first thing we have to do is store some state and
    // disable interrupts.
    push ax
    cli

    // For this method of toggling the A20 line, we will be performing direct
    // hardware programming. The first thing we do is disable the first PS/2
    // port by issuing a command to the PS/2 controller through its command
    // port 0x64.
    call I8086.A20.Toggle.PS2.Writable
    mov al, 0xAD
    out 0x64, al

    // Next we issue a command to read the PS/2 controller's output port. We do
    // this by again issuing a command through its command port.
    call I8086.A20.Toggle.PS2.Writable
    mov al, 0xD0
    out 0x64, al

    // Next we read the output port of the PS/2 controller.
    call I8086.A20.Toggle.PS2.Readable
    in al, 0x60
    push ax

    // Now we issue a command to write to the PS/2 controller's output port. We
    // do this by issuing yet another command through the command ort.
    call I8086.A20.Toggle.PS2.Writable
    mov al, 0xD1
    out 0x64, al

    // Now we write our updated A20 line value to the PS/2 controller's output
    // port. What we do is toggle the A20 line enabled bit of the PS/2
    // controller data register that we recieved when we read the byte value
    // from the PS/2 controller.
    call I8086.A20.Toggle.PS2.Writable
    pop ax
    xor ax, 0x02
    out 0x60, al

    // Finally, we wait until the PS/2 controller's input buffer is clear, and
    // then we finally exit (after, of course, re-enabling interrupts and
    // restoring state.
    call I8086.A20.Toggle.PS2.Writable
    sti
    pop ax
    ret

    // This sub-function is a simple polling (also known as looping) function
    // tht just tests if the PS/2 controller's input buffer is clear. When the
    // input buffer is clear, we are able to send commands or data to the PS/2
    // controller.
    I8086.A20.Toggle.PS2.Writable:
        in al, 0x64
        test al, 0x02
        jnz I8086.A20.Toggle.PS2.Writable
        ret

    // This sub-function is another simple polling function that tests if the
    // PS/2 controller's output buffer is full. When the buffer is full, we are
    // able to read data from the PS/2 controller.
    I8086.A20.Toggle.PS2.Readable:
        in al, 0x64
        test al, 0x01
        jz I8086.A20.Toggle.PS2.Readable
        ret

// This function toggles the A20 line using the individual toggle functions.
I8086.A20.Toggle:
    // Our A20 line toggle function uses each of our different toggling
    // functions in conjunction with the check function to toggle the A20 line
    // for us. The first thing we do, however, is store some state (and clear
    // the carry flag).
    clc
    push ax
    push bx
    push cx

    // Next we check the current A20 line value so we can determine what state
    // the A20 line is in to begin with.
    call I8086.A20.Check
    pushf
    pop bx
    and bx, 0x01

    // Now we attempt to toggle the A20 line using the BIOS. After trying this
    // method, we check if the A20 line is toggled using our check function.
    call I8086.A20.Toggle.BIOS
    call I8086.A20.Check
    pushf
    pop cx
    and cx, 0x01
    test cx, bx
    clc
    jne I8086.A20.Toggle.Exit

    // If our BIOS function didn't work, we attempt to toggle the A20 line
    // using the PS/2 controller. It is reasonable to assume that if the BIOS
    // function failed, then the PS/2 function will succeed. We then check the
    // A20 line status again, just to make sure.
    call I8086.A20.Toggle.PS2
    call I8086.A20.Check
    pushf
    pop cx
    and cx, 0x01
    test cx, bx
    clc
    jne I8086.A20.Toggle.Exit

    // Our last and final hope is to try the Fast A20 method. On Some systems
    // attempting this method can be extremely bad, but if we reach this point
    // then we really have nothing to lose. After calling the Fast A20 method,
    // we once again check the A20 line status.
    call I8086.A20.Toggle.Fast
    call I8086.A20.Check
    pushf
    pop cx
    and cx, 0x01
    test cx, bx
    clc
    jne I8086.A20.Toggle.Exit

    // If we reach this point, we could not toggle the A20 line. We thus return
    // a carry flag as a failure result.
    stc

    I8086.A20.Toggle.Exit:
        // The final thing we do is restore pre-function state and return to
        // the calling function.
        pop cx
        pop bx
        pop ax
        ret

// vim: set ft=intelasm:
