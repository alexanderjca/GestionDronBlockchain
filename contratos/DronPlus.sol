pragma solidity ^0.4.10;

import 'browser/IERC20.sol';

contract DronPlus is IERC20 {
    uint256 public _totalSupply;
    uint256 public _countDrones;
    
    struct Dron{
        uint256 idDron;
       
        uint256 altMin;
        uint256 altMax;
        uint256 longVuelo;
        uint256 idParcela;
        uint256 price;
        uint256 available;
        address owner;
        string pesticida;
        uint256 idParcelaDestino;
    }
    
    address adCoinPlus;
    address adParcelas;
    
    mapping (uint256 => Dron) public listDrones;
    mapping (uint256 => Dron) public listDronesRequested;
    
    constructor (uint256 totalSupply){
        _totalSupply = totalSupply; 
        _countDrones = 0;
    }
    
    function setCoinPlus(address _address) public {
        adCoinPlus = _address;
    }
    
    bool public ok;
 
    function requestDron(address addr,uint256 p1){
         ParcelaPlus parcela = ParcelaPlus(addr);
         ok = parcela.validaDron(p1);
    }
    
    event DronRequested(uint256 idDron, bool isValidate);
    
    function solicitaDron(address addr,
                        uint256 _idDron,
                        uint256 _altMin,
                        uint256 _altMax,
                        uint256 _longVuelo,
                        uint256 _idParcelaOrigen,
                        uint256 _idParcelaDestino,
                        string _pesticida) public constant returns (bool){
        
        bool isOK;
        
        ParcelaPlus parcela = ParcelaPlus(addr);
        isOK=parcela.validateDron(_altMin,_altMax,_longVuelo,_idParcelaOrigen,_idParcelaDestino,_pesticida);
        ok=isOK;
        
        listDronesRequested[_idDron].idDron = _idDron;
        listDronesRequested[_idDron].idParcela = _idParcelaOrigen;
        listDronesRequested[_idDron].idParcelaDestino = _idParcelaDestino;
       
        
        emit DronRequested(_idDron, isOK);
        return ok;
    }
    
    function getTotalSupply() public returns(bool){
        return adCoinPlus.call(bytes4(keccak256("totalSupply()")));
    }
    
 
    event DronCreated(address indexed from, uint256 idDron);
    
    //Devuelve el número total de drones 
    function totalSupply() public view returns (uint256){
        return _totalSupply;
    }

    //Devuelve el número de drones registrados
    function balanceOf(address who) external view returns (uint256){
        return _countDrones;
    }
    
   
    function allowance(address owner, address spender) external view returns (uint256){
        
    }

    function transfer(address to, uint256 value) external returns (bool){
        
    }

    function approve(address spender, uint256 value) external returns (bool){
        
    }

    function transferFrom(address from, address to, uint256 value) external returns (bool){
        
    }
    
    function createDron(uint256 _altMin,
                        uint256 _altMax,
                        uint256 _longVuelo,
                        uint256 _idParcela,
                        uint256 _price,
                        string _pesticida) public returns (uint id){
       
        ++_countDrones;
        listDrones[_countDrones].idDron = _countDrones;
        listDrones[_countDrones].altMin = _altMin;
        listDrones[_countDrones].altMax = _altMax;
        listDrones[_countDrones].longVuelo = _longVuelo;
        listDrones[_countDrones].idParcela = 1;
        listDrones[_countDrones].price = _price;
        listDrones[_countDrones].available = 1; //1 dron available, 0 dron no available
        listDrones[_countDrones].owner = msg.sender;
        listDrones[_countDrones].pesticida=_pesticida;
        
      
        emit DronCreated(msg.sender, _countDrones);
        
        return _countDrones;
    }
    
    //Asigna el dron a una parcela y lo pone el estado respectivo 1: disponible, 0: no disponible
    function allocateDron(address _owner, uint256 _idDron, uint256 _idParcelaDestino)  public returns (uint id){
        require(_owner==listDrones[_idDron].owner,"The address is not the owner");
        delete listDronesRequested[_idDron];
        listDrones[_idDron].available=0;
        listDrones[_idDron].idParcela=_idParcelaDestino;
        
    }
    
    function releaseDron(address _owner, uint256 _idDron)  public returns (uint id){
        require(_owner==listDrones[_idDron].owner,"The address is not the owner");
        listDrones[_idDron].available=1;
        
    }
    
    function getDrone(uint256 _idDron) public
                        constant returns(uint256,
                        uint256,uint256,uint256,uint256,uint256,string){
        
        return (listDrones[_idDron].altMax,listDrones[_idDron].altMin,
                listDrones[_idDron].longVuelo,listDrones[_idDron].idParcela,
                listDrones[_idDron].price,listDrones[_idDron].available,
                listDrones[_idDron].pesticida);
    }
    
    function getDroneRequested(uint256 _idDron) public
                        constant returns(uint256,uint256){
        
        return (listDronesRequested[_idDron].idParcela,listDronesRequested[_idDron].idParcelaDestino);
    }
}

contract ParcelaPlus{
     function validaDron(uint256 p) returns (bool);
     function validateDron(uint256 _altMin,
                        uint256 _altMax,
                        uint256 _longVuelo,
                        uint256 _idParcelaOrigen,
                        uint256 _idParcelaDestino,
                        string _pesticida) returns (bool);
}

