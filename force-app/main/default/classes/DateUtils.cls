public class DateUtils {

    public static String formatDateYYYYMMDD(Date d) {
        String month;
            month='0'+d.month();
        String day;
        if(d.month()<10){
        } else {
            month=string.valueof(d.month());
        }
        
        if(d.day()<10){
            day='0'+d.day();
        } else {
            day=string.valueof(d.day());
        }        
        return d.year() + month + day;
    }

    public static String formatDateYYMMDD(Date d) {
        String YYYYMMDDdate = formatDateYYYYMMDD(d);
        return YYYYMMDDdate.substring(2);
    }  

    public static String formatDateYYYYscoreMMscoreDD(Date d) {
        String newFormat = formatDateYYYYMMDD(d);      
        return newFormat.substring(0,4) + '-' + newFormat.substring(4,6)  + '-' + newFormat.substring(6,8);
    }
    
    public static String formatDateYYYYslashMMslashDD(Date d) {
        String newFormat = formatDateYYYYMMDD(d);      
        return newFormat.substring(0,4) + '/' + newFormat.substring(4,6)  + '/' + newFormat.substring(6,8);
    }

    public static String formatDateDDMMYYYY(Date d) {
        String month;
        String day;
        if(d.month()<10){
            month='0'+d.month();
        } else {
            month=string.valueof(d.month());
        }
        
        if(d.day()<10){
            day='0'+d.day();
        } else {
            day=string.valueof(d.day());
        }        
        return day + month + d.year();
    }    
    
    
    public static String formatDateDDscoreMMscoreYYYY(Date d) {
        String newFormat = formatDateDDMMYYYY(d);      
        return newFormat.substring(0,2) + '-' + newFormat.substring(2,4)  + '-' + newFormat.substring(4,8);
    }    

    public static String formatDateDDslashMMslashYYYY(Date d) {
        String newFormat = formatDateDDMMYYYY(d);      
        return newFormat.substring(0,2) + '/' + newFormat.substring(2,4)  + '/' + newFormat.substring(4,8);
    }

    public static String formatDateDDscoreMMscoreYYYY(DateTime dt) {
        Date d = Date.newInstance(dt.year(), dt.month(), dt.day());
        return DateUtils.formatDateDDscoreMMscoreYYYY(d);
    }

    public static String formatDateDDslashMMslashYYYY(DateTime dt) {
        Date d = Date.newInstance(dt.year(), dt.month(), dt.day());
        return DateUtils.formatDateDDslashMMslashYYYY(d);
    }

    public static Date parseFromYYYYMMDDString(String strDate) {
        Date d;
        if (String.isNotBlank(strDate)) {
            Integer year = Integer.valueOf(strDate.substring(0,4));
            Integer month = Integer.valueOf(strDate.substring(4,6));
            Integer day = Integer.valueOf(strDate.substring(6,8));

            d = Date.newInstance(year, month, day);
        }
        return d;
    }
    public static string parseFromYYYYMMDDStringToString(String strDate) {
        String d;
        if (String.isNotBlank(strDate)) {
            
            if( strDate.indexOfAny('/' )== -1){
                Integer year = Integer.valueOf(strDate.substring(0,4));
                Integer month = Integer.valueOf(strDate.substring(4,6));
                Integer day = Integer.valueOf(strDate.substring(6,8));
                string monthS = month < 10 ? ('0'+ month) : string.valueOf(month);
                string dayS = day < 10 ? ('0'+ day) : string.valueOf(day);
                
                d = dayS+'/'+monthS+'/'+year;
            }
            else{
                d=strDate;
            }
        }
        return d;
    }
    
}