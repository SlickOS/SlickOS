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

// This function generates a memory map using various memory detection methods.
.global I8086.Memory.Map
I8086.Memory.Map:
    // Currently, the only method we have for building a memory map is by using
    // the BIOS E820 function to generate one for us. This means that if this
    // function ends up being unsupported, we won't have a memory map, and thus
    // must set a status bit in the main bootloader flags. Before we continue,
    // we must store some state.
    push eax
    push ebx
    push ecx
    push edx
    push bp
    push di

    I8086.Memory.Map.E820:
        // We start by setting the function number along with the magic number,
        // as well as clearing some registers and setting our destination.
        xor ebx, ebx
        xor bp, bp
        mov edx, 0x534D4150
        mov eax, 0xE820
        mov dword ptr es:[di + 0x0014], 0x00000001
        mov ecx, 0x18
        
        // Next we call the interrupt and see if it was supported.
        int 0x15
        jc I8086.Memory.Map.E820.Failure

        // Now we reset the magic number and check if the call was successful.
        mov edx, 0x534D4150
        cmp eax, edx
        jne I8086.Memory.Map.E820.Failure

        // Now we check the value of the next memory block. A value of zero
        // indicates that the current block is the last block in the list of
        // E820 memory map entries. Therefore, if it is zero now then our list
        // is only one entry long and therefore invalid.
        test ebx, ebx
        je I8086.Memory.Map.E820.Failure

        // Now we jump into the entry-checking portion of the function.
        jmp I8086.Memory.Map.E820.CheckEntry

        I8086.Memory.Map.E820.LoadEntry:
            // We simply load another entry (the same as above) into our memory
            // map.
            mov eax, 0xE820
            mov dword ptr es:[di + 0x0014], 0x00000001
            mov ecx, 0x00000018
            int 0x15

            // If the carry flag is set then we are at the end of list.
            jc I8086.Memory.Map.E820.Finished

            // We now reset the magic number as some BIOSes trash its value.
            mov edx, 0x534D4150

        I8086.Memory.Map.E820.CheckEntry:
            // Here, if the size of the resultant buffer is zero, then the
            // memory entry is garbage and we skip it.
            jcxz I8086.Memory.Map.E820.SkipEntry

            // Next we check the size of the entry. If it was an ACPI 2 or
            // earlier response, the size should be 20, and we skip over the
            // ACPI 3 and later portions of the function.
            cmp cl, 0x14
            jbe I8086.Memory.Map.E820.NotExtended

            // Next we check if the entry should be ignored according to ACPI
            // 3. If it is, we skip the entry.
            test byte ptr es:[di + 0x0014], 0x00000001
            je I8086.Memory.Map.E820.SkipEntry

        I8086.Memory.Map.E820.NotExtended:
            // Now we check whether the length is zero. If any bits are set in
            // the length value, then the address is valid and we have a
            // complete entry. Otherwise, we skip the entry.
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

            mov [BSS.Memory.Map.End], di

            // We now prepare to return.
            jmp I8086.Memory.Map.Finished

        I8086.Memory.Map.E820.Failure:
            // Now we set the carry flag for success, as well as store a zero
            // for the number of entries.
            xor bp, bp
            mov [BSS.Memory.Map.Count], bp
            stc

            // We now prepare to return.
            jmp I8086.Memory.Map.Finished

    I8086.Memory.Map.Finished:
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
        