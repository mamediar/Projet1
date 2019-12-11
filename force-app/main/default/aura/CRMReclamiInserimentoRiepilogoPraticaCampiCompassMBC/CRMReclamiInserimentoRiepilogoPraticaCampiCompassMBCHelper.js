({
    getCodiceDealer:function(p){
        var res;
        if(p){
            if(p['puntoVendita'] && p['puntoVendita']!='0'){
                res=p['puntoVendita'];  
            }
            else if(p['convenzionato'] && p['convenzionato']!='0'){
                res=p['convenzionato'];
            }
            else if(p['subAgente'] && p['subAgente']!='0'){
                res=p['subAgente'];
            }
            else{
                res=p['agente'];
            }
        }
        return res;
    }
})