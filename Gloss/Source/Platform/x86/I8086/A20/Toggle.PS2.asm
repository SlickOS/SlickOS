//===========================================================================//
// GLOSS - Generic Loader for Operating System Software                      //
// An extensible and configurable bootloader.                                //
//---------------------------------------------------------------------------//
// Copyright (C) 2013-2016 ~ Adrian J. Collado     <acollado@polaritech.com> //
// All Rights Reserved                                                       //
//===========================================================================//

// Seeing as how AT&T syntax is much more obscure and difficult to read (IMO)
// than Intel syntax, the assembly language code in this project for x86 based
// architectures will be using Intel syntax.
.intel_syntax noprefix

// This code will be executed in a 16 bit real mode environment.
.code16

// This code is located in the .TEXT (executable) section of the executable.
.section .text

// Before starting the toggle function, a bit about the 8042 PS/2 controller
// should be discussed. The 8042 PS/2 controller is the controller used for the
// keyboard on IBM PC-AT compatible computers, as well as the mouse on anything
// from the IBM PS/2 onward. Back when hardware was limited and the IBM-PC was
// being designed, it was found that the 8042 chip had an extra pin that wasn't
// being used. The designers, in their infinite wisdom, chose that pin for
// controllering the A20 line memory extensions (they also added a method to
// reset the entire computer through another pin). Since the x86 architecture
// is notorious for backwards compatibility, we can still toggle the A20 line
// using the 8042 PS/2 controller.

// Nowadays, the functions of the 8042 PS/2 controller are integrated into a
// device called the AIP (Advanced Integrated Peripheral). The methods of using
// the controller, however, remain the same.

// This function toggles the A20 line using the 8042 PS/2 controller.
.global I8086.A20.Toggle.PS2
I8086.A20.Toggle.PS2:
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
    // port, 0x64.
    call I8086.A20.Toggle.PS2.Writable
    mov al, 0xad
    out 0x64, al

    // Next we issue a command to read the PS/2 controller's output port. We do
    // this by, again, issuing a command through its command port.
    call I8086.A20.Toggle.PS2.Writable
    mov al, 0xd0
    out 0x64, al

    // Next we read the output port of the PS/2 controller.
    call I8086.A20.Toggle.PS2.Readable
    in al, 0x60
    push ax

    // Now we issue a command to write to the PS/2 controller's output port. We
    // do this by issuing yet another command through the command port.
    call I8086.A20.Toggle.PS2.Writable
    mov al, 0xd1
    out 0x64, al

    // Now we write our updated A20 line value to the PS/2 controller's output
    // port. What we do is toggle the A20 line enabled bit of the PS/2
    // controller data register that we recieved when we read the byte value
    // from the PS/2 controller.
    call I8086.A20.Toggle.PS2.Writable
    pop ax
    xor ax, 0x02
    out 0x60, al

    // FInally, we wait until the PS/2 controller's input buffer is clear, and
    // then we finally exit (after, of course, re-enabling interrupts and
    // restoring state).
    call I8086.A20.Toggle.PS2.Writable
    sti
    pop ax
    ret

    // This sub-function is a simple polling (also known as looping) function
    // that just tests if the PS/2 controller's input buffer is clear. When the
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
        