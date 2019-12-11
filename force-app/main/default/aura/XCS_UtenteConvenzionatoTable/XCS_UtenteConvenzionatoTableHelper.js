({    
    setDataTable : function(cmp,data,channel) {    
        if(data.length > 0){           
            cmp.set('v.risultatiTrovati',true);            
            if(channel == 'utenze'){
                cmp.set('v.columns',cmp.get('v.columnsUtenze'));
             	cmp.set('v.titoloDataTable','Lista Intermediari');   
            }
            else if (channel == 'codiceIntermediario')
                cmp.set('v.columns',cmp.get('v.columnsIntermediario'));
        }        
        else
            cmp.set('v.risultatiTrovati',false);
    }

})