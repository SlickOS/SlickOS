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

BootStart:
    jmp 0x0000:BootReal

BootReal:
        xor ax, ax
        mov ds, ax
        mov es, ax
        mov fs, ax
        mov gs, ax
        mov ss, ax
        mov sp, 0x7C00

        mov [BootBlock.DriveNumber], dl

        mov si, [BootBlock.DriveNumber]
        mov di, 0x7E00
        mov ax, 0x0001
        xor bx, bx
        xor dx, dx
        mov cx, 0x10
        call I8086.Storage.Load
        test ax, 0x01
        jnz BootReal.Failure

        call I8086.Memory.ClearBSS
        call I8086.IO.Init
        call I8086.IO.Clear
//        call I8086.CPU.Query
        call I8086.A20.Enable
        call I8086.Memory.Map

        call I8086.GDT32.Load

        cli
        mov eax, cr0
        or al, 0x01
        mov cr0, eax


        jmp 0x08:BootProtected

BootReal.Failure:
    mov eax, 0xb8000
    mov [eax], word ptr 0x4080
    cli
    hlt

.align 16
I8086.Storage.DiskAccessPacket:
    I8086.Storage.DiskAccessPacket.StructSize:          .byte   0x10
    I8086.Storage.DiskAccessPacket.Reserved:            .byte   0x00
    I8086.Storage.DiskAccessPacket.Count:               .word   0x0010
    I8086.Storage.DiskAccessPacket.Address.Offset:      .word   0x7E00
    I8086.Storage.DiskAccessPacket.Address.Segment:     .word   0x0000
    I8086.Storage.DiskAccessPacket.Block.Low:           .int    0x00000001
    I8086.Storage.DiskAccessPacket.Block.High:          .int    0x00000000

// // This function loads the rest of the bootloader from the disk.
// I8086.Storage.Load:
//     // First, we store some state.
//     push ax
//     push dx
//     push si

//     // Next, we load the Disk Access Packet (DAP) and store it in the SI
//     // register. We then load the function number and drive number into the
//     // AH and DL registers, respectively.
//     mov si, offset I8086.Storage.DiskAccessPacket
//     mov ah, 0x42
//     mov dl, [BootBlock.DriveNumber]

//     // Now we execute the interrupt. If the function failed, the carry flag
//     // will be set, and we will be unable to boot the bootsector.
//     int 0x13

//     // Now we restore state and return to the calling function.
//     pop si
//     pop dx
//     pop ax

//     ret
.include "Platform/x86/I8086/Storage/Load.inc"

.org 510
.word 0xAA55

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
    sub bx, ax
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

// This function enables the A20 line by toggling its status if necessary.
I8086.A20.Enable:
    // Our A20 line enabling function uses our toggle function in conjunction
    // with the check function to enable the A20 line for us. The first thing
    // we do, however, is store some state.
    push ax

    // Next we check the current A20 line value. We also set the A20 line
    // status flag in our flags variable to enabled (we will reset it later on
    // the off chance we cannot enable the A20 line).
    mov al, [BSS.A20.Status]
    or al, 0x01
    mov [BSS.A20.Status], al
    call I8086.A20.Check
    jnc I8086.A20.Enable.Exit

    // Now we attempt to toggle the A20 line value.
    call I8086.A20.Toggle
    jnc I8086.A20.Enable.Exit

    // If we reach this point, we were unable to enable the A20 line. We thus
    // set the A20 line value in our flags variable to disabled.
    mov al, [BSS.A20.Status]
    and al, 0xFE
    mov [BSS.A20.Status], al

    I8086.A20.Enable.Exit:
        // The final thing we do is restore state and return to the calling
        // function.
        pop ax
        ret

