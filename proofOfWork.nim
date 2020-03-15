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
     nonce:int
         
proc CalculateHash(arguments:Block): string {.discardable.}=
    let digest = computeSHA256($arguments.ind & arguments.timestamp  & arguments.data & arguments.previousHash & $arguments.nonce)
    return $digest
    
proc GenesisBlock(arguments: var Block) :string {.discardable.}=
    
    arguments.hash=arguments.CalculateHash()
    let jsonObject= %*{"ind": arguments.ind, "timestamp":arguments.timestamp,"data":arguments.data,"previousHash": arguments.previousHash,"hash": arguments.hash}
    chain.add($jsonObject)
proc CreateArray(arguments:int): string =
    
    var arrayvalue=""
    for i in 1..arguments:
        arrayvalue.add("0")
        
    return arrayvalue
proc MineBlock(arguments: var Block): string=
     
     while arguments.hash.substr(0,1) != CreateArray(2):
        inc(arguments.nonce)
        arguments.hash=arguments.CalculateHash()
     echo "How many computes needed to mine block? :", arguments.nonce  
     return arguments.hash
    
proc AddBlock(arguments: var Block) :string {.discardable.}=
    
    let hash=parseJson(chain[chain.len-1])["hash"].getStr()
    arguments.previousHash=hash
    echo "Block is mining...."
    arguments.hash=arguments.MineBlock()
    let jsonObject= %*{"ind": arguments.ind, "timestamp":arguments.timestamp,"data":arguments.data,"previousHash": arguments.previousHash,"hash": arguments.hash}
    chain.add($jsonObject)
    echo parseJson($jsonObject)      



var blc=Block(ind:0,timestamp:"12/7/2010 @ 5:26pm (UTC)",data:"amount:10",previousHash:"0")
blc.GenesisBlock()
blc=Block(ind:1,timestamp:"8/10/2020 @ 1:20pm (UTC)",data:"amount:120")
echo blc.AddBlock()
blc=Block(ind:2,timestamp:"03/1/2020 @ 8:49pm (UTC)",data:"amount:100")
echo blc.AddBlock()
proc BlockChainValidity():bool=
    for index in 1..chain.len-1:
        let currentBlock=parseJson(chain[index])
        let prevBlock=parseJson(chain[index-1])
        #echo currentBlock
        var blocks=Block(ind:currentBlock["ind"].getInt(),timestamp:currentBlock["timestamp"].getStr(),data:currentBlock["data"].getStr(),previousHash: currentBlock["previousHash"].getStr())
        if (currentBlock["hash"].getStr() != blocks.MineBlock()):
           return false
        if (currentBlock["previousHash"].getStr() !=  prevBlock["hash"].getStr()):
            return false
    return true  

echo "Block Chain Validity :"     
echo BlockChainValidity()   
let abc=parseJson(chain[1])
let jsonObject= %*{"ind": abc["ind"], "timestamp":abc["timestamp"],"data":"100$ is transferred","previousHash": abc["previousHash"],"hash": abc["hash"]}
chain[1]=($jsonObject)
echo "Block Chain Validity After Changing Data :"
echo BlockChainValidity() 

