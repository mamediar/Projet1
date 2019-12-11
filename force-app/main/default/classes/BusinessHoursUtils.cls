public class BusinessHoursUtils {

   public static FINAL String SLA = 'CRM_SLA_Fax';
    
   
   public static BusinessHours getBusinessHours(String name)
   {
       return [Select id From BusinessHours where name = :name];
   }
    
   public static Long getDiffMinutes(Id businessHoursId,DateTime startDate,DateTime endDate)
   {
       return BusinessHours.diff(businessHoursId,startDate,endDate)/60000;
   }
    
   public static Long getDiffMinutesForCRMFax(DateTime startDate,DateTime endDate)
   {
       return getDiffMinutes(getBusinessHours(SLA).id,startDate,endDate);
   }
    
    
    
}