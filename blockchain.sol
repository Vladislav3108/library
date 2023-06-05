// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Bibliotics {
    uint256 public amountBooks=0;
    uint256 public priceForMonth =  1000 gwei;
    struct Book{
       string name;
       string picture ;
       bool availability;
    }
    mapping (uint256=> Book) bookNumber;

    //..........................Admin

    address libAdmin;
    constructor(){
        libAdmin=msg.sender;
    }

    function changeAdmin(address newAdmin) public{
        require(libAdmin==msg.sender,"ADMINS ONLY!");
        libAdmin=newAdmin;
    }

    //вывод денег

    function withdraw() public { 
        require(libAdmin==msg.sender, "Only admin"); 
        payable(libAdmin).transfer(address(this).balance); 
    }

    

    //..........................Bookwork
    function createBook(string calldata name, string calldata image) public{
        require(libAdmin==msg.sender,"only admin can publish new books");
        bookNumber[amountBooks]= Book(name,image,true);
        amountBooks++;
        //return amountBooks--;

    }

    //вывод книги по номеру

    function checkBook(uint256 _bookId) public view returns (Book memory){
        require(_bookId<amountBooks, "Not exist");
        return bookNumber [_bookId];
    }

    mapping (uint256 => address) rentedTo;
    
    //аренда книги

    function findBook(uint256 _bookId, uint256 _month) public payable{
        require (_bookId<amountBooks, "Not exist");
        require (priceForMonth*_month==msg.value, "Not enough money");
        //require(rentedTo[_bookID]==0x0000000000000000000000000000000000000000, "Already rented");
        require(bookNumber[_bookId].availability, "Already rented");
        bookNumber[_bookId].availability = false;
        rentedTo[_bookId]=msg.sender;
    }

    //поиск книги

    function whoBook(uint256 _bookId) public view returns (address){
        require (_bookId<amountBooks, "Not exist");
        return rentedTo[_bookId];
    }

    //возврат

    function returnBook(uint256 _bookId) public{
        require(libAdmin==msg.sender || msg.sender == rentedTo[_bookId],"ADMINS ONLY!");
        bookNumber[_bookId].availability = true;
        delete rentedTo[_bookId];

    }

}
