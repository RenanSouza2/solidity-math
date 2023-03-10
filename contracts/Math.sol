// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Math {
    uint internal constant ONE = 10 ** 18;
    uint internal constant TWO = 2  * ONE;

    uint[60] internal precomputed = [
        1414213562373095049,
        1189207115002721067,
        1090507732665257659,
        1044273782427413840,
        1021897148654116678,
        1010889286051700460,
        1005429901112802821,
        1002711275050202485,
        1001354719892108206,
        1000677130693066357,
        1000338508052682313,
        1000169239705302231,
        1000084616272694313,
        1000042307241395819,
        1000021153396964808,
        1000010576642549720,
        1000005288307291763,
        1000002644150150116,
        1000001322074201118,
        1000000661036882074,
        1000000330518386416,
        1000000165259179553,
        1000000082629586363,
        1000000041314792328,
        1000000020657395951,
        1000000010328697922,
        1000000005164348948,
        1000000002582174471,
        1000000001291087235,
        1000000000645543617,
        1000000000322771808,
        1000000000161385904,
        1000000000080692952,
        1000000000040346476,
        1000000000020173238,
        1000000000010086619,
        1000000000005043309,
        1000000000002521654,
        1000000000001260827,
        1000000000000630413,
        1000000000000315206,
        1000000000000157603,
        1000000000000078801,
        1000000000000039400,
        1000000000000019700,
        1000000000000009850,
        1000000000000004925,
        1000000000000002462,
        1000000000000001231,
        1000000000000000615,
        1000000000000000307,
        1000000000000000153,
        1000000000000000076,
        1000000000000000038,
        1000000000000000019,
        1000000000000000009,
        1000000000000000004,
        1000000000000000002,
        1000000000000000001,
        1000000000000000000
    ];

    function log2dec(uint x)
    public pure returns (uint y) {
        require(x >= ONE, 'log2dec: x should be between one and two');

        uint _ONE = ONE;
        uint _TWO = TWO;
        assembly {
            y := 0
            for { let base := div(_ONE, 2) } base { base := div(base, 2) } {
                x := div(mul(x, x), _ONE)
                if lt(x, _TWO) {
                    continue
                }

                y := add(y, base)
                x := div(x, 2)
            }
        }
    }

    function log2(uint x)
    public pure returns (uint) {
        uint y_int = 0;
        while(x >= TWO) {
            y_int ++;
            x /= 2;
        }

        uint y_dec = log2dec(x);
        return y_int * ONE + y_dec;
    }

    function pow2dec(uint x) 
    public view returns (uint) {
        uint res = ONE;
        uint i = 0;
        for(uint base = ONE >> 1; base > 0; base >>= 1) {
            if(x >= base) {
                x -= base;
                res = res * precomputed[i] / ONE;
            }

            i++;
        }
        return res;
    }

    function pow2(uint x)
    public view returns (uint) {
        uint x_dec = x % ONE;
        uint x_int = x / ONE;

        require(x_int < 256, 'pow2: x should be less than 256');
        return (1 << x_int) * pow2dec(x_dec);
    }

    function pow(uint a, uint b)
    public view returns (uint) {
        return pow2(b * log2(a) / ONE);
    }

    function test(uint a) 
    external pure returns (uint) {
        return 1 << a;
    }
}
