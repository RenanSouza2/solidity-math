// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Math {
    uint internal constant ONE = 10 ** 18;
    uint internal constant TWO = 2  * ONE;

    // x is an fixed point 18 number less than 2
    function log2dec(uint x)
    public pure returns (uint y) {
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
}
