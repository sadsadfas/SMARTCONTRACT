/**********************************************************************
*These solidity codes have been obtained from Etherscan for extracting
*the smartcontract related info.
*The data will be used by MATRIX AI team as the reference basis for
*MATRIX model analysis,extraction of contract semantics,
*as well as AI based data analysis, etc.
**********************************************************************/
contract AmIOnTheFork {
    function forked() constant returns(bool);
}

contract SplitterEthToEtc {

    address intermediate;
    address owner;

    // there is a limit accepted by exchange
    uint256 public upLimit = 100 ether;
    // and exchange costs, ignore small transactions
    uint256 public lowLimit = 0.1 ether;

    AmIOnTheFork amIOnTheFork = AmIOnTheFork(0x2bd2326c993dfaef84f696526064ff22eba5b362);

    function SplitterEthToEtc() {
        owner = msg.sender;
    }

    function() {
        //stop too small transactions
        if (msg.value < lowLimit)
            throw;

        if (amIOnTheFork.forked()) {
            // process with exchange on the FORK chain
            if (msg.value <= upLimit) {
                // can exchange, send to intermediate
                if (!intermediate.send(msg.value))
                    throw;
            } else {
                // too much, send only acceptable value, return rest
                if (!intermediate.send(upLimit))
                    throw;
                if (!msg.sender.send(msg.value - upLimit))
                    throw;
            }
        } else {
            // always return value from CLASSIC chain
            if (!msg.sender.send(msg.value))
                throw;
        }
    }

    function setIntermediate(address _intermediate) {
        if (msg.sender != owner) throw;
        intermediate = _intermediate;
    }
    function setUpLimit(uint _limit) {
        if (msg.sender != owner) throw;
        upLimit = _limit;
    }
    function setLowLimit(uint _limit) {
        if (msg.sender != owner) throw;
        lowLimit = _limit;
    }

}