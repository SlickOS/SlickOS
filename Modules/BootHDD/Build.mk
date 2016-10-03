BootHDD_OBJINIT := Build/Arch-Objects/BootHDD/x86_64/Init.o

BootHDD_CFLAGS :=
BootHDD_CXXFLAGS := -std=c++11 -ffreestanding -Wall -Wextra -fno-exceptions -fno-rtti
BootHDD_CPPFLAGS := -IModules/BootHDD/Include
BootHDD_ASFLAGS := -I Modules/BootHDD/Arch/x86_64/Source
BootHDD_LDFLAGS := -ffreestanding -nostdlib -lgcc