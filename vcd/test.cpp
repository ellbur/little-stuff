
#include "vcd.hpp"
#include <string>
#include <iostream>
#include <utility>

using namespace std;

int main() {
    string vcdPath = "./dump.vcd";
    VCD vcd(vcdPath);
    
    Signal edge = (vcd & "uut_g" & "edge").asSignal();
    for (Change ch : edge.changes()) {
        cout << ch.time << " " << ch.value << "\n";
    }
}

