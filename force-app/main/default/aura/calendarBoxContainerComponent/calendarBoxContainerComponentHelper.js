({
	doInit : function(cmp, event, helper) {
		var user= cmp.get('v.user');
		var slotList= cmp.get('v.slotList');
		var weekDays= cmp.get('v.weekDays');
		var assenzeProlungateList= cmp.get('v.assenzeProlungateList');
		var slotListAMUser=[];
		var slotListAM=[];
		var slotListPM=[];
		var slotListPMUser=[];
		var assenzeProlungateUserList=[];
		if(user){
			slotListAM= slotList.filter(function(slot){return slot.Time__c==='AM';});
			slotListPM= slotList.filter(function(slot){return slot.Time__c==='PM';});
			slotListAMUser= slotList.filter(function(slot){ return (slot.User__c===user.Id && slot.Time__c==='AM');});
			slotListPMUser= slotList.filter(function(slot){ return (slot.User__c===user.Id && slot.Time__c==='PM');});
			assenzeProlungateUserList= assenzeProlungateList.filter( assenzaProlungata =>{
				return assenzaProlungata.RisorsaFiliale__c === user.Id;
			});
		}
		var dayOrderedAMSlotList=[];
		var dayOrderedPMSlotList=[];
		var dayOrderedAMAllUsersSlotList=[];
		var dayOrderedPMAllUsersSlotList=[];

		weekDays.forEach(day => {
			var slotOfDayAMForAllUsers= slotListAM.filter(function(slot){return (slot.Date__c===day.theDate)});
			var slotOfDayPMForAllUsers= slotListPM.filter(function(slot){return (slot.Date__c===day.theDate)});
            var slotOfDayAM= slotListAMUser.filter(function(slot){ return (slot.Date__c===day.theDate)});
			var slotOfDayPM= slotListPMUser.filter(function(slot){ return (slot.Date__c===day.theDate)});
			var dailyAssenzeUserList= assenzeProlungateUserList.filter(assenza =>{
				return day.theDate >= assenza.StartDate__c && day.theDate <= assenza.EndDate__c;
			})
			var dayIsCurrentMonth= true;
			if(cmp.get('v.targhetDate')){
				dayIsCurrentMonth= new Date(day.theDate).getMonth() == new Date(cmp.get('v.targhetDate')).getMonth(); 
			}
			var notElapsedAM = helper.notElapsedDateHour(cmp,event,helper,day,'AM');
			var notElapsedPM = helper.notElapsedDateHour(cmp,event,helper,day,'PM');
			
			dayOrderedAMSlotList.push({day:day,slotList:slotOfDayAM, assenzeList: dailyAssenzeUserList, belongToCurrentMonth: dayIsCurrentMonth ,notElapsed : notElapsedAM});
			dayOrderedPMSlotList.push({day:day,slotList:slotOfDayPM, assenzeList: dailyAssenzeUserList, belongToCurrentMonth: dayIsCurrentMonth,notElapsed : notElapsedPM});
			dayOrderedAMAllUsersSlotList.push({day:day, slotListForAllUsers:slotOfDayAMForAllUsers});
			dayOrderedPMAllUsersSlotList.push({day:day, slotListForAllUsers:slotOfDayPMForAllUsers});
		});
                                                     
		cmp.set("v.slotListsAM",dayOrderedAMSlotList);
		cmp.set("v.slotListsPM",dayOrderedPMSlotList);
		cmp.set("v.slotListAMForAllUsers",dayOrderedAMAllUsersSlotList);
		cmp.set("v.slotListPMForAllUsers",dayOrderedPMAllUsersSlotList);
	},

	addAM: function(cmp, event, helper){
		

		/*var slotListAM= cmp.get('v.slotListsAM');
		slotListAM.forEach(dayListAM => {
			dayListAM.slotList.push({typeLabel: "Test Slot" , Status__c : 'Draft'});
			cmp.set('v.unsavedAdd', cmp.get('v.unsavedAdd')+1);
		})
		cmp.set('v.slotListsAM',slotListAM);*/

		cmp.set('v.popUpMoment', 'AM');
		helper.massiveAddElement(cmp, event, helper);

	},

	addPM: function(cmp, event, helper){
		/*var slotListPM= cmp.get('v.slotListsPM');
		slotListPM.forEach(dayListPM => {
			dayListPM.slotList.push({typeLabel: "Test Slot" , Status__c : 'Draft'});
			cmp.set('v.unsavedAdd', cmp.get('v.unsavedAdd')+1);
		})
		cmp.set('v.slotListsPM',slotListPM);*/

		cmp.set('v.popUpMoment', 'PM');
		helper.massiveAddElement(cmp, event, helper);

	},

	addALL: function(cmp, event, helper){
		/*helper.addAM(cmp, event, helper);
		helper.addPM(cmp, event, helper);*/
		
		cmp.set('v.popUpMoment', 'AMPM');
		helper.massiveAddElement(cmp, event, helper);

	},

	massiveAddElement: function(cmp, event, helper){
		var popUp= cmp.find('popUpComponent');
		var branch = cmp.get('v.isFilialista') ? cmp.get('v.branch.Id'): '';
		var newSlotForPopUp={Branch__c: branch, 
							Date__c: "", 
							Id: null,
							Status__c: "Valido",
							Time__c: "",
							User__c: cmp.get('v.user.Id')
							};
		cmp.set('v.newSlotForPopUp', newSlotForPopUp);
		popUp.openPopUp();
	},

	notElapsedDateHour: function(cmp,event,helper,day,moment){
		var nowDate= new Date();
		var clockTime= nowDate.getHours() >= 12 ? 'PM' : 'AM';
		if(day.theDate < cmp.get('v.today') ||
		(day.theDate === cmp.get('v.today') && clockTime==='PM' && moment==='AM')
		){
					return false;
		}
		else{
			return true;
		}
	},
})