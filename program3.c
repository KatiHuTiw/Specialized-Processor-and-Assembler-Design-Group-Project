function patternMatching() {
    int read_bytes;
    int nocross_patter_cnt = 0;
    int found_byte_cnt = 0;
    int cross_patter_cnt = 0;
    int found_in_this_byte = 0;
    char patternToMatch = mem[32];
    patternToMatch = patternToMatch >> 3;

    for (read_bytes = 0; read_bytes < 31; read_bytes ++) {
        found_in_this_byte = 0;
        char currentByte = mem[read_bytes];
        for (int count = 0; count < 4; count ++) {
            char byteToMatch = currentByte << count;
            byteToMatch = byteToMatch >> 3;
            if (byteToMatch == patternToMatch) {
                nocross_patter_cnt++;
                found_in_this_byte = 1;
                cross_patter_cnt++;
            }
        }
        nextByte = mem[read_bytes + 1] >> 4;
        currentByte = currentByte << 4;
        currentByte = currentByte + nextByte;
        for (int count = 0; count < 4; count++) {
            char byteToMatch = currentByte << count;
            byteToMatch = byteToMatch >> 3;
            if (byteToMatch == patternToMatch) {
                nocross_patter_cnt++;
            }
        }
        if (found_in_this_byte) {
            found_byte_cnt++;
        }
    }

    mem[33] = nocross_patter_cnt;
    mem[34] = found_byte_cnt;
    mem[35] = cross_patter_cnt;
}