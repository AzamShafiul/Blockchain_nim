import nimSHA2
import times
var miningReward=100
type
    Transaction= object
     fromAddress:string
     toAddress:string
     amount:int             

type
    Block= object
     timestamp:string
     data:string
     previousHash:string
     transaction:seq[Transaction]
     hash:string
     nonce:int
     
        
var pendingTransaction:seq[Transaction]
var chain:seq[Block]
proc createTransaction(arguments:Transaction)=
    var obj= Transaction(fromAddress:arguments.fromAddress,toAddress:arguments.toAddress,amount:arguments.amount)
    pendingTransaction.add(obj)     
    
proc CalculateHash(arguments:Block): string {.discardable.}=
    let digest = computeSHA256(arguments.timestamp  & arguments.data & arguments.previousHash & $arguments.nonce & $arguments.transaction)
    return $digest
    
proc CreateArray(arguments:int): string =
    var arrayvalue=""
    for i in 1..arguments:
        arrayvalue.add("0")
    return arrayvalue
       
proc MineBlock(arguments: var Block): string=
         
    while arguments.hash.substr(0,1) != CreateArray(2):
        inc(arguments.nonce)
        arguments.hash=arguments.CalculateHash()
    echo "Block :",arguments.hash      
    return arguments.hash

proc MinePendingTransaction(arguments:string)=
    var time=now().utc
    var blockk=Block(timestamp:($time),transaction:pendingTransaction)
    var obj = Block(timestamp:($time),hash:blockk.MineBlock(),transaction:pendingTransaction)
    chain.add(obj)
    var trans=Transaction(toAddress:arguments,amount:miningReward)
    trans.createTransaction()
    
    
    
proc GetBalanceAddress(arguments:string): int =
            var balance=0     
            for value in chain:
                
                for val in value.transaction:
                    if val.fromAddress == arguments:
                      balance=balance - val.amount
                    if val.toAddress == arguments:
                        balance=balance + val.amount
                
            return balance          
    
var trans=Transaction(fromAddress:"address1",toAddress:"address2",amount:100)
trans.createTransaction()
trans=Transaction(fromAddress:"address2",toAddress:"address1",amount:50)
trans.createTransaction()
MinePendingTransaction("adress3")
var bal= GetBalanceAddress("adress3")
echo "address3 balance :", bal
MinePendingTransaction("adress3")
bal= GetBalanceAddress("adress3")
echo "address3 balance :", bal
    
    
    
    
            
               
               
                 
                 
    
    
    

    

    
        
    
      
    
