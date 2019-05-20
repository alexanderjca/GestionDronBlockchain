pragma solidity ^0.4.10;

import 'browser/IERC20.sol';

contract ParcelaPlus is IERC20 {
    uint256 public _totalSupply;
    uint256 public _countParcela;
    
     struct Parcela{
        uint256 idParcela;
        uint256 altMin;
        uint256 altMax;
        uint256 longParcela;
        address owner;
        string pesticida;
    }
    
    mapping (uint256 => Parcela) public listParcelas;
     
    constructor (uint256 totalSupply){
        _totalSupply = totalSupply; 
        _countParcela = 0;
    }
    
    //Devuelve el número total de drones 
    function totalSupply() external view returns (uint256){
        return _totalSupply;
    }

    //Devuelve el número de drones disponibles
    function balanceOf(address who) external view returns (uint256){
        return _totalSupply - _countParcela;
    }

    function allowance(address owner, address spender) external view returns (uint256){
        
    }

    function transfer(address to, uint256 value) external returns (bool){
        
    }

    function approve(address spender, uint256 value) external returns (bool){
        
    }

    function transferFrom(address from, address to, uint256 value) external returns (bool){
        
    }
    
    event ParcelaCreada(uint256 indexed idParcela, address indexed sender);
    
    function createParcela(uint256 _altMin,
                        uint256 _altMax,
                        uint256 _longParcela,
                        string _pesticida) public returns (uint id){
       
        ++_countParcela;
        listParcelas[_countParcela].idParcela = _countParcela;
        listParcelas[_countParcela].altMin = _altMin;
        listParcelas[_countParcela].altMax = _altMax;
        listParcelas[_countParcela].longParcela = _longParcela;
        listParcelas[_countParcela].owner = msg.sender;
        listParcelas[_countParcela].pesticida=_pesticida;
        
        emit ParcelaCreada(_countParcela, msg.sender);

        return _countParcela;
    }
    
    bool public ok;
   
    function validaPesticida(string pesticidaDron, string pesticidaParcela) returns (bool){
        bytes memory bpdron;
        bytes memory bpparcela;
        
        bpdron = bytes (pesticidaDron);
        bpparcela = bytes (pesticidaParcela);
       
        for (uint i=0;i<5;i++){
            if (bpparcela[i]==1 && bpdron[i]==bpparcela[i]){
                return true;
            }
        }
        return false;
    }
    
    function validateDron(uint256 _altMin,
                        uint256 _altMax,
                        uint256 _longVuelo,
                        uint256 _idParcelaOrigen,
                        uint256 _idParcelaDestino,
                        string _pesticida) returns (bool){
        
        require(_idParcelaOrigen<=_countParcela && _idParcelaDestino<=_countParcela, "La parcela origen o destino no ha sido creada");
        //require(msg.sender==listParcelas[_idParcelaDestino].owner, "El dueño de la parcela no esta solicitando el servicio");
        //require(validaPesticida(_pesticida,listParcelas[_idParcelaDestino].pesticida),"El pesticida seleccionado no corresponde con el pesticida del dron");
        
     
        uint256 acumulaLong;
        
        ok=false;
        
        if (_idParcelaDestino>_idParcelaOrigen) {
            for (uint i=_idParcelaOrigen; i<_idParcelaDestino; i++){
                require(_altMin>=listParcelas[_idParcelaDestino].altMin,"La altura minima de vuelo del dron no es soportada para llegar a la parcela");
                require(_altMax<=listParcelas[_idParcelaDestino].altMax,"La altura maxima de vuelo del dron no es soportada para llegar a la parcela");

                acumulaLong = acumulaLong + listParcelas[i].longParcela;
            }
        } else {
            for (uint j=_idParcelaOrigen; j>_idParcelaDestino; j--){
                require(_altMin>=listParcelas[_idParcelaDestino].altMin,"La altura minima de vuelo del dron no es soportada por la parcela");
                require(_altMax<=listParcelas[_idParcelaDestino].altMax,"La altura maxima de vuelo del dron no es soportada para llegar a la parcela");

                acumulaLong = acumulaLong + listParcelas[j].longParcela;
            }
        }
        
        require(_longVuelo>=acumulaLong, "La longitud de vuelo del dron no soporta llegar hasta la parcela destino");
        
        ok = true;
        return true;
                            
    }
    
    function getParcela(uint256 _idParcela) public
                        constant returns(uint256,
                        uint256,uint256,uint256,string){
        
        return (listParcelas[_idParcela].idParcela,listParcelas[_idParcela].altMin,
                listParcelas[_idParcela].altMax,listParcelas[_idParcela].longParcela,
                listParcelas[_idParcela].pesticida);
    }
}