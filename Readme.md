# Slick OS
Slick OS is an operating system designed to get out of your way and let you do things however you want. It is designed from the ground up with both developers and users in mind.

# The Parts of Slick OS
Slick OS is comprised of various components, including a custom bootloader and bootloader, as well as device drivers and basic applications.

## The Bootloader
The bootloader for Slick OS, Gloss, is designed as an extensible bootloader that can be tailored to boot multiple operating systems by allowing configuration of common boot functions (execution mode, device detection, etc..).

## The Kernel
The kernel for Slick OS is a microkernel whose sole purpose is to multiplex the hardware to applications running on the computer. It is thus designed to be very minimalistic, leaving much of the work to the drivers and applications themselves. This allows higher performance software to be designed as it minimizes the number of context switches from applications into the kernel.

## Drivers
The driver system of Slick OS is designed to run only periodically, and to load as much driver functionality into running applications as feasibly possible. This, like the kernel design, reduces the number of context switches, however this time the switches are from applications into driver code.

## Applications
Applications written for Slick OS load much of the functionality found in operating systems into their own running code to increase performance. The only code not loaded directly into the application process is related to the security and stability of the system itself.

# Hardware Requirements
As Slick is designed from the ground up, a small subset of hardware will initially be supported. One of the design choices for the initial version is support of x86-64 processors only. This allows us to focus on a single architecture, and still use the latest innovations found in personal computers. Eventually x86 and ARM will be supported, but this is currently outside of reach for this project.

The current minimum hardware requirements are as follows:
* x86-64 based processor
* 10 megabytes of hard drive space

# Software Requirements
To work with Slick OS, you must have the following software installed on your development machine:
* Linux-Based OS
* Git
* GCC
* GNU Make
* SVN
* QEMU
* xorriso
* dosfstools

# Getting Started
Currently, Slick OS does not have any pre-built images available for download. For now, you must build the operating system directly. This can be done by cloning the repository using `git clone https://github.com/SlickOS/SlickOS.git SlickOS`. If you plan on contributing to the project, fork the project and clone your fork instead of the official repository.

After cloning the repository, you need to build the toolchain. To do this, make sure you have all of the above listed software installed, and run `./Scripts/tool.sh` from the root directory of the project.

You can now build and run the operating system using the commands `make` and `make run`.

# Goals
### Bootloader
- [ ] ACPI Support
  - [ ] ACPI Detection
  - [ ] ACPI Hardware Detection
  - [ ] AML Interpretation
- [ ] AHCI Hard Disk Support
- [X] Hardware Interrupt Handling
- [ ] PS/2 Device Support
  - [X] Keyboard Support
  - [ ] Mouse Support
- [X] Processor Exception Handling
- [ ] Processor Support
  - [X] x86-64 Support
  - [ ] Processor Multicore Detection
  - [ ] Processor Multicore Initialization
  - [ ] Processor Model Identification
- [ ] VGA Support

### Kernel
- [ ] Kernel Design Document

### Drivers
- [ ] Driver Subsystem Design Document

### Applications
- [ ] Terminal Text Editor Design Document

# Contributing
If you wish to contribute to the Slick OS repository, simply submit a pull request. Code not following the style of the rest of the project won't be accepted, nor will code without (at the minimum) rudimentary test cases.
