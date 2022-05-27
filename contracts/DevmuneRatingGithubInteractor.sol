// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";

contract DevmuneRatingInteractor is ChainlinkClient {
  using Chainlink for Chainlink.Request;

  bytes public data;

  mapping (string => uint256) public ratingData;

  string public firstPlace;

  string public secondPlace;

  string public thirdPlace;

  bytes32 private jobId;

  uint256 private fee;

  constructor(address _linkToken, address _operator) {
    setChainlinkToken(_linkToken);
    setChainlinkOracle(_operator);
    jobId = "512265735ece4bcb929b66b0d1ee7432";
    fee = 0.1 * 10 ** 18;
  }

  event DataFulfilled(
    bytes32 indexed requestId,
    string firstPlace,
    uint256 firstPlaceWeight,
    string secondPlace,
    uint256 secondPlaceWeight,
    string thirdPlace,
    uint256 thirdPlaceWeight
  );

  function requestRating(string memory repository, string memory repositoryOwner, string memory dateFrom) public
  {
    Chainlink.Request memory request = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);

    request.add("repo", repository);
    request.add("repo_owner", repositoryOwner);
    request.addInt("records_limit", 100);
    request.add("from_date_time", dateFrom);
    request.addInt("users_in_rating_limit", 3);
    
    sendOperatorRequest(request, fee);
  }

  function fulfill(bytes32 requestId, bytes memory firstPlaceUserResponse, uint256 firstPlaceWeightResponse, bytes memory secondPlaceUserResponse, uint256 secondPlaceWeightResponse, bytes memory thirdPlaceUserResponse, uint256 thirdPlaceWeightResponse) public recordChainlinkFulfillment(requestId)
  {
    string memory _firstPlace = bytesToString(firstPlaceUserResponse);
    string memory _secondPlace = bytesToString(secondPlaceUserResponse);
    string memory _thirdPlace = bytesToString(thirdPlaceUserResponse);
    
    emit DataFulfilled(
      requestId, 
      _firstPlace, 
      firstPlaceWeightResponse,
      _secondPlace, 
      secondPlaceWeightResponse,
      _thirdPlace,
      thirdPlaceWeightResponse
    );

    firstPlace = _firstPlace;
    secondPlace = _secondPlace;
    thirdPlace = _thirdPlace;

    ratingData[_firstPlace] = firstPlaceWeightResponse;
    ratingData[_secondPlace] = secondPlaceWeightResponse;
    ratingData[_thirdPlace] = thirdPlaceWeightResponse;
  }

  function bytesToString(bytes memory byteCode) public pure returns(string memory stringData)
  {
      uint256 blank = 0; //blank 32 byte value
      uint256 length = byteCode.length;

      uint cycles = byteCode.length / 0x20;
      uint requiredAlloc = length;

      if (length % 0x20 > 0) //optimise copying the final part of the bytes - to avoid looping with single byte writes
      {
          cycles++;
          requiredAlloc += 0x20; //expand memory to allow end blank, so we don't smack the next stack entry
      }

      stringData = new string(requiredAlloc);

      //copy data in 32 byte blocks
      assembly {
          let cycle := 0

          for
          {
              let mc := add(stringData, 0x20) //pointer into bytes we're writing to
              let cc := add(byteCode, 0x20)   //pointer to where we're reading from
          } lt(cycle, cycles) {
              mc := add(mc, 0x20)
              cc := add(cc, 0x20)
              cycle := add(cycle, 0x01)
          } {
              mstore(mc, mload(cc))
          }
      }

      //finally blank final bytes and shrink size (part of the optimisation to avoid looping adding blank bytes1)
      if (length % 0x20 > 0)
      {
          uint offsetStart = 0x20 + length;
          assembly
          {
              let mc := add(stringData, offsetStart)
              mstore(mc, mload(add(blank, 0x20)))
              //now shrink the memory back so the returned object is the correct size
              mstore(stringData, length)
          }
      }
  }
}
