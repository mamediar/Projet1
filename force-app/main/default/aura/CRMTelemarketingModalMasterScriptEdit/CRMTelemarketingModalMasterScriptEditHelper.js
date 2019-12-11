({
    toastMancante : function(cmp,event, message, tipo, titolo) {
        let toastEvent;
            toastEvent = $A.get("e.force:showToast")
            toastEvent.setParams({
                "type": tipo,    
                "title": titolo,
                "message": message })
                toastEvent.fire();
},
    
toastSucc : function(cmp,event){
    let toastSucc;
    toastSucc = $A.get("e.force:showToast")
    toastSucc.setParams({
            "type": "success",    
            "title": "Successo!",
            "message": "Script clonato con successo!"});
            toastSucc.fire();

    
 
}
})