({
    init : function(cmp,event,helper){
        helper.initHelper(cmp);
    },
    
    inserisciTestoStandard : function(cmp, event, helper){
        helper.inserisciTestoStandard(cmp, event);
    },
    
    inserisciParagrafoStandard : function(cmp, event, helper){
        helper.inserisciParagrafoStandard(cmp, event);
    },
    
    
	handleClickFirmaDigitale:function(cmp,event,helper){
        var fD=!cmp.get('v.getFirmaDigitale');
		cmp.set('v.getFirmaDigitale',fD);
        cmp.set('v.variantButtonFirmaDigitale',fD?'success':'neutral');
	},
    
     creaLettera : function(cmp,event,helper){
        helper.creaLetteraHelper(cmp);
    },
    
     handleTextboxChange : function(cmp,event,helper){
        cmp.set('v.mailText',cmp.get('v.textAreaValue'));
    },
    
    showMailSection:function(cmp,event,helper){
        cmp.set('v.showMailSection',true);
    },
    
    salvaLettera : function(cmp, event, helper){
       helper.salvaLettera(cmp, event); 
    }
    
  
    //Boris Fine
    
    
   
})