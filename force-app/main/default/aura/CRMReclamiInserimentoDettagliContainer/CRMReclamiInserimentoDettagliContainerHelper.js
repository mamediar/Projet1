({
    checkIfOkHelper:function(cmp){
        var res=true;
        var msg='';
        var attrMap={'contattoPrecedente':'Contatto Precedente','codaSelezionata':'Coda',
                     'isHeaderOk':cmp.get('v.headerMessage'),'isRadioOk':cmp.get('v.radioMessage')};
        if(cmp.get('v.isAssicurazione')){
            attrMap['isAggiuntiviOk']=cmp.get('v.aggiuntiviMessage');
        }
        Object.keys(attrMap).forEach(function(temp){
            if(!cmp.get('v.'+temp)){
                res=false;
                msg+=attrMap[temp]+', ';
            }
        });
        cmp.set('v.errorMessage',msg!=''?msg.substring(0,msg.length-2):'');
        return res;
    },
    
    buildOutputObj:function(cmp){
        var res={};
        var resInad = {};
        cmp.set('v.sezInadempimentoOutput', resInad['filiale'] = cmp.get('v.filiale') ?  cmp.get('v.filiale') : '' );
        var attrList=['headerOutput','radioOutput','attribuzioneReclamo','codaSelezionata',
                      'contattoPrecedente','aggiuntiviOutput','sezInadempimentoOutput', 'codaSelezionata'];
        attrList.forEach(function(temp){
            res[temp]=cmp.get('v.'+temp);
        });
        
        
        
        return res;
    }
})