// This function disables the A20 line by toggling its status if necessary.
I8086.A20.Disable:
    // Our A20 line disabling function uses our toggle function in conjunction
    // with the check function to disable the A20 line for us. The first thing
    // we do, however, is store some state.
    push ax

    // Next we check the current A20 line value. We also set the A20 line
    // status flag in our flags variable to disabled (we will reset it later on
    // the off chance we cannot disable the A20 line).
    mov al, [BSS.A20.Status]
    and al, 0xFE
    mov [BSS.A20.Status], al
    call I8086.A20.Check
    jc I8086.A20.Disable.Exit

    // Now we attempt to toggle the A20 line value.
    call I8086.A20.Toggle
    jnc I8086.A20.Disable.Exit

    // If we reach this point, we were unable to disable the A20 line. We thus
    // set the A20 line value in or flags variable to enabled.
    mov al, [BSS.A20.Status]
    or al, 0x01
    mov [BSS.A20.Status], al

    I8086.A20.Disable.Exit:
        // The final thing we do is restore state and return ot the calling
        // function.
        pop ax
        ret

// This function initializes the first serial port (COM1) at 9600 baud with no
// parity, one stop bit, and eight data bits.
I8086.IO.Serial.Init:
    xor dx, dx
    mov ax, 0x00E3
    int 0x14
    or word ptr [BSS.IO.Serial.Flags], 0x0001
    ret

// This function prints a single character to the first serial port (COM1).
I8086.IO.Serial.Print:
    // The first thing we do is store some state.
    push ax
    push dx

    // Next, we clear the dx register as 0x00 in the dx register corresponds to
    // the first serial port. We then invoke the interrupt required to send
    // data using the serial port.
    xor dx, dx
    mov ah, 0x01
    int 0x14

    // We finally restore state and return to the calling function.
    pop dx
    pop ax
    ret

// This function initialized the video card to an 80x25 character text mode
// with blinking disabled and 4 bits of foreground and 4 bits of background
// color.
I8086.IO.Video.Init:
    // The first thing we do is store the pre-function state, as we dont want
    // to destroy register contents.
    push ax
    push bx
    push cx

    // Now we test if a VGA compatible video card is present using the BIOS
    // function to retrieve the display combination code. If the function
    // returns anything other than 0x1A in the AL register, then the function
    // failed and we do not have a suitable video card.
    mov ax, 0x1A00
    int 0x10
    cmp al, 0x1A
    jne I8086.IO.Video.Init.Done

    // At this point we know we have a video card present, although it may not
    // yet be configured to output anything useful. We thus set the flag for
    // the presence of a video card.
    or byte ptr [BSS.IO.Video.Flags], 0x01

    // Now we get the video state information. This will allow us to determine
    // what move the video card is currently in, and if we have to change any
    // of its properties. If the function failes, we assume the mode is not
    // correct and we set it to the mode we want.
    mov ax, 0x1B00
    xor bx, bx
    mov di, offset BSS.IO.Video.State
    int 0x10
    cmp al, 0x1B
    jne I8086.IO.Video.Init.Reset

    // Now we check the various properties of the video card. We first check if
    // the current mode is equal to the mode we want, which is 80x25 characters
    // with 16 foreground and background colors. This corresponds to mode 3, so
    // if the mode value doesn't match, we reset the video card.
    cmp byte ptr [BSS.IO.Video.State.VideoMode], 0x03
    jne I8086.IO.Video.Init.Reset

    // Next we check the number of columns. Wer want 80 (0x50) columns, so we
    // compare the value the video card gave us and reset if necessary.
    cmp byte ptr [BSS.IO.Video.State.Display.Columns], 0x50
    jne I8086.IO.Video.Init.Reset

    // Next we check the number of rows. Apparently, some BIOSes are funky and
    // output the number of rows or the number of rows minus one for the value,
    // so we check for both. If the number matches either then we know that we
    // have the correct video properties and can skip resetting the mode.
    cmp byte ptr [BSS.IO.Video.State.Display.Rows], 0x19
    je I8086.IO.Video.Init.SetProperties
    cmp byte ptr [BSS.IO.Video.State.Display.Rows], 0x18
    je I8086.IO.Video.Init.SetProperties

    // If we reach this point, we will be resetting the video card's current
    // mode.
    I8086.IO.Video.Init.Reset:
        // Now we will set the video card's mode to mode 3.
        mov ax, 0x0003
        int 0x10

    // Now we will set additional properties of the video card, as they are
    // almost guaranteed to be incorrect.
    I8086.IO.Video.Init.SetProperties:
        // A few of the undesirable properties of the video card are that the
        // card most likely begins with a cursor enabled, and with the highest
        // bit of the background color dedicated to a 'blink' mode. As we don't
        // want either of these, we'll start by getting rid of the cursor.
        mov ah, 0x01
        mov cx, 0x2D0E
        int 0x10

        // Now we disable blinking, which will give us 16 background colors
        // instead of only 8.
        mov ax, 0x1003
        xor bx, bx
        int 0x10

        // We finally retrieve the current display page, which is necessary to
        // output text to the screen.
        xor bx, bx
        mov ah, 0x0F
        int 0x10
        mov [BSS.IO.Video.DisplayPage], bh

    I8086.IO.Video.Init.Done:
        // We finally restore state and return to the calling function.
        pop cx
        pop bx
        pop ax
        ret

