({
    handleChange:function(cmp,event,helper){
        var x = event.getSource().get("v.value");

        if (x.includes("-")){
        	x = x.replace("-","");  
        } 
        if (x.length > 9) {
            if(x.substring(9,9)=="," || x.substring(9,9)=="."){
	            x = x.substring(0,8);
            }else{
	            x = x.substring(0,9);
            }
        }     
        if (!isNaN(x)) { //FIX 20190712: evita NaN al load dell'input
            cmp.set('v.value',x);
        }
        console.log('RadioBvalue: '+ x);
        if(cmp.get('v.showValue')!='Si'){
            cmp.set('v.value',null);
        }
        cmp.set('v.isOk',helper.checkValuesHelper(cmp,helper));
        cmp.set('v.output',helper.buildOutput(cmp));
        
    }
})