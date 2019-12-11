({

	IncrementaS: function(cmp,event,helper){
        var SpinnerI = cmp.get("v.spinnerCounter");
        SpinnerI++;
        cmp.set("v.spinnerCounter",SpinnerI);
    },
    

    DecrementaS: function(cmp,event,helper){
        var SpinnerD = cmp.get("v.spinnerCounter");
        SpinnerD--;
        cmp.set("v.spinnerCounter",SpinnerD);
	}


})