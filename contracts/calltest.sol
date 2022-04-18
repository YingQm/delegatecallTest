pragma solidity >=0.7.0 <0.9.0;

// 在 https://remix.ethereum.org/ 下运行部署测试
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
    address public c; // 跟位置相关
    address public b;

    calltest public testaddress;
    constructor(address addr) public {
        testaddress = calltest(addr);
    }

    bytes4 internal constant TEST_SELECTOR = bytes4(
        keccak256("test()")
    );

    function withcall()public{
        // "args": {
        // 	"0": "in test",
        // 	"1": "0x565BD1C5C443BC2F1C2aE6Fe06Ed0ee1ef08141D", // calltest 合约地址
        // 	"2": "0x9DD41ECd6e1701CE34523ed98423c1eFb0805aBD" // compare 合约地址
        // }
        // 设置地址 calltest 合约中地址 B 为 calltest 合约地址
        address(testaddress).call(abi.encodeWithSelector(TEST_SELECTOR));
    }

    function withdelegatecall()public{
        // "args": {
        // 	"0": "in test",
        // 	"1": "0x9DD41ECd6e1701CE34523ed98423c1eFb0805aBD"， // compare 合约地址
        // 	"2": "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4" // from 地址，调用合约的地址
        // }
        // 设置地址 compare 合约中地址 C 为 compare 合约地址
        address(testaddress).delegatecall(abi.encodeWithSelector(TEST_SELECTOR));
    }
}
