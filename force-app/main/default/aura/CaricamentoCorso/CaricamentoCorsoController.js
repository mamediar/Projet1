({
    
    /**
	 * @description : To show Toast
	 * @author: Mady COLY
	 * @date: 30/07/2019
	 * @param :message
	 * @param :type
	 */
    showToast: function (message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            message: message,
            type: type
        });
        toastEvent.fire();
    },
    doInit : function(component, event, helper) {
        var action = component.get("c.getAllAggiungiCorso");
        action.setCallback(this,function(response){
            alert('ok')
            var state = response.getState();
            if (state === 'SUCCESS') {
                console.log('data : '+JSON.stringify(response.getReturnValue()));
            }else
            {
                this.showToast('Non successo', 'ERROR');
            }
        });
        $A.enqueueAction(action);
    }
})