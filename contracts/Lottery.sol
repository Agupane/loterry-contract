pragma solidity ^0.4.17;

contract Lottery{
    address public manager;
    address public lastWinner;
    mapping(address => uint) private pool;
    address[] public players;

    function Lottery() public{
        manager = msg.sender;
    }

    function enter() public payable{
        require(msg.value >= 0.01 ether);
        players.push(msg.sender);
        pool[msg.sender] += msg.value;
    }

    function pickWinner() public ownerOnly {
        uint indexWinner = random() % players.length;
        players[indexWinner].transfer(this.balance);
        lastWinner = players[indexWinner];
        players = new address[](0);
    }

    function random() private view returns(uint) {
        return uint(keccak256(block.difficulty, now, players));
    }

    modifier ownerOnly() {
        require(msg.sender == manager);
        _;
    }


    function getPlayers() public view returns(address[]) {
        return players;
    }
}