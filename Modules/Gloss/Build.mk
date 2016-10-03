Gloss_OBJINIT := Build/Arch-Objects/Gloss/x86_64/Init.o

Gloss_CFLAGS :=
Gloss_CXXFLAGS := -std=c++11 -ffreestanding -O1 -Wall -Wextra
Gloss_CPPFLAGS := -IModules/Gloss/Include -IModules/Gloss/Arch/x86_64/Include
Gloss_ASFLAGS :=
Gloss_LDFLAGS := -ffreestanding -O2 -nostdlib -lgcc