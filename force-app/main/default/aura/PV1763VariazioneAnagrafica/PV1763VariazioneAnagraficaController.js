({
    init: function (cmp, event, helper) {
        helper.init(cmp, event, helper);
    },
    

    toUppercase: function(component, event, helper){       
        var myinput = event.getSource();         
        var myvalue = myinput.get("v.value");
        console.log(myinput + '=' +myvalue);
        var mytest = myvalue.toUpperCase();
        myinput.set("v.value",mytest); 
        myinput.showHelpMessageIfInvalid();    
},

verifyCheckScadenza: function (cmp, event, helper) {
    helper.verifyCheckScadenza(cmp, event, helper);
},

    
    
})