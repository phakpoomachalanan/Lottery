pragma solidity >=0.7.0 <0.9.0;

contract lottery {
    struct User{
        uint16 choice;
        byte32 commit;
        address addr;
    }

    uint private T1;
    uint private T2;
    uint private T3;
    uint private N;

    uint private startTime = 0;
    uint private numUser = 0;

    mapping (address => uint) private userNumber;
    mapping (uint => User) private users;

    constructor(uint t1, uint t2, uint t3, uint n) {
        T1 = t1;
        T2 = t2;
        T3 = t3;
        N = n;
    }

    function _reset() private {
        startTime = 0;
        numUser = 0;
    }

    function addUser(uint choice, uint salt) public payable {
        require(msg.value == 1e15 wei);
        require(numUser < N);
        require(startTime == 0 || block.timestamp - startTime <= T1);

        if (startTime == 0) {
            startTime = block.timestamp;
        }

        userNumber[msg.sender] = numUser;

        users[numUser].choice = 1000;
        users[numUser].commit = keccak256(abi.encodePacked(bytes32(choice), bytes32(salt)));
        users[numUser].addr = msg.sender;

        numUser++;
    }

    function revealChoice(uint choice, uint salt) public {
        uint id = userNumber[msg.sender];
        require(block.timestamp - startTime - T1 <= T2);
        require(keccak256(abi.encodePacked(bytes32(choice), bytes32(salt))) == users[id].commit);

        users[id].choice = choice;
    }
}