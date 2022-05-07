pragma solidity >=0.7.0 <0.9.0;

// 在 https://remix.ethereum.org/ 下运行部署测试
contract calltest {
    address public b;

    event LogString(string, address, address);

    function test() public {
        b=address(this);
        emit LogString("in test", address(this), msg.sender);
    }
}

contract compare {
    address public b;

    calltest public testaddress;
    constructor(address addr) public {
        testaddress = calltest(addr);
    }

    bytes4 internal constant TEST_SELECTOR = bytes4(
        keccak256("test()")
    );

    function withcall()public{
        address(testaddress).call(abi.encodeWithSelector(TEST_SELECTOR));
    }

    function withdelegatecall()public{
        address(testaddress).delegatecall(abi.encodeWithSelector(TEST_SELECTOR));
    }
}
