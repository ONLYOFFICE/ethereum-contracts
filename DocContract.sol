pragma solidity ^0.4.8;

contract DocContract2 {

    
    function DocContract2()
    {
        owner = msg.sender; 
        maxDocumentCount = 10000000;
    }
    

    event DocumentEvent(uint blockNumber, bytes32 indexed hash, address indexed from, address indexed to);
    

    function createDocument(string Text) returns (uint256)
    {
        if (documentID > maxDocumentCount) return 0;
        creatingDocument(Text, msg.sender);
        return documentID;
    }

    
    function creatingDocument(string Text, address owners) internal
    {
        
        ++blockID;
        docBlock[blockID] = DocumentBlock(Text);

        uint256[] memory blocks = new uint256[](1);
        blocks[0] = blockID;

        ++documentID;
        docBase[documentID] = DocumentBase(blocks, owners);
    }
    
    function copyDocument(uint256 docID) returns (uint256)
    {
        if (documentID > maxDocumentCount) return 0;
        copyingDocument(docID, msg.sender);
        return documentID;
    }
    
    function copyingDocument(uint256 docID, address owners) internal
    {
        DocumentBase doc =  docBase[docID];
        uint256[] memory blocks = doc.blocks;

        ++documentID;
        docBase[documentID] = DocumentBase(blocks, owners);
    }
    


    function createRecord(uint256 docID, string Text) returns (uint256)
    {
        if (documentID > maxDocumentCount) return 0;
        if (docID > documentID) return 0;
        
        creatingRecord(docID, Text);
        return documentID;
    }
    
    function creatingRecord(uint256 docID, string Text) internal
    {
        ++blockID;
        docBlock[blockID] = DocumentBlock(Text);

        DocumentBase doc =  docBase[docID];
        uint256[] memory blocks = new uint256[](doc.blocks.length + 1);
        for(uint i = 0; i <doc.blocks.length; i++) blocks[i] = doc.blocks[i];
        blocks[doc.blocks.length] = blockID;

        ++documentID;
        docBase[documentID] = DocumentBase(blocks, 0);
        
    }
    
    

    function addText(uint256 docID, string Text)  returns (uint256)
    {
        if (docID > documentID) return 0;
        
        DocumentBase doc =  docBase[docID];
        if (doc.owner != msg.sender) return 0;
            
        addingText(Text, docID);
        return blockID;
    }
    

    function addingText(string Text, uint256 docID)  internal
    {
        ++blockID;
        docBlock[blockID] = DocumentBlock(Text);
        
        DocumentBase doc =  docBase[docID];
        doc.blocks.push(blockID);
    }


    function setDocumentOwner(uint256 docID, address newOwner) returns (bool)
    {
        if (docID > documentID) return false;
        
        DocumentBase doc =  docBase[docID];
        if (doc.owner != msg.sender) return false;
        
        settingDocumentOwner(docID, newOwner);
        return true;
    }

    function settingDocumentOwner(uint256 docID, address newOwner)  internal
    {
        DocumentBase doc =  docBase[docID];
        doc.owner = newOwner;
    }

    
    function closeDocument(uint256 docID) returns (bool)
    {
        if (docID > documentID) return false;
        
        DocumentBase doc =  docBase[docID];
        if (doc.owner != msg.sender) return false;

        settingDocumentOwner(docID, 0);
        return true;
    }
    


    function setMaxDocumentCount(uint256 newCount) returns (bool)
    {
        if (owner != msg.sender) return false;
        settingMaxDocumentCount(newCount);
        return true;
    }

    function settingMaxDocumentCount(uint256 newCount)  internal
    {
        maxDocumentCount = newCount;
    }


    function getText(uint256 docID, uint256 i) constant returns (string  strText)
    {
        strText  = "";

        if (docID > documentID) return;

        DocumentBase doc =  docBase[docID];
        if (i >= doc.blocks.length) return;
        
        uint256 nBlock = doc.blocks[i];
        
        DocumentBlock block = docBlock[nBlock];

        strText  = block.blockText;
    }


    function isDocumentClosed(uint256 docID) constant returns (bool)
    {
        if (docID > documentID) return false;
        DocumentBase doc =  docBase[docID];
        if (doc.owner == 0) return true; else return false;
    }

    function getDocumentOwner(uint256 docID) constant returns (address)
    {
        if (docID > documentID) return 0;
        DocumentBase doc =  docBase[docID];
        return doc.owner;
    }


    function getMaxDocumentCount() constant returns (uint256)
    {
        return maxDocumentCount;
    }


    function getLatestDocumentID() constant returns (uint256 latest)
    {
        return documentID;
    }
    
    function getLatestBlockID() constant returns (uint256 latest)
    {
        return blockID;
    }

    
    struct DocumentBase 
    {
        uint256[] blocks;
        address owner;
    }
    
    struct DocumentBlock 
    {
        string  blockText;
    }
    

    address owner;
    
    uint256 maxDocumentCount;

    uint256 documentID;
    uint256 blockID;
    
    mapping(uint256 => DocumentBase) public docBase;
    mapping(uint256 => DocumentBlock) public docBlock;

}
