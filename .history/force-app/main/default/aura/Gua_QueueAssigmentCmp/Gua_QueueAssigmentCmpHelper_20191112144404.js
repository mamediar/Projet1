({
    initList: function(component) {
        // list of area
        // custom setting
        var listZoneRO = ['1', '2', '3', '4', '5'];
        var listZoneRE = ['6', '7', '8', '9', '10'];
        var listZoneRC = ['11', '12', '13', '14', '15'];
        var listZoneRA = ['16', '17', '18', '19', '20'];
        var listZoneRT = ['21', '22', '23', '24', '25'];
        var listZoneRS = ['26', '27', '28', '29', '30'];

        // list of unita affari
        // requete BD //
        var listAffari = [{ value: 'Q281', label: 'Affari e Delibere 1' }, { value: 'Q285', label: 'Affari e Delibere 2' },
            { value: 'Q286', label: 'Affari e Delibere 3' }, { value: 'Q287', label: 'Affari e Delibere 4' }
        ];

        component.set('v.listZoneRO', listZoneRO);
        component.set('v.listZoneRE', listZoneRE);
        component.set('v.listZoneRC', listZoneRC);
        component.set('v.listZoneRA', listZoneRA);
        component.set('v.listZoneRT', listZoneRT);
        component.set('v.listZoneRS', listZoneRS);
        component.set('v.listAffari', listAffari);
    },

    handleSetQueue: function(component) {
        var queue = component.find("unitaAffari").get("v.value");
        component.set('v.unitaAffari', queue);
    },

    handleGetZone: function(component) {
        var regione = component.find("region").get("v.value");
        console.log('region', regione);
        var attributeName = 'v.listZone' + regione;
        var listAreas = component.get(attributeName);
        var listZones = [];
        listAreas.forEach(element => {
            listZones.push({
                label: element,
                value: element
            });
        });
        var unitaAffarisSelected = component.get('v.unitaAffarisSelected');
        component.set('v.selectedAreaList', []);
        listZones.forEach(function(el, idx) {
            if (unitaAffarisSelected.indexOf(el.value) != -1) {
                listZones.splice(idx, 1);
            }
        });
        component.set('v.listZones', listZones);
    },

    showToast: function(title, type, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type": type,
            "duration": 2000,
            "message": message
        });
        toastEvent.fire();
    },
    getQueuesGroup : function(component){
        var listAffari =[];
        var listQueues ;
        var action = component.get('c.getQueues');
        action.setCallback(this, function (response) {
            if (response.getState() == 'SUCCESS') {
                var result = response.getReturnValue();
                console.log('result', JSON.stringify(result));
                if (result.error == false) {
                    listQueues =result.groupes;
                    for(var i=0; i<listQueues.length;i++){
                        listAffari.add({ value: ''+listQueues[0].DeveloperName, label: ''+listQueues[0].Name});
                    }
                    console.log('listAffari '+JSON.stringify(listAffari));
                }
            }
        });
        $A.enqueueAction(action);
    }
})