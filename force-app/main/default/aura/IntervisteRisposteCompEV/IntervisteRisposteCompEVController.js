({
    
    
    
    
    init: function( component , event , helper )
    {
        var Risposta = component.get('v.risposta');
        console.log('------28_03_2019-------');
        console.log(Risposta);
        
        
        
        
    },
/*
/**
* @description: method go back to list Pratiche
* @date::18/03/2019
* @author:Salimata NGOM
* @params: component, event, helper
* @return: false
* @modification:
*/
    redirect: function (component, event, helper){
        var eventGoFiliali=$A.get("e.c:eventGetIntervista");
                      eventGoFiliali.fire();
    },


/*
/**
* @description: method for call modifica Domanda
* @date::19/03/2019
* @author:Salimata NGOM
* @params: component, event, helper
* @return: false
* @modification:
*/
        modificaDomanda: function (component, event, helper){

            var eventGoModificaDomanda=$A.get("e.c:eventNavigateToModificaDomanda");
            eventGoModificaDomanda.setParam('rispostaObject',component.get('v.risposta'));
            eventGoModificaDomanda.fire();
             console.log('set risposta',component.get('v.risposta'));
        },

})