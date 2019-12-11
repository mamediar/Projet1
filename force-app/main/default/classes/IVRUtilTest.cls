@isTest
public with sharing class IVRUtilTest {

  	@isTest
    static void testFasciaRicontatto(){	    
        Test.startTest();
        String value = IVRUtil.getFasciaDiRicontatto(1);
		    Test.stopTest();
        System.assertEquals('9-12', value);

    }    
            
  	@isTest
    static void testDueDate(){	    
        Test.startTest();
        DateTime value = IVRUtil.setDueDate(1);
        System.assertNotEquals(null, value);
        value = IVRUtil.setDueDate(2);
        System.assertNotEquals(null, value);
        value = IVRUtil.setDueDate(3);
        System.assertNotEquals(null, value);
    		Test.stopTest();

    }    

  	@isTest
    static void testparseDate(){	    
        Test.startTest();
        Date value =  IVRUtil.parseStringToDate('20010101');
 		    Test.stopTest();
        System.assertEquals('2001-01-01', String.valueof(value));

    }    

}