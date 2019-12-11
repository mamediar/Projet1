({
    init : function(cmp, event, helper) {
        let forAcc = cmp.get('v.CaseRecord');
        cmp.set('v.account',forAcc.Account.Name);
        cmp.set('v.accountOCSid', forAcc.Account.getCodice_Cliente__c);
       
    }
})