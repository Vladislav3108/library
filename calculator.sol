// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Calculator {
    uint256 public res;
    uint256 result;
    function sum (uint256 _firNum, uint256 _secNum) public returns(uint256 ){
       res=_firNum+_secNum;
       return res;
    }

    function sub (uint256 _firNum, uint256 _secNum) public returns(uint256 ){
       res=_firNum-_secNum;
       return res;
    }

    function div (uint256 _firNum, uint256 _secNum) public returns(uint256 ){
       res=_firNum/_secNum;
       return res;
    }

    function mul (uint256 _firNum, uint256 _secNum) public returns(uint256 ){
       res=_firNum*_secNum;
       return res;
    }

    function tr(uint256 resu, uint256 _sys) public returns(uint256 ){
        uint256 b;
        uint256 c;
        uint256 d=0;
        while (resu!=0) {
            b= resu%_sys;
            c= b+c*10**d;
            resu=resu/_sys;
            d=1;
        }
        uint256 resultF = reverse (c);
        return resultF;
    }

    function reverse (uint256 c) public returns(uint256){
        uint256 a=0;
        while (c!=0) {
            result=c%10+result*10**a;
            c=c/10;
            a=1;

        }
        return result;

    }

    
}
