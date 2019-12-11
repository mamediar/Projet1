({
    checkValuesHelper : function(cmp,helper) {
        var res=false;
        res=helper.checkIfCompiled(cmp);
        return res;
    },
    
    checkIfCompiled:function(cmp){
        var res=false;
        var input = cmp.find('input');
        //if(cmp.get('v.showValue') && (cmp.get('v.value'))){
        if(cmp.get('v.showValue') && ((input && !this.isBlank(input)) || !input)){ //FIX 20190712: se l'input è visualizzato, controllo che abbia un value
            res=true;
        }
        return res;
    },
    
    buildOutput:function(cmp){
        var res={};
        res['selection']=cmp.get('v.showValue');
        res['value']=cmp.get('v.value');
        return res;
    },

    isBlank: function (input) {
        var value = input.get('v.value');
        if (value === undefined || value === null || value == '' || value == ' ') {
            return true;
        }
        return false;
    }
})