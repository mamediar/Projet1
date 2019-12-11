({
    loadProvince : function (cmp,event,helper) {
        var action = cmp.get('c.groupProvince');
        action.setCallback(this,function(response){
            var state = response.getState();
            console.log('**********STATE = ' + state );
            if(state === 'SUCCESS') {
                var provinciaBinding = (response.getReturnValue().townList);
                console.log('**********SUCCESS');
                if(cmp.get('v.groupByProvinciaAbbreviata')) {
                    console.log('DENTRO IF 1' );
                    var mappaTot = response.getReturnValue().mapProvince;
                    var keysProvinceAbbreviate = Object.keys(mappaTot).sort();
                    console.log('DENTRO IF' );
                    keysProvinceAbbreviate.forEach
                    (
                        function(key) 
                        {
                            var newkey = (response.getReturnValue().townList.find
                                          (
                                              function(temp)
                                              {
                                                  return temp.Provincia_Desc__c == key;
                                              }).Provincia__c
                                         );
                            if(newkey)
                                mappaTot[newkey] = mappaTot[key];
                            delete mappaTot[key];
                        }
                    );
                    
                    cmp.set('v.provinceBindList', provinciaBinding);
                    cmp.set('v.provinceList',Object.keys(mappaTot).sort());
                    cmp.set('v.townMap',mappaTot);
                }
                else {
                    console.log('DENTRO ELSE' );
                    var mappaTot = response.getReturnValue().mapProvince;
                    var keysProvince = (Object.keys(mappaTot)).sort();
                    cmp.set('v.provinceBindList', provinciaBinding);
                    cmp.set('v.provinceList', keysProvince);
                    cmp.set('v.townMap',mappaTot);
                }
                
                if(cmp.get('v.provincia') != null && cmp.get('v.provincia') != '' && cmp.get('v.provincia') != undefined) {
                    // seleziona provincia
                    console.log('RIGA 46' );
                    helper.selectProvincia(cmp,cmp.get('v.provincia'));
                    console.log('RIGA 49' );
                    helper.buildComuniHelper(cmp,cmp.get('v.provinciaSelection'));
                    console.log('RIGA 51' );
                }
                else {
                    if(cmp.get('v.comune') != null && cmp.get('v.comune') != '' && cmp.get('v.comune') != undefined ) {
                        console.log('RIGA 52' );
                        //seleziona comune
                        cmp.set('v.comuneSelection',cmp.get('v.comune'));
                        helper.selectComune(cmp,cmp.get('v.comuneSelection'));
                    }
                }       
            }
        });
        $A.enqueueAction(action);
    },
    
    buildComuniBySelection : function(cmp,event,helper) {
        console.log('buildCOmuniBySELECTION START');
        console.log( ' provincia: ' + cmp.get('v.provinciaSelection') )
        if (cmp.get('v.provinciaSelection') != null && cmp.get('v.provinciaSelection') != '' &&  cmp.get('v.provinciaSelection') != undefined) {
            helper.buildComuniHelper(cmp,cmp.get('v.provinciaSelection'));
            helper.selectProvincia(cmp,cmp.get('v.provincia'));
            // cmp.set('v.comuneSelection',cmp.get('v.comune'));
            // helper.selectComune(cmp,cmp.get('v.comuneSelection'));
            console.log('COMUNE SELECTION IN BUILD COMUNIBYSELECTION:::::::>' + cmp.get('v.comuneSelection'));
            console.log('COMUNILIST IN BUILDCOMUNIMYSELECTION:::::::> ' + cmp.get('v.comuniList'));
        } 
        
    },
    
    buildComuniByExternalService : function(cmp,event,helper) {
        console.log('buildComuniByExternalService START');
        if (cmp.get('v.provincia') != null && cmp.get('v.provincia') != '' &&  cmp.get('v.provincia') != undefined) {
            helper.selectProvincia(cmp,cmp.get('v.provincia'));
            helper.buildComuniHelper(cmp,cmp.get('v.provinciaSelection'));
            cmp.set('v.comuneSelection',cmp.get('v.comune'));
            // helper.selectComune(cmp,cmp.get('v.comuneSelection'));
            console.log('COMUNE SELECTION IN buildcomuniByOCS:::::::>' + cmp.get('v.comuneSelection'));
            console.log('COMUNILIST IN buildcomuniByOCS:::::::> ' + cmp.get('v.comuniList'));
        } 
    },
    
    setComuneByExternalService:function(cmp,event,helper){
        console.log(' partito setComuneByExternalService ');
        cmp.set('v.comuneSelection',cmp.get('v.comune'));
        var selectedComuneValue = event.getParam('comuneSelection');
        helper.selectComune(cmp,selectedComuneValue);
    }
    
})