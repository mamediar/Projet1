public class MenuWrapperController {
    @AuraEnabled
    public static String loadTabName(){
        
        List<Schema.DescribeTabSetResult> tabSetDesc = Schema.describeTabs();
		System.debug('cosi: ' + tabSetDesc);
        String currentAppName;
        for(Schema.DescribeTabSetResult tsr : tabSetDesc){if(tsr.isSelected()){System.debug('coso: ' + tsr);currentAppName = tsr.getLabel();break;}}
        /*la parte relativa all'if(tsr.isSelected()) non si riesce a testare in quanto Schema.DescribeTabSetResult non si può istanziare e non si può
          nemmeno effettuare l'insert in database nella classe di Test*/
        System.debug('nome app: ' + currentAppName);
        return currentAppName;
    }
}