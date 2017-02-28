pragma solidity ^0.4.8;

contract DocContract {

    
    function DocContract()
    {
        owner = msg.sender; 
        maxDocumentCount = 10000000;
    }
	
	event DocumentEvent(uint256 docId);

    function createDocument(string meta) returns (uint256)
    {
        if (documentsCount >= maxDocumentCount) throw;
        creatingDocument(meta, msg.sender);
        return documentsCount++;
    }

    function creatingDocument(string meta, address owners) internal
    {
        DocumentBase newDoc = docBase[documentsCount];
        newDoc.owner = owners;
        newDoc.meta = meta;
		
		DocumentEvent(documentsCount);
    }
    
    function createRecord(uint256 docID, string text) returns (uint256)
    {
        if (docID >= documentsCount) throw;
        
		DocumentRecords docRecord = docRecords[msg.sender];
		docRecord.records[docRecord.recordsCount] = DocumentRecord(docID, text);
        return docRecord.recordsCount++;
    }
    
    function getRecord(uint256 recordIndex) constant returns (uint256, string)
    {
		DocumentRecords docRecord = docRecords[msg.sender];
		if (recordIndex >= docRecord.recordsCount) throw;
        DocumentRecord record = docRecord.records[recordIndex];
        return (record.docId, record.text);
    }
    
    function getRecordsCount() constant returns (uint256)
    {
        return docRecords[msg.sender].recordsCount;
    }
    
    function addBlock(uint256 docID, bytes block)  returns (uint256)
    {
        if (docID >= documentsCount) throw;
        
        DocumentBase doc =  docBase[docID];
        if (doc.owner != msg.sender) throw;
            
        doc.blocks[doc.blocksCount] = block;
        return doc.blocksCount++;
    }
    
    function setDocumentOwner(uint256 docID, address newOwner) returns (bool)
    {
        if (docID >= documentsCount) return false;
        
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
        if (docID >= documentsCount) return false;
        
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

    function getBlock(uint256 docID, uint256 i) constant returns (bytes  block)
    {
        if (docID >= documentsCount) throw;

        DocumentBase doc =  docBase[docID];
        if (i >= doc.blocksCount) throw;
        
        block = doc.blocks[i];
    }

    function isDocumentClosed(uint256 docID) constant returns (bool)
    {
        if (docID >= documentsCount) return false;
        DocumentBase doc =  docBase[docID];
        if (doc.owner == 0) return true; else return false;
    }

    function getDocumentOwner(uint256 docID) constant returns (address)
    {
        if (docID >= documentsCount) return 0;
        DocumentBase doc =  docBase[docID];
        return doc.owner;
    }

    struct DocumentBase 
    {
		mapping(uint256 => bytes) blocks;
		uint256 blocksCount;
        address owner;
        string meta;
    }
	struct DocumentRecords
    {
        mapping(uint256 => DocumentRecord) records;
		uint256 recordsCount;
    }
    struct DocumentRecord 
    {
        uint256 docId;
        string text;
    }
    
    address owner;
    
    uint256 public maxDocumentCount;
    uint256 public documentsCount;
    
    mapping(uint256 => DocumentBase) public docBase;
    mapping(address => DocumentRecords) public docRecords;
}

