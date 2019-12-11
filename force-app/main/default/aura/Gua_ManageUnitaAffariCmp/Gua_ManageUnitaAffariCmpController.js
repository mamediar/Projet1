({
    doInit : function(component, event, helper) {
        helper.getZoneAndRegion(component, event, helper);
        helper.getQueus(component, event, helper);
    },
    handleChange : function(component, event, helper) {
        console.log('listZoneSelected ');
        var listValues = component.get('v.listvalue');
        var listZoneSelected = component.get('v.listZoneSelected');
        if(!$A.util.isEmpty(listValues)){
            listZoneSelected.push(listValues);
            listValues=null;
        }else{
           //listZoneSelected.pop(listValues); 
        }
        console.log('listZoneSelected '+listZoneSelected);
        console.log('listValues '+listValues);
    },
    methoAssegna : function(component, event, helper) {
        var listZoneSelected = component.get('v.listZoneSelected');
        console.log('listZoneSelected '+listZoneSelected);
    },
    
    methoConferma : function(component, event, helper) {
        component.set('v.openmodel',true);
    },
    
    methoCancella : function(component, event, helper) {
        var listValues = component.get('v.listvalue');
        listValues=null;
    },
    
    validForm : function(component, event, helper) {
        //add area in queues
    }
})