({
	clearAll: function (component, event) {
		// this method set all tabs to hide and inactive
		var getAllLI = document.getElementsByClassName("customClassForTab");
		var getAllDiv = document.getElementsByClassName("customClassForTabData");
		for (var i = 0; i < getAllLI.length; i++) {
			getAllLI[i].className = "slds-tabs--scoped__item slds-text-title--caps customClassForTab";
			getAllDiv[i].className = "slds-tabs--scoped__content slds-hide customClassForTabData";
		}
	}
})