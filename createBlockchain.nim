import nimSHA2
import json
var chain:seq[string]


type
    Block= object
     ind:int
     timestamp:string
     data:string
     previousHash:string
     hash:string

         
proc CalculateHash(arguments:Block): string {.discardable.}=
    let digest = computeSHA256($arguments.ind & arguments.timestamp  & arguments.data & arguments.previousHash)
    return $digest
    
proc GenesisBlock(arguments: var Block) :string {.discardable.}=
    
    arguments.hash=arguments.CalculateHash()
    let jsonObject= %*{"ind": arguments.ind, "timestamp":arguments.timestamp,"data":arguments.data,"previousHash": arguments.previousHash,"hash": arguments.hash}
    chain.add($jsonObject)
    
    
proc AddBlock(arguments: var Block) :string {.discardable.}=
    
    let hash=parseJson(chain[chain.len-1])["hash"].getStr()
    arguments.previousHash=hash
    arguments.hash=arguments.CalculateHash()
    let jsonObject= %*{"ind": arguments.ind, "timestamp":arguments.timestamp,"data":arguments.data,"previousHash": arguments.previousHash,"hash": arguments.hash}
    chain.add($jsonObject)
           



var blc=Block(ind:0,timestamp:"12/7/2010 @ 5:26pm (UTC)",data:"amount:10",previousHash:"0")
blc.GenesisBlock()
blc=Block(ind:1,timestamp:"8/10/2020 @ 1:20pm (UTC)",data:"amount:120")
blc.AddBlock()
blc=Block(ind:2,timestamp:"03/1/2020 @ 8:49pm (UTC)",data:"amount:100")
blc.AddBlock()

proc BlockChainValidity():bool=
    for index in 1..chain.len-1:
        let currentBlock=parseJson(chain[index])
        let prevBlock=parseJson(chain[index-1])
        #echo currentBlock
        let blocks=Block(ind:currentBlock["ind"].getInt(),timestamp:currentBlock["timestamp"].getStr(),data:currentBlock["data"].getStr(),previousHash: currentBlock["previousHash"].getStr())
        if (currentBlock["hash"].getStr() != blocks.CalculateHash()):
           return false
        if (currentBlock["previousHash"].getStr() !=  prevBlock["hash"].getStr()):
            return false
    return true  
echo "BlockChains :"   
echo chain
echo "Block Chain Validity :"     
echo BlockChainValidity()   
let abc=parseJson(chain[1])
let jsonObject= %*{"ind": abc["ind"], "timestamp":abc["timestamp"],"data":"z","previousHash": abc["previousHash"],"hash": abc["hash"]}
chain[1]=($jsonObject)
echo "Block Chain Validity After Changing Data :"
echo BlockChainValidity()   


