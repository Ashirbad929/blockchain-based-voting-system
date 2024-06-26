// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingSystem {
    // Structure to represent a candidate
    struct Candidate {
        string name;
        uint candidateId;
        string party;
        uint voteCount;
        string candidatePhoto;
        string partyLogo;
    }

    bool electionOn = false; // Boolean value to check if an election is in progress
    uint electionId;
    Candidate maxVoted;
    Candidate NOTA = Candidate("NOTA", 0, "NOTA", 0, "", ""); // Null candidate to reset maxVoted after each election

    string[] allVoters; // List of all the voter IDs in an election

    mapping(uint => Candidate[]) public electionCandidates; // Mapping of election ID to candidates in that election
    mapping(uint => Candidate) public elected; // Mapping of election ID to candidate who is the winner
    mapping(string => bool) public voters; // Mapping of voter ID to boolean indicating whether the voter has voted
    mapping(uint => string) public electionName; // Mapping of election ID to election name

    event VoteCasted(string indexed _voter, uint _candidateId); // Event to emit when a vote is casted
    event ElectionEnded(uint _electionId); // Event to emit when an election ends

    // Function to start a new Election
    function startElection(string memory _electionName) public {
        require(!electionOn, "An election is already in progress!");
        require(electionCandidates[electionId].length > 1, "No candidates present for election!");
        electionName[electionId] = _electionName;
        allVoters = new string[](0);
        electionOn = true;
    }

    // Function to add a candidate in an election
    function addCandidate(
        string memory _name,
        string memory _party,
        string memory _candidatePhoto,
        string memory _partyLogo
    )
        public
    {
        require(!electionOn, "An election is already in progress!");
        electionCandidates[electionId].push(Candidate(_name, electionCandidates[electionId].length, _party, 0, _candidatePhoto, _partyLogo));
    }

    // Function to cast vote
    function castVote(
        string memory _voterId,
        uint _candidateId
    )
        public
    {
        require(electionOn, "No election is in progress!");
        require(!voters[_voterId], "You have already voted!");
        require(_candidateId < electionCandidates[electionId].length && _candidateId >= 0, "Not a valid candidate!");
        
        electionCandidates[electionId][_candidateId].voteCount++;
        voters[_voterId] = true;
        allVoters.push(_voterId);

        if(electionCandidates[electionId][_candidateId].voteCount > maxVoted.voteCount)
            maxVoted = electionCandidates[electionId][_candidateId];

        emit VoteCasted(_voterId, _candidateId);
    }


    // Function to end an election
    function endElection() public {
        require(electionOn, "No election is in progress!");
        electionOn = false;
        elected[electionId] = maxVoted;
        electionId++;

        maxVoted = NOTA;
        for(uint i=0; i<allVoters.length; i++){ // Resetting all voters voting boolean to false
            voters[allVoters[i]] = false;
        }

        emit ElectionEnded(electionId - 1);
    }

    // Function to fetch result of a particular election
    function getResult(uint _electionId) public view returns (Candidate[] memory) { 
        require(_electionId < electionId, "Invalid election ID!");
        
        return electionCandidates[_electionId];
    }

    // Function to get Candidate details of ongoing election
    function getCandidates(uint _electionId) public view returns (Candidate[] memory) {
        require(_electionId <= electionId, "Invalid election ID!");

        Candidate[] memory result = electionCandidates[electionId];

        Candidate[] memory candidateDetails = new Candidate[](result.length);
        for(uint i = 0; i < result.length; i++){
            candidateDetails[i] = result[i];
            candidateDetails[i].voteCount = 0;
        }

        return candidateDetails;
    }

    // Function to get the winning candidate of an election
    function getWinner(uint _electionId) public view returns (Candidate memory) {
        require(_electionId < electionId, "Invalid election ID!");

        return elected[_electionId];
    }

    // Function to check if the election is in progress
    function isElectionInProgress(uint _electionId) public view returns (bool) {
        require(_electionId <= electionId, "Invalid election ID!");

        return _electionId == electionId && electionOn;
    }

    // Function to get the latest election Id
    function getCurrentElectionId() public view returns (uint){
        return electionId;
    }

    // Functio to get election name
    function getElectionName(uint _electionId) public view returns (string memory){
        require(_electionId <= electionId, "Invalid election ID!");

        return electionName[_electionId];
    }
}