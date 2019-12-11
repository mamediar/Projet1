public class XCSDataUtils {
    
    public static Boolean checkRegex(final String regex, final String value) {
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(value);
        return matcher.matches();
    }

    public static Boolean checkYYYYMMddWithDashes(final String dateStr) {
        // check wheter input dateStr matches 'yyyy-MM-dd' pattern
        return checkRegex('^\\d{4}\\-(0?[1-9]|1[012])\\-(0?[1-9]|[12][0-9]|3[01])$', dateStr);
    }

}