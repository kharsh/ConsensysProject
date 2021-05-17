pragma solidity 0.5.12;
import "./Ownable.sol";
import "./provableAPI.sol";


contract CoinFlip is Ownable, usingProvable {

    uint256 private coinState;
    uint256 constant NUM_RANDOM_BYTES_REQUESTED = 1;
    uint contractBalance;
    uint256 randomNumber;
    event LogNewProvableQuery(string description);
    event generatedRandomNumber(uint256 randomNumber);
    event coinFlipped(uint _coinState);
    mapping(address => bytes32) userQuery;


    address gamblerAddress;
    uint betAmount;
    uint256 betChoice;

    function __callback(bytes32 _queryId, string memory _result, bytes memory _proof) public {
      /*require(msg.sender == provable_cbAddress());
      //if (provable_randomDS_proofVerify__returnCode(_queryId, _result, _proof) == 0) {
        randomNumber = uint256(keccak256(abi.encodePacked(_result)));
        uint256 latestNumber = randomNumber % 2;
        applyResult(_queryId, latestNumber);
        emit generatedRandomNumber(latestNumber);
      //}*/
    }

    function update() internal {
      /*uint256 QUERY_EXECUTION_DELAY = 0;
      uint256 GAS_FOR_CALLBACK = 200000;
      bytes32 calledQueryId = provable_newRandomDSQuery(QUERY_EXECUTION_DELAY, NUM_RANDOM_BYTES_REQUESTED, GAS_FOR_CALLBACK);
      userQuery[gamblerAddress] = calledQueryId;
      emit LogNewProvableQuery("Provable query was sent, standing by for the answer");*/
      randomNumber = now % 2;
      applyResult(randomNumber);
    }

    function applyResult(uint256 _latestNumber) public payable{
        coinState = _latestNumber;
        emit coinFlipped(_latestNumber);
        uint winAmount =  betAmount;
        if(betChoice == _latestNumber) {
          winAmount = winAmount * 2;
          contractBalance -= winAmount;
          msg.sender.transfer(winAmount);
        } else {
         contractBalance += msg.value;
       }
    }


    function placeBetAndFlip(uint256 _betChoice) public payable {
        require(msg.value > 0 && msg.value < contractBalance/2, "Can not pay in case of win" );
        gamblerAddress = msg.sender;
        betAmount = msg.value; //oracle fees contract gets from user
        betChoice = _betChoice;
        update();
    }

    function getRandomNumber() public view returns(uint256) {
        return randomNumber;
    }

    function getCoinState() public view returns(uint) {
        return coinState;
    }

    function getOwner() public view returns(address) {
      return owner;
    }

    function withdrawContractBalance() onlyOwner public payable returns(uint){
      uint transferBalance = contractBalance;
      contractBalance = 0;
      msg.sender.transfer(transferBalance);
      return transferBalance;
    }

    function depositeContractBalance() onlyOwner public payable returns(uint) {
      contractBalance += msg.value;
      return contractBalance;
    }

    function getContractBalance() onlyOwner view public returns(uint) {
      return contractBalance;
    }
}
