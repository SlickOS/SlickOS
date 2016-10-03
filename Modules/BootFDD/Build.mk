BootFDD_CFLAGS :=
BootFDD_CXXFLAGS :=
BootFDD_CPPFLAGS :=
BootFDD_ASFLAGS := -I Modules/BootFDD/Arch/x86_64/Source
BootFDD_LDFLAGS := -ffreestanding -O2 -nostdlib -lgcc

BootFDD_OBJINIT := Build/Arch-Objects/BootFDD/x86_64/Init.o