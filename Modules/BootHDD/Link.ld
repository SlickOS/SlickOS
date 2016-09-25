OUTPUT_FORMAT("binary")
phys = 0x7c00;
SECTIONS {
    SECTION_ALL_START = .;
    .text (phys) : {
        SECTION_TEXT_START = .;
        *(.text)
        *(.rodata)
        SECTION_TEXT_END = .;
        SECTION_TEXT_SIZE = (SECTION_TEXT_END - SECTION_TEXT_START);
    }
    .data : {
        SECTION_DATA_START = .;
        *(.data)
        SECTION_DATA_END = .;
        SECTION_DATA_SIZE = (SECTION_DATA_END - SECTION_DATA_START);
    }
    .bss : {
        SECTION_BSS_START = .;
        *(.bss)
        SECTION_BSS_END = .;
        SECTION_BSS_SIZE = (SECTION_BSS_END - SECTION_BSS_START);
    }
    end = .;
    SECTION_ALL_END = .;
    SECTION_ALL_SIZE = (SECTION_ALL_END - SECTION_ALL_START);
}