// The following function prints a single character to the video card.
I8086.IO.Video.Print:
    // The first thing we do is store some state.
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push bp

    // Next we check if we have a newline character (0x0A). If so, we have to
    // print an additional character, the carriage return (0x0D), to the screen
    // at the same time.
    cmp al, 0x0A
    jne I8086.IO.Video.Print.Output

    I8086.IO.Video.Print.Newline:
        // Now we print the character using the BIOS.
        mov ah, 0x0E
        mov bh, [BSS.IO.Video.DisplayPage]
        int 0x10
        mov al, 0x0D

    I8086.IO.Video.Print.Output:
        // Now we print the character using the BIOS.
        mov ah, 0x0E
        mov bh, [BSS.IO.Video.DisplayPage]
        int 0x10

    // We finally restore state and return to the calling function.
    pop bp
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    
    ret

// The follwoing function initialized all forms of IO that the primary boot
// sector can utilize.
I8086.IO.Init:
    // We first initialize the first serial port (COM1).
    call I8086.IO.Serial.Init

    // We next initialize the video card.
    call I8086.IO.Video.Init

    // Now we return to the calling function.
    ret

// The following function prints a character using all forms of IO available to
// the primary boot sector.
I8086.IO.Print.Char:
    I8086.IO.Print.Char.Serial:
        // We check if the serial port has been enabled and skip printing if it
        // is not. Otherwise, we output a character through the serial port.
        test byte ptr [BSS.IO.Serial.Flags], 0x01
        je I8086.IO.Print.Char.Video
        call I8086.IO.Serial.Print

    I8086.IO.Print.Char.Video:
        // We check if the video card has been enabled and skip printing if it
        // is not. Otherwise, we output a character through the video card.
        test byte ptr [BSS.IO.Video.Flags], 0x01
        je I8086.IO.Print.Char.Done
        call I8086.IO.Video.Print

    I8086.IO.Print.Char.Done:
        // We finally return to the calling function.
        ret

// The following function prints a null terminated string to all initialized
// forms of IO available to the primary boot sector.
I8086.IO.Print.String:
    // We first store some state.
    push ax
    push si
    pushf

    // Since we want to print each character one by one, we simply load each
    // byte one by one and push it to the character printing function. This
    // requires, however, that the direction flag is clear so we read the
    // correct memory.
    cld

    I8086.IO.Print.String.Execute:
        // We load a byte from the string. If it is null, then we are done
        // printing the string.
        lodsb
        test al, al
        jne I8086.IO.Print.String.Done

        // Now we simply call the character printing function.
        call I8086.IO.Print.Char

        // Now we load the next byte from the string, and continue.
        jmp I8086.IO.Print.String.Execute

    I8086.IO.Print.String.Done:
        // We finally restore state and exit to the calling function.
        popf
        pop si
        pop ax

        ret

