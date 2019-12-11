public class TestUnita {
    public static void test(){
        Account acc = [SELECT Id FROM Account LIMIT 1];
        System.debug('test'+ acc.Id);
    }
}