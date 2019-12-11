({
	controlContract : function(cmp, event, helper) 
    {
		var tempInput=event.getParam('barCode');
       	
        var oldbarcode = cmp.get('v.barcodeCartella');
        cmp.set('v.barcodeContratto',tempInput);
        console.log(tempInput);
        if(oldbarcode == tempInput)
        	{
            	cmp.set('v.firstQ','SI');
                cmp.set('v.secondQ','SI');
               
        	}
        else
            {
            	cmp.set('v.firstQ','SI');
                cmp.set('v.secondQ','NO');
            }
        if(cmp.get('v.firstQ') == 'SI')
            {
            	cmp.set('v.ifFirstTrue',true);
                if(cmp.get('v.secondQ') == 'SI')
                {
              	 	cmp.set('v.ifSecondTrue',true);
                }
            	else
                {
                    cmp.set('v.ifSecondTrue',false);
                }
            }
        else
        	{
             	cmp.set('v.ifFirstTrue',false);
                cmp.set('v.ifSecondTrue',false);
            }
	},
    visibility : function(cmp, event, helper) 
    {
           	console.log("HOLA");
        	if(cmp.get('v.firstQ') == 'SI')
            {
            	cmp.set('v.ifFirstTrue',true);
                if(cmp.get('v.secondQ') == 'SI')
                {
              	 	cmp.set('v.ifSecondTrue',true);
                }
            	else
                {
                    cmp.set('v.ifSecondTrue',false);
                    cmp.set('v.thirdQ','NO');
                }
            }
       		else
        	{
             	cmp.set('v.ifFirstTrue',false);
                cmp.set('v.ifSecondTrue',false);
                cmp.set('v.secondQ','NO');
                cmp.set('v.thirdQ','NO');
            }
    
	},
    nextflow : function(cmp, event, helper) 
    {
    	var navigate = cmp.get('v.navigateFlow');
    	navigate("NEXT");
    }    
})