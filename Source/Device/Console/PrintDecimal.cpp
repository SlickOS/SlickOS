#include <Device/Console.hpp>

using namespace Device;

void Console::PrintDecimal(uint64_t Number) {
    if (Number == 0) {
        Console::PutChar('0');
        return;
    }

    int64_t num = Number;
    char reversed[32];
    int i = 0;
    while (num > 0) {
        reversed[i] = '0' + num % 10;
        num /= 10;
        i++;
    }
    reversed[i] = 0;

    char actual[32];
    actual[i--] = 0;
    int j = 0;
    while(i >= 0) {
        actual[i--] = reversed[j++];
    }
    Console::Print(actual);
}