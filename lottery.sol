pragma solidity >=0.7.0 <0.9.0;

contract lottery {
    struct User{
        uint choice;
        bytes32 commit;
        address addr;
    }

    address public owner;
    uint private T1;
    uint private T2;
    uint private T3;
    uint private N;

    uint private reward = 0;
    uint private startTime = 0;
    uint private numUser = 0;
    uint private numRevealed = 0;

    mapping (address => uint) private userNumber;
    mapping (uint => User) private users;
    uint[] revealedUsers;

    constructor(uint t1, uint t2, uint t3, uint n) {
        owner = msg.sender;
        T1 = t1;
        T2 = t2;
        T3 = t3;
        N = n;
    }

    function _reset() private {
        for(uint i = 0; i < numUser; i++) {
            userNumber[users[i].addr] = N + 1;
            users[i].choice = 1000;
            users[i].commit = bytes32(0);
            users[i].addr = address(0);
        }

        reward = 0;
        startTime = 0;
        numUser = 0;
        numRevealed = 0;
        delete revealedUsers;
    }

    function addUser(uint choice, uint salt) public payable {
        require(msg.value == 1e15 wei);
        require(numUser < N);
        require(startTime == 0 || block.timestamp - startTime <= T1);

        if (startTime == 0) {
            startTime = block.timestamp;
        }

        reward += msg.value;

        userNumber[msg.sender] = numUser;

        users[numUser].choice = 1000;
        users[numUser].commit = keccak256(abi.encodePacked(bytes32(choice), bytes32(salt)));
        users[numUser].addr = msg.sender;

        numUser++;
    }

    function revealChoice(uint choice, uint salt) public {
        uint id = userNumber[msg.sender];
        require(id != N + 1);
        uint temp = block.timestamp - startTime - T1;
        require(temp >= 0 && temp <= T2);
        require(keccak256(abi.encodePacked(bytes32(choice), bytes32(salt))) == users[id].commit);

        users[id].choice = choice;
        revealedUsers.push(id);
    }

    function checkWinner() public payable {
        uint temp = block.timestamp - startTime - T1 - T2;
        require(temp >= 0 && temp <= T3);
        require(owner == msg.sender);

        uint winner;
        address payable winnerAddr;

        if (numRevealed >= 1) {
            winner = users[revealedUsers[0]].choice;
            for(uint i = 1; i < numRevealed; i++) {
                winner ^= users[revealedUsers[i]].choice;
            }

            winner %= numUser;
            if (users[winner].choice > 999) {
                winnerAddr = payable(0xb3c2c183E51cA4025F3D3E814209779ba6E2821D);
            }
            else {
                winnerAddr = payable(users[winner].addr);
            }
        }
        else {
            winnerAddr = payable(0xb3c2c183E51cA4025F3D3E814209779ba6E2821D);
        }
 
        temp = reward * 98 / 100;

        winnerAddr.transfer(temp);
        reward -= temp;
        payable(owner).transfer(reward);

        _reset();
    }

    function withdraw() public payable {
        require(block.timestamp - startTime - T1 - T2 - T3 >= 0);

        for(uint i = 0; i < numUser; i++) {
            payable(users[i].addr).transfer(1e15 wei);
        }

        _reset();
    }
}