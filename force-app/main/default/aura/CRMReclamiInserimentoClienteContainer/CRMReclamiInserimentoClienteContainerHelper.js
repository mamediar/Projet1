({
    navigate:function(cmp,isNotEmpty){
        if(isNotEmpty){
            if(
                cmp.get('v.aziendaSelezionata')!='MBCredit Solutions' &&
                !cmp.get('v.isSconosciuto')
            ){
                cmp.set('v.stepInserimentoCliente',(cmp.get('v.stepInserimentoCliente')+1));

            }
            else{
                cmp.set('v.stepInserimentoCliente',4);

            }
        }
    },
    
    alert : function(cmp) {
        cmp.find('notifLib').showNotice({
            "variant":"error",
            "header":"Attenzione!",
            "message":"Cliente non trovato"
        });
    },

    alert2 : function(cmp) {
        cmp.find('notifLib').showNotice({
            "variant":"error",
            "header":"Attenzione!",
            "message":"Compilare il form"
        });
    }
})