({
    setOptions : function(cmp) {     
        cmp.set('v.reclamiColumns', [
            {label: 'Numero Reclamo', fieldName: 'Numero_Reclamo__c', type: 'Text'},   
            {label: 'Numero Case', fieldName: 'CaseNumber', type: 'Text'},
            {label: 'Categoria', fieldName: 'Motivo__c', type: 'Text'},
            {label: 'Numero Pratica', fieldName: 'NumeroPratica__c', type: 'Text'},          
            {label: 'Data Creazione', fieldName: 'CreatedDate', type: 'Text'},
            {label: 'Coda', fieldName: 'Subject', type: 'Text'},
            {label: 'Stato', fieldName: 'Status', type: 'Text'}
        ]);               
    },
      
    loadData : function(cmp){
        var action = cmp.get('c.doInit');
        action.setParam('recordId',cmp.get('v.recordId'));
        action.setCallback(this, function(response) {            
            if(response.getState() == 'SUCCESS') {  
                
                var records = response.getReturnValue();
                if(records.length>0){
                    for (var i = 0; i < records.length; i++) {
                        var row = records[i];
                        var d = new Date(row.CreatedDate),
                        dformat = this.formatDate(d);
                        row.CreatedDate = dformat;
                    }
                }
                cmp.set('v.reclamiData', records);
                //cmp.set('v.reclamiData', action.getReturnValue());

            }
        });       
        $A.enqueueAction(action);               
    },
    
     setToast : function(cmp,event,helper){
        var toast = $A.get('e.force:showToast');
        toast.setParams({
            title : 'Sei già sul reclamo selezionato',
            type : 'warning',
            message : ' '
        });
        toast.fire();        
    },
    formatDate: function (date) {
        var hours = date.getHours();
        var minutes = date.getMinutes();
        var seconds = date.getSeconds();
        //var ampm = hours >= 12 ? 'pm' : 'am';
        //hours = hours % 12;
        hours = hours ? hours : 12; // the hour '0' should be '12'
        hours = hours < 10 ? '0'+hours : hours;
        minutes = minutes < 10 ? '0'+minutes : minutes;
        seconds = seconds < 10 ? '0'+seconds : seconds;
        var day = date.getDate()< 10 ? '0'+date.getDate() : date.getDate();
        var month = (date.getMonth()+1)<10 ? '0'+(date.getMonth()+1) : date.getMonth()+1;
        
        var strTime = hours + ':' + minutes + ':' + seconds + ' ';
        return day + "/" + month + "/" + date.getFullYear() + "  " + strTime;
    }
        
})