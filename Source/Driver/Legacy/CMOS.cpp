// #include <Driver/Legacy/CMOS.hpp>
// #include <Driver/Port.hpp>

// using CMOS = Driver::Legacy::CMOS;

// uint8_t CMOS::Read(CMOS::Register Type) {
//     Driver::Port::OutputByte((uint16_t)(CMOS::Port::Address), (uint8_t)Type);
//     return Driver::Port::InputByte((uint16_t)(CMOS::Port::Data));
// }