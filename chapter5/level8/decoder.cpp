#include <iostream>
#include <stdlib.h>
#include <sstream>
#include <bitset>
#include <string>
#include <fstream>
#include <vector>
#include "bitmap_image.hpp"

using namespace std;

int main(){
    bitmap_image output("lvl8_bin");

    if(!output)
        return 1;

    cout << "[*] Imagen BMP encontrada y abierta" << endl;

    const unsigned int alto = output.height();
    const unsigned int ancho = output.width();
    vector<int> bits;
    cout << "[*] Decodificando LSB..." << endl;
    for(int y = alto - 1; y >= 0; y--){
        for(int x = 0 ; x < ancho ; x++){
            rgb_t color;
            output.get_pixel(x, y, color);

            bitset<8> blue((int)color.blue);
            bitset<8> green((int)color.green);
            bitset<8> red((int)color.red);

            bits.push_back(blue[0]);
            bits.push_back(green[0]);
            bits.push_back(red[0]);
        }
    }

    cout << "[*] Bits decodificados" << endl;

    ofstream hexa("decoded.txt");

    if(!hexa.is_open())
        return 1;

    cout << "[*] Transformando a hexadecimal..." << endl;
    string byte = "";
    for(int i = 0 ; i < bits.size() ; i++){
        if(i != 0 && i % 4 == 0){
            int decim = 0;
            for(int j = 0 ; j < byte.size() ; j++)
                decim += (byte[j] - '0') * pow(2, byte.size() - j - 1);
            stringstream ss;
            ss << std::hex << decim << " ";
            hexa << ss.str();
            byte = "";

        }
        byte += bits[i] + '0';
    }

    hexa.close();

    cout << "[*] Transformando a RAW data..." << endl;
    system("xxd -r -p decoded.txt fileDecoded");
    system("rm decoded.txt");

    return 0;
}
