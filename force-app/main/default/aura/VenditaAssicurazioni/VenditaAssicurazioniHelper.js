({
    setOptions : function(cmp) {                
        var today = new Date();                
        cmp.set('v.interestOptions', [
            {label:'Interessato', value:'interessato'},
            {label:'Non Interessato', value:'non_interessato'},
            {label:'Irreperibile ', value:'irreperibile'} 
        ]);
        cmp.set('v.permissionOptions', [
            {label:'Presto il consenso', value:'acconsento'},
            {label:'Nego il consenso', value:'dissento'}            
        ]);
        cmp.set('v.dataPreferenceOptions', [
            {label:'Gestisci', value:'gestisci'},
            {label:'Schedula', value:'schedula'}
        ]);
        //2018-11-20T00:30:00.000Z
        cmp.set('v.today', today.toISOString());
        cmp.set('v.flagPianificazioneVenditaContainer', true);
        /*cmp.set('v.today', today.getFullYear() + 
                "-" + (today.getMonth() + 1) +
                "-" + today.getDate() + 
                "T" + (today.getHours() - 1) + 
                ":" + today.getMinutes() +
                ":" + today.getSeconds() + ".000Z");*/
		
    },
    
    show : function (elem) {        
        var getHeight = function () {
            elem.style.setProperty('display', 'block'); // Make it visible
            var height = elem.scrollHeight + 'px'; // Get its height
            elem.style.setProperty('display', ''); //  Hide it again
            return height;
        };        
        var height = getHeight();
        //console.log('height '+height);
                
        $A.util.addClass(elem, 'is-visible'); 
        elem.style.setProperty('height', height);         
        window.setTimeout(function(){elem.style.setProperty('height', '');}, 350);        
    }, 
    
    hide : function (elem) {        
        elem.style.setProperty('height',elem.scrollHeight + 'px' );       
        window.setTimeout(function(){elem.style.setProperty('height', '0');}, 1);
        window.setTimeout(function(){$A.util.removeClass(elem, 'is-visible');}, 350);        
    }
    
    /*slideOn : function(elem){
        var getWidth = function () {
            elem.style.setProperty('display', 'inline-block'); // Make it visible
            var width = elem.clientWidth + 'px'; // Get its height
            elem.style.setProperty('display', ''); //  Hide it again
            return width;
        };        
        var width = getWidth();                
        console.log('width '+width);
        
        $A.util.addClass(elem, 'is-visible'); 
        elem.style.setProperty('width', width);         
        window.setTimeout(function(){elem.style.setProperty('width', '');}, 350);  
    },
    
    slideOff : function(elem){
        elem.style.setProperty('width',elem.clientWidth + 'px' );       
        window.setTimeout(function(){elem.style.setProperty('width', '0');}, 1);
        window.setTimeout(function(){$A.util.removeClass(elem, 'is-visible');}, 350);  
    }*/
    
})