// This function simply clears an 80x25 region of text (equivalent to a full
// video screen in text mode 3).
I8086.IO.Clear:
    // We first store some state.
    push ax
    push cx

    // We are going to print a total of 2000 characters, so we store that in
    // the counter register.
    mov cx, 2000

    I8086.IO.Clear.Loop:
        // Now we simply print 2000 spaces.
        mov al, 0x20
        call I8086.IO.Print.Char
        loop I8086.IO.Clear.Loop

    I8086.IO.Clear.Cursor:
        // Now we check if the video card is enabled. If it is, we move the
        // cursor to the top left of the screen.
        test byte ptr [BSS.IO.Video.Flags], 0x01
        je I8086.IO.Clear.Done
        mov ah, 0x02
        mov bh, [BSS.IO.Video.DisplayPage]
        xor dx, dx
        int 0x10

    I8086.IO.Clear.Done:
        // Now we restore state and return to the calling function.
        pop cx
        pop ax

        ret

// The following function loads the 32 bit GDT and installs it using the 'lgdt'
// instruction.
I8086.GDT32.Load:
    cli
    pusha
    lgdt [I8086.GDT32.Pointer]
    sti
    popa
    ret

// The following function clears the .BSS section of the executable.
I8086.Memory.ClearBSS:
    // First, we store some state.
    push ax
    push cx
    push di
    pushf

    // Now we set the size, location, and fill byte. Both the size and location
    // of the .BSS section are defined by the linker, so these constants are
    // not located in the current source file. The fill byte is nulled, as we
    // want fully empty memory.
    mov cx, SECTION_BSS_SIZE
    mov di, SECTION_BSS_START
    xor ax, ax

    // Now we clear the direction flag so we don't write-out the wrong portion
    // of memory.
    cld

    // We finally store the nulled byte throughout the entire .BSS section.
    rep stosb

    // We now restore state and return to the calling function.
    popf
    pop di
    pop cx
    pop ax

    ret

// This function generates a memory map using various memory detection methods.
I8086.Memory.Map:
    // Currently, the only method we have for building a memory map is by using
    // the BIOS E820 function to generate one for us. This means that if this
    // function ends up being unsupported, we won't have a memory map, and thus
    // must set a status bit in the main bootloader flags. We first start by
    // storing some state.
    push di

    // xor ax, ax
    // mov es, ax
    mov di, 0x1800

    // Now we call our E820 memory map function.
    call I8086.Memory.Map.E820

    // We now restore state and return to the calling function.
    pop di

    ret

