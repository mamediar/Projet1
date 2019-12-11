({
    selectProvincia:function(cmp,provAbb){
        if (provAbb && provAbb != ''){
            console.log('RIGA 4');
            var provinciaBind = cmp.get('v.provinceBindList');
            console.log('RIGA 6:'+provinciaBind);
            var prov = (provinciaBind.find(function(temp){
                console.log('temp.Provincia__c:'+temp.Provincia__c+' '+provAbb);
                
                //return temp.Provincia__c == provAbb ; 
                if(provAbb.length==2){
                    return temp.Provincia__c == provAbb ;
                } else {
                    return temp.Provincia_Desc__c == provAbb ;
                }
            }));
            console.log('riga 9'+prov);
            cmp.set('v.provinciaSelection',prov.Provincia_Desc__c);
            console.log('PROVINCIASELECTION :::>  ' + prov.Provincia_Desc__c);
        }
    },
    
    buildComuniHelper : function (cmp,provincia) {
        console.log('buildComuniHelper')
        var comuniMap= cmp.get('v.townMap');
        console.log('comuniMap: ' + comuniMap)
        cmp.set('v.comuniList', comuniMap[provincia] );
    },
    
    selectComune : function (cmp,comune) {
        var listaComuni = cmp.get('v.comuniList');
        listaComuni.forEach(function(com){
            if(com == comune){
                console.log('CORRISPONDE!');
                cmp.set('v.comuneSelection',comune);
                return;
            }
        });
    }
})