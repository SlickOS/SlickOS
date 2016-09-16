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

// This code will be executed in a 64 bit long mode environment.
.code64

// This code is located in the .DATA (read-write) section of the executable.
.section .data

.global AMD64.Console.Color.Black
.equ AMD64.Console.Color.Black, 0x00

.global AMD64.Console.Color.Blue
.equ AMD64.Console.Color.Blue, 0x01

.global AMD64.Console.Color.Green
.equ AMD64.Console.Color.Green, 0x02

.global AMD64.Console.Color.Cyan
.equ AMD64.Console.Color.Cyan, 0x03

.global AMD64.Console.Color.Red
.equ AMD64.Console.Color.Red, 0x04

.global AMD64.Console.Color.Magenta
.equ AMD64.Console.Color.Magenta, 0x05

.global AMD64.Console.Color.Brown
.equ AMD64.Console.Color.Brown, 0x06

.global AMD64.Console.Color.LightGray
.equ AMD64.Console.Color.LightGray, 0x07

.global AMD64.Console.Color.DarkGray
.equ AMD64.Console.Color.DarkGray, 0x08

.global AMD64.Console.Color.LightBlue
.equ AMD64.Console.Color.LightBlue, 0x09

.global AMD64.Console.Color.LightGreen
.equ AMD64.Console.Color.LightGreen, 0x0A

.global AMD64.Console.Color.LightCyan
.equ AMD64.Console.Color.LightCyan, 0x0B

.global AMD64.Console.Color.LightRed
.equ AMD64.Console.Color.LightRed, 0x0C

.global AMD64.Console.Color.Pink
.equ AMD64.Console.Color.Pink, 0x0D

.global AMD64.Console.Color.Yellow
.equ AMD64.Console.Color.Yellow, 0x0E

.global AMD64.Console.Color.White
.equ AMD64.Console.Color.White, 0x0F
