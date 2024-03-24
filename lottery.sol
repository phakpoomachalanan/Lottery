pragma solidity >=0.7.0 <0.9.0;

contract lottery {
    uint T1;
    uint T2;
    uint T3;
    uint N;

    constructor(uint t1, uint t2, uint t3, uint n) {
        T1 = t1;
        T2 = t2;
        T3 = t3;
        N = n;
    }
}