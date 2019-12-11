({
	doInit : function(component, event, helper) {
		console.log('SchedaVerificaFilialeRecordVisualizzato');
		component.set('v.currentUserId',$A.get('$SObjectType.CurrentUser.Id'));
		if(component.get('v.currentUser.Profile.Name')){
			var profiloUtente    = component.get('v.currentUser.Profile.Name');
			var ruoloUtente    = component.get('v.currentUser.UserRole.Name');
			//visualizzazione coordinatore area
			if( (ruoloUtente == 'DIREZIONE RETE' && component.get('v.simpleRecord.Letta_Responsabile__c') == false)){
				helper.updateLetta(component,'Letta_Responsabile__c');
			} else {
				//visualizzazione audit
				if(profiloUtente == 'Reclami' && component.get('v.simpleRecord.Letta_Audit__c') == false){
					helper.updateLetta(component,'Letta_Audit__c');
				}
			}
		}

	}
})