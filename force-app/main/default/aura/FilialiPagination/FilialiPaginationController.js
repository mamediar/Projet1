({
   previousPage: function(component, event, helper) 
   {
                helper.previousPage(component, event);
   },
   nextPage: function(component, event, helper) 
   {
                helper.nextPage(component, event);
   },
   goFirstPage: function(component, event, helper)
   {
                helper.firstPage(component, event);

   },
   goLastPage: function(component, event, helper)
   {
                helper.lastPage(component, event);
   },
   goToPage: function(component, event, helper)
   {
                helper.toPage(component, helper);
                console.log("Dopo, current Page:"+ component.get("v.currentPage"));
   }

})