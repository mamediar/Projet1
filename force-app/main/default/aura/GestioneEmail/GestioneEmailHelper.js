({
    setOptions : function(cmp) {
        this.setDataTable(cmp);
        cmp.set('v.typeOptions', [
            {label:'Mail', value:'Email'},
            {label:'Fax', value:'Fax'}
        ]);
        cmp.set('v.suppressBottomBar', true	);
    },
    
    setDataTable : function(cmp){
        cmp.set('v.configEmailFaxColumns', [
            {label: 'Tipo', fieldName: 'Type__c', type: 'Text', initialWidth:150},           
            {label: 'Casella Email', fieldName: 'MailBox__c', type: 'Text'},
            this.emailOrFax(cmp),            
            {label: 'Nome coda', fieldName: 'DeveloperName__c', type: 'Text'},
            {label: 'Percentuale', fieldName: 'Balancing__c', type: 'number', cellAttributes: { alignment: 'left' }, editable: true}
        ]);    
        console.log(cmp.get('v.suppressBottomBar'));
    },
    
    emailOrFax : function(cmp){
        if(cmp.get('v.typeValue') == 'Email'){
            return {label: 'Email per risposta', fieldName: 'Email_per_risposta__c', type: 'Text'}               
        }else
            return {label: 'Coda di Recall', fieldName: 'Recall_Queue__c', type: 'Text'}                   
            },
    
    compare : function(a, b) {
        let comparison = 0;
        const ADDRESS_A = a.MailBox__c.toUpperCase();
        const ADDRESS_B = b.MailBox__c.toUpperCase();        
        
        if (ADDRESS_A > ADDRESS_B) comparison = 1;
        else if (ADDRESS_A < ADDRESS_B) comparison = -1;
        
        return comparison;
    },
    
    loadData : function(cmp){
        var dataUpdated = [];
        var typeValue = cmp.find('type').get('v.value');
        var action = cmp.get('c.doInit');
        action.setCallback(this, function(response) {            
            if(response.getState() == 'SUCCESS') {                
                var result = action.getReturnValue(); 
                result.sort(this.compare);
                cmp.set('v.configEmailFaxDataStatic', result);
                cmp.set('v.configEmailFaxData', this.filterType(cmp));
                console.log(result);               
            }
        });       
        $A.enqueueAction(action);               
    },
    
    filterType : function(cmp){
        var dataUpdated = [];  
        var data = cmp.get('v.configEmailFaxDataStatic');
        var typeValue = cmp.find('type').get('v.value');
        data.forEach(function(elem){
            if(elem.Type__c.toLowerCase() == typeValue.toLowerCase()) dataUpdated.push(elem);                            
        });       
        return dataUpdated;
    },
    
    search : function(cmp, currentList){
        var dataUpdated = [];
        var searchInput = cmp.find('searchInput').get('v.value');
        searchInput = !searchInput ? '' : searchInput;
        currentList.forEach(function(elem){
            if(elem.MailBox__c.toLowerCase().indexOf(searchInput.toLowerCase()) > -1) dataUpdated.push(elem);            
        });  
        return dataUpdated;
    },
    
    rotate : function(element){
        var deg = element.style.getPropertyValue('transform');
        deg = !deg ? 'rotate(0deg)' : deg;
        deg = deg.substring(deg.lastIndexOf('(') + 1 , deg.lastIndexOf('deg')); 
        deg = parseInt(deg) + 360;
        element.style.setProperty('transform', 'rotate(' + deg + 'deg)');
    }    
})