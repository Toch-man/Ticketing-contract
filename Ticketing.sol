// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

contract Ticketing {
     address public owner;
	
	 enum TicketStatus { 
		AVAILABLE, 
		PURCHASED,
		 USED 
        }
	
	struct Ticket {
        uint id;
        string eventName;
        uint price;
        address owner;
        bool isUsed;
        TicketStatus status;
    }
	
    Ticket[] public tickets;

  receive() external payable { 
        require (address(this).balance > 0, "");
        status = Status.PURCHASED;
    }


    mapping(uint => Ticket) public ownerId;
    mapping(address => uint[]) public ownerTicket;
    
     constructor() {
        owner = msg.sender;
    }

     modifier onlyOwner() {
        require(msg.sender == owner, "Not contract owner");
        _;
    }
    function createTicket(string memory _eventName, uint _price) public onlyOwner {
        uint ticketId = tickets.length;
        Ticket memory newTicket = Ticket({
            id: ticketId,
            eventName: _eventName,
            price: _price,
            owner: address(0),
            isUsed: false,
            status: TicketStatus.AVAILABLE
        });

        tickets.push(newTicket);
        ownerId[ticketId] = newTicket;
    }

      function buyTicket(uint _ticketId) public payable (_ticketId) {
        Ticket storage ticket = tickets[_ticketId];

        require(ticket.status == TicketStatus.AVAILABLE, "Ticket not available");
        require(msg.value == ticket.price, "Incorrect payment amount");

        ticket.owner = msg.sender;
        ticket.status = TicketStatus.PURCHASED;
        ownerId[_ticketId] = ticket;
        ownerTicket[msg.sender].push(_ticketId);
    }

    function useTicket(uint _ticketId) public  {
        Ticket storage ticket = tickets[_ticketId];

        require(ticket.status == TicketStatus.PURCHASED, "Ticket not purchased");
        require(!ticket.isUsed, "Ticket already used");

        ticket.isUsed = true;
        ticket.status = TicketStatus.USED;
        ownerId[_ticketId] = ticket;
    }

    function getMyTickets() public view returns (Ticket[] memory) {
        uint[] storage myTicketIds = ownerId[msg.sender];
        Ticket[] memory result = new Ticket[](myTicketIds.length);

        for (uint i = 0; i < myTicketIds.length; i++) {
            result[i] = tickets[myTicketIds[i]];
        }

        return result;
    }


}
   

	