// This function generates an ACPI-compatible memory map using BIOS functions.
I8086.Memory.Map.E820:
    // We first start by storing state.
    push eax
    push ebx
    push ecx
    push edx
    push bp
    push di

    // We now start by setting the function number along with the magic number,
    // as wellas clearing some registers and setting the destination for our
    // memory map.
    xor ebx, ebx
    xor bp, bp
    mov edx, 0x534D4150
    mov eax, 0xE820
    mov dword ptr es:[di + 0x0014], 0x00000001
    mov ecx, 0x18

    // Next we call the interrupt and check if it was supported.
    int 0x15
    jc I8086.Memory.Map.E820.Failure

    // Now we check the value of the next memory block. A value of zero
    // indicates that the current block is the last block in the list of E820
    // memory map entries. Therefore, if it is zero now then our list is only
    // one entry long and therefore invalid.
    test ebx, ebx
    je I8086.Memory.Map.E820.Failure

    // Now we start analyzing the entry to see if it is valid.
    jmp I8086.Memory.Map.E820.CheckEntry

    I8086.Memory.Map.E820.LoadEntry:
        // We simply load another entry (the same as above) into our memory
        // map.
        mov eax, 0xE820
        mov dword ptr es:[di + 0x0014], 0x00000001
        mov ecx, 0x18
        int 0x15

        // If the carry flag is set then we are at the end of the list.
        jc I8086.Memory.Map.E820.Finished

        // We now reset the magic number as some BIOSes trash its value.
        mov edx, 0x534D4150

    I8086.Memory.Map.E820.CheckEntry:
        // Here, if the size of the resultant buffer is zero, then the memory
        // entry is garbage and we skip it.
        jcxz I8086.Memory.Map.E820.SkipEntry

        // Next we check the size of the entry. If it was an ACPI 2 or earlier
        // response, the size should be 20, and we skip over the ACPI 3 and
        // later portions of the function.
        cmp cl, 0x14
        jbe I8086.Memory.Map.E820.NotExtended

        // Next we check if the entry should be ignored according to ACPI 3. If
        // it is, we skip the entry.
        test byte ptr es:[di + 0x0014], 0x00000001
        je I8086.Memory.Map.E820.SkipEntry

    I8086.Memory.Map.E820.NotExtended:
        // Now we check whether the length is zero. If any bits are set in the
        // length value, then the address is valid and we have a complete
        // entry. Otherwise, we skip the entry.
        mov ecx, es:[di + 0x0008]
        or ecx, es:[di + 0x000C]
        jz I8086.Memory.Map.E820.SkipEntry

        inc bp
        add di, 0x0018

    I8086.Memory.Map.E820.SkipEntry:
        // Now we check if we've reached the end of memory blocks.
        test ebx, ebx
        jne I8086.Memory.Map.E820.LoadEntry

    I8086.Memory.Map.E820.Finished:
        // Now we store the number of entries and clear the carry flag for
        // success.
        mov [BSS.Memory.Map.Count], bp
        clc

        // We also store the end of the memory map.
        mov [BSS.Memory.Map.End], di

        // We now prepare to return.
        jmp I8086.Memory.Map.E820.Exit

    I8086.Memory.Map.E820.Failure:
        // Now we set the carry flag for failure.
        stc

    I8086.Memory.Map.E820.Exit:
        // We now restore state (and store the address of the memory map).
        pop di
        pop bp
        pop edx
        pop ecx
        pop ebx
        pop eax

        mov [BSS.Memory.Map.Address], di

        // We finally return to the calling function.
        ret

// This code will be executed in a 32 bit protected mode environment.
.code32

BootProtected:
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    mov eax, 0xb8000
    mov [eax], word ptr 0x4040

    cli
    hlt

// The following code is located in the .DATA (initialized variable) section of
// the binary.
.section .data

I8086.GDT32:
    I8086.GDT32.Null:
        I8086.GDT32.Null.Limit.Low:                     .word   0x0000
        I8086.GDT32.Null.Base.Low:                      .word   0x0000
        I8086.GDT32.Null.Base.Middle:                   .byte   0x00
        I8086.GDT32.Null.Access:                        .byte   0x00
        I8086.GDT32.Null.Flags:                         .byte   0x00
        I8086.GDT32.Null.Base.High:                     .byte   0x00
    I8086.GDT32.Code:
        I8086.GDT32.Code.Limit.Low:                     .word   0xFFFF
        I8086.GDT32.Code.Base.Low:                      .word   0x0000
        I8086.GDT32.Code.Base.Middle:                   .byte   0x00
        I8086.GDT32.Code.Access:                        .byte   0x9A
        I8086.GDT32.Code.Flags:                         .byte   0xCF
        I8086.GDT32.Code.Base.High:                     .byte   0x00
    I8086.GDT32.Data:
        I8086.GDT32.Data.Limit.Low:                     .word   0xFFFF
        I8086.GDT32.Data.Base.Low:                      .word   0x0000
        I8086.GDT32.Data.Base.Middle:                   .byte   0x00
        I8086.GDT32.Data.Access:                        .byte   0x92
        I8086.GDT32.Data.Flags:                         .byte   0xCF
        I8086.GDT32.Data.Base.High:                     .byte   0x00
    I8086.GDT32.Pointer:
