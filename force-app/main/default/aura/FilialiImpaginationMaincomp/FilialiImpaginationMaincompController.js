({
   doInit: function(component, event, helper) {
        $A.createComponent(
            "c:FilialiImpaginazioneComp", {
                
            },
            function(newCmp) {
                if (component.isValid()) {
                    component.set("v.body", newCmp);
                }
            }
        );
    },
    navigateToIntervistaPaginazioneCmp: function (component, event, helper) {   
        var loadData=event.getParam('loadData');
        var data=event.getParam('datafilialList');
       // alert(data.length);
       $A.createComponent(
           "c:IntervistaImpaginazione", {
               'loadData': loadData,
               'objectList': data
           },
           function(newCmp) {
               if (component.isValid()) {
                   component.set("v.body", newCmp);
               }
           }
       );
   },
       navigateToIntervistaCompPratiche: function (component, event, helper) {
           var codeFiliale=event.getParam('Id');
          // alert(data.length);
           var loadData=event.getParam('loadData');
           var data=event.getParam('datafilialList');
           console.log('/////codeFiliale'+codeFiliale);
          $A.createComponent(
              "c:IntervistaImpaginazione", { 
                  'Id': codeFiliale,
                  'loadData': loadData,
                  'objectList': data
              },
              function(newCmp) {
                  if (component.isValid()) {
                      component.set("v.body", newCmp);
                  }
              }
          );
      },
   navigateToIntervistaComp: function(component, event, helper) {
        var data = event.getParam('data');
        component.set("v.dataList",data);
       try{
       
                    var idintervista=event.getParam('Id');
                    console.log('idintervista'+idintervista);
                     $A.createComponent(
                         "c:IntervistaComp", {
                            'Id':idintervista,
                            'dataList': component.get('v.dataList'),
                            },
                         function(newCmp) {
                             if (component.isValid()) {
                                 component.set("v.body", newCmp);
                             }
                         }
                     );
          }catch( Err )
          {
              console.log('Err(((()))))->'+Err);
          }
   },
   navigateToIntervistaDomandeComp: function(component, event, helper) {
            $A.createComponent(
                "c:IntervistaDomandeComp", {
                   },
                function(newCmp) {
                    if (component.isValid()) {
                        component.set("v.body", newCmp);
                    }
                }
            );
   },
   navigateToApputamentoTelephonico: function(component, event, helper) {
               $A.createComponent(
                   "c:ApputamentoTelephonico", {
                      },
                   function(newCmp) {
                       if (component.isValid()) {
                           component.set("v.body", newCmp);
                       }
                   }
               );
   },
   navigationAssicurativo: function(component, event, helper) {
           console.log('---2---');
           var idinterv=event.getParam('Id');
            $A.createComponent(
                "c:AssicurativoDetail", {
                   'Id':idinterv
                   },
                function(newCmp) {
                    if (component.isValid()) {
                        component.set("v.body", newCmp);
                    }
                }
            );
   },
})