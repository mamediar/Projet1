({ 
 /*   init: function(cmp, event, helper) {
        //qui faccio il controllo sulle credenziali: solo se account è presente altrimenti non può avere un'attività 
//        helper.getAccount(cmp, event, helper);
        console.log("init var email");
    },
*/
    verifyCheckPrivacy: function (cmp, event, helper) {
        cmp.find('checkbox').showHelpMessageIfInvalid();
    },
})