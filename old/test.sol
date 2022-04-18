// SPDX-License-Identifier: GPL-3.0
// https://www.anquanke.com/post/id/152590
pragma solidity >=0.7.0 <0.9.0;

contract calltest {
    address public b;
    address public c;

    event LogString(string, address, address);

    function test() public returns (address a){
        a=address(this);
        b=a;
        emit LogString("in test", address(this), msg.sender);
    }
}

contract compare {
    address public c;
    address public b;

    //address testaddress2 = address of calltest;
    //address testaddress2 = testaddress.b;

    bytes4 internal constant TEST_SELECTOR = bytes4(
        keccak256("test()")
    );

    // function three_call(address addr) public {
    //         //addr.call(bytes4(keccak256("test()")));                 // 情况1
    //         addr.call(abi.encodeWithSelector(TEST_SELECTOR));
    // }

    // function three_delegatecall(address addr) public {
    //         //addr.delegatecall(bytes4(keccak256("test()")));       // 情况2
    //         addr.delegatecall(abi.encodeWithSelector(TEST_SELECTOR));
    // }

    calltest public testaddress;

    constructor(address addr) public {
        testaddress = calltest(addr);
    }
    function withcall()public{
        //(bool success, bytes memory data) = address(testaddress).call(abi.encodeWithSelector(TEST_SELECTOR));
        //require(success && (data.length == 0 || abi.decode(data, (bool))), 'call: ERROR');

        address(testaddress).call(abi.encodeWithSelector(TEST_SELECTOR));
    }
    function withdelegatecall()public{
        //testaddress.delegatecall(bytes4(keccak256("test()")));
        // (bool success, bytes memory data) = address(testaddress).delegatecall(abi.encodeWithSelector(TEST_SELECTOR));
        // require(success && (data.length == 0 || abi.decode(data, (bool))), 'delegatecall: ERROR');
        address(testaddress).delegatecall(abi.encodeWithSelector(TEST_SELECTOR));
    }
}
