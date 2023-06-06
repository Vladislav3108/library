// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0; 
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
    

contract Library is ERC1155 {   
    constructor() ERC1155("") {
        libAdmin=msg.sender; 
    }
    address libAdmin;

    uint256 public amountBooks=0;
    uint256 public priceForMonth =  1000 gwei;
    
    mapping (uint256=> string) bookNumber;

    //..........................Admin

    
    function changeAdmin(address newAdmin) public{
        require(libAdmin==msg.sender,"ADMINS ONLY!");
        libAdmin=newAdmin;
        //Переносить токены со старого администратора к новому
        // safeTransferFrom(libAdmin, _newAdmin, amountbooks,[1,1,....,1],"")
    }

    //вывод денег

    function withdraw() public { 
        require(libAdmin==msg.sender, "Only admin"); 
        payable(libAdmin).transfer(address(this).balance); 
    }

    

    //..........................Bookwork
    function createBook(string calldata _url) public{
        require(libAdmin==msg.sender,"only admin can publish new books");
        bookNumber[amountBooks]= _url;
        //создание токена
        _mint(libAdmin, amountBooks, 1, "" );
        amountBooks++;
        //return amountBooks--;

    }

    //вывод книги по номеру

    function url(uint256 _bookId) public view returns (string memory){
        require(_bookId<amountBooks, "Not exist");
        return bookNumber [_bookId];
    }

    mapping (uint256 => address) rentedTo;
    
    //аренда книги

    function findBook(uint256 _bookId, uint256 _month) public payable{
        require (_bookId<amountBooks, "Not exist");
        require (priceForMonth*_month==msg.value, "Not enough money");
        //require(rentedTo[_bookID]==0x0000000000000000000000000000000000000000, "Already rented");
        //require(bookNumber[_bookId].availability, "Already rented");
        require(balanceOf(libAdmin, _bookId)!=0, "Already rented");
        //перевод токена 
        _setApprovalForAll(libAdmin, msg.sender, true);
        safeTransferFrom(libAdmin, msg.sender, _bookId, 1, "");
        _setApprovalForAll(libAdmin, msg.sender, false);
        rentedTo[_bookId]=msg.sender;
    }

    //поиск книги

    function whoBook(uint256 _bookId) public view returns (address){
        require (_bookId<amountBooks, "Not exist");
        return rentedTo[_bookId];
    }

    //возврат

    function returnBook(uint256 _bookId) public{
        require(msg.sender == rentedTo[_bookId],"ADMINS ONLY!");
        safeTransferFrom(msg.sender, libAdmin, _bookId, 1, "");
        delete rentedTo[_bookId];

    }
    
}
