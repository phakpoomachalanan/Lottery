pragma solidity >=0.7.0 <0.9.0;

contract lottery {
    struct User{
        uint choice;
        byte32 commit;
        address addr;
    }

    uint private T1;
    uint private T2;
    uint private T3;
    uint private N;

    uint private stage = 1;
    uint private startTime = 0;

    constructor(uint t1, uint t2, uint t3, uint n) {
        T1 = t1;
        T2 = t2;
        T3 = t3;
        N = n;
    }

    function _reset() private {
        stage = 1;
        startTime = 0;
    }

    function addUser() public payable {
        require(msg.value == 1e15 wei);

        if (startTime == 0) {
            startTime = block.timestamp;
        }
    }
}