//        .equ I8086.GDT32.Size, (I8086.GDT32.Pointer - I8086.GDT32 - 1)
        I8086.GDT32.Pointer.Limit:                      .word   (I8086.GDT32.Pointer - I8086.GDT32 - 1)
        I8086.GDT32.Pointer.Base:                       .int    I8086.GDT32

// The following code is located in the .RODATA (constant data) section of the
// binary.
.section .rodata

Message.ProductName:    .asciz "SLICK OS"

// The following code is located in the .BSS (uninitialized variable) section
// of the binary.
.section .bss

BSS.IO.Serial:
    BSS.IO.Serial.Flags:                                    .skip 0x01, 0x00
BSS.IO.Video:
    BSS.IO.Video.Flags:                                     .skip 0x01, 0x00
    BSS.IO.Video.DisplayPage:                               .skip 0x01, 0x00
    BSS.IO.Video.State:
        BSS.IO.Video.State.StaticTable:                     .skip 0x04, 0x00
        BSS.IO.Video.State.VideoMode:                       .skip 0x01, 0x00
        BSS.IO.Video.State.Display.Columns:                 .skip 0x02, 0x00
        BSS.IO.Video.State.RegenBuffer.Length:              .skip 0x02, 0x00
        BSS.IO.Video.State.RegenBuffer.Address:             .skip 0x02, 0x00
        BSS.IO.Video.State.Cursor.Page0:                    .skip 0x02, 0x00
        BSS.IO.Video.State.Cursor.Page1:                    .skip 0x02, 0x00
        BSS.IO.Video.State.Cursor.Page2:                    .skip 0x02, 0x00
        BSS.IO.Video.State.Cursor.Page3:                    .skip 0x02, 0x00
        BSS.IO.Video.State.Cursor.Page4:                    .skip 0x02, 0x00
        BSS.IO.Video.State.Cursor.Page5:                    .skip 0x02, 0x00
        BSS.IO.Video.State.Cursor.Page6:                    .skip 0x02, 0x00
        BSS.IO.Video.State.Cursor.Page7:                    .skip 0x02, 0x00
        BSS.IO.Video.State.Cursor.Type:                     .skip 0x02, 0x00
        BSS.IO.Video.State.ActiveDisplayPage:               .skip 0x01, 0x00
        BSS.IO.Video.State.CRTCPortAddress:                 .skip 0x02, 0x00
        BSS.IO.Video.State.PortSetting.P03x8:               .skip 0x01, 0x00
        BSS.IO.Video.State.PortSetting.P03x9:               .skip 0x01, 0x00
        BSS.IO.Video.State.Display.Rows:                    .skip 0x01, 0x00
        BSS.IO.Video.State.BytesPerCharacter:               .skip 0x02, 0x00
        BSS.IO.Video.State.Display.Code:                    .skip 0x01, 0x00
        BSS.IO.Video.State.Display.Code.Alternate:          .skip 0x01, 0x00
        BSS.IO.Video.State.Display.Colors:                  .skip 0x02, 0x00
        BSS.IO.Video.State.Display.Pages:                   .skip 0x01, 0x00
        BSS.IO.Video.State.Display.ScanLines:               .skip 0x01, 0x00
        BSS.IO.Video.State.Reserved:                        .skip 0x15, 0x00
BSS.Memory:
    BSS.Memory.Map:
        BSS.Memory.Map.Address:                             .skip 0x08, 0x00
        BSS.Memory.Map.Count:                               .skip 0x08, 0x00
        BSS.Memory.Map.End:                                 .skip 0x08, 0x00
BSS.A20:
    BSS.A20.Status:                                         .skip 0x01, 0x00

// vim: set ft=intelasm:
