({
	showToast : function(title,type,message){
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
				"title":title,
				"message":message,
				"type":type
			}
		);
		toastEvent.fire();

	},
	cancelDialog : function(component,event,helper){
		var relatedListEvent = $A.get("e.force:navigateToRelatedList");
    	relatedListEvent.setParams({
			"relatedListId": "CampaignMembers",
			"parentRecordId": component.get('v.campaignMemberRecord.CampaignId')
		});
		relatedListEvent.fire();
	},
	navigate : function(component, campaignMemberId) {

		//Find the text value of the component with aura:id set to "address"
		var address = window.location.href;
		var url = address.replace(component.get('v.recordId'),campaignMemberId);
		var urlEvent = $A.get("e.force:navigateToURL");
		urlEvent.setParams({
		  "url": url
		});
		urlEvent.fire();
	},
	save : function(component,helper,record){
		var method = component.get('c.saveCampaignMember');
        method.setParams({
            member : record
        });
        method.setCallback(this,function(response){
            console.log(response);
            var state = response.getState();
            var resp = response.getReturnValue();
            if(state == 'SUCCESS'){
                if(component.get('v.recap') == true){
                    return;
                }
                this.showToast('','success','Membro di campagna salvato con successo');
                this.cancelDialog(component,event,helper);
            } else {
                //errore
                this.showToast('','error',resp);
            }
        });

        $A.enqueueAction(method);
	},
	getDate: function(ActivityDate){
		var data = new Date(ActivityDate);
        var dd = String(data.getDate()).padStart(2, '0');
        var mm = String(data.getMonth() + 1).padStart(2, '0'); //January is 0!
        var yyyy = data.getFullYear();
		//var dateSelected = mm + '/' + dd + '/' + yyyy;
		var dateSelected = yyyy + '-' + mm + '-' + dd;
		return dateSelected;
	},
	setHours: function(component,StartDateTime){
		var data = new Date (StartDateTime);
		var hour = data.getHours().toString().padStart(2, "0");
		var minute = data.getMinutes().toString().padStart(2, "0");
		component.set('v.timeEvent',hour+':'+minute);
	}
})