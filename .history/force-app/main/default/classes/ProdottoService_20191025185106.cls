public with sharing class ProdottoService {
    
  /*
   * @description get produit by code
   *
   * @param codeProdotto : product code
   *
   * @return  the produit
   */
    public static Product2 getProdottoByCode(String codeProdotto){
        String codeProd = codeProdotto.substringAfter(';');
         System.debug('*************  xxxxx '+codeProd);
        Product2 produit = new Product2();
        try{
                produit = [Select Id, ProductCode, Family FROM Product2  WHERE ProductCode =: codeProd];
          
        }
        catch(Exception e){
                System.debug('errorMessage getProdottoByCode '+ e.getMessage() );
                 RequestOnlineApexClass.errorCode = '[KO-PROD001]';
                 RequestOnlineApexClass.errorMessage = codeProdotto;
                // throw new CGMWSUtils_1_0.CGMWSRException('[KO-PROD001]','');
        }
        
        return  produit;
    }
    
    /*
   * @description get all produit 
   *   
   * @return  list produit
   */
    public static List<Product2>  getProduct2(Integer livello,String idParent){
        List<Product2> produits = new List<Product2>();
        try{
            if(codeProdotto==0){
                produits = [Select Id, Description,Name, ProductCode, Family, StockKeepingUnit, Livello__c
                                FROM Product2 WHERE Livello__c =:livello];
            }else {
               produits = [Select Id, Description,Name, ProductCode, Family, StockKeepingUnit, Livello__c
                                FROM Product2 WHERE Livello__c =:livello AND Parent__C=:idParent];
            }
                
        }
        catch(Exception e){
                System.debug('errorMessage getProdottoByCode '+ e.getMessage() );
        }
        
        return  produits;
    }

	public static List<XCS_Town__c> getProvinceCommuneAll(){
          List<XCS_Town__c > xcsTown = new List<XCS_Town__c >();
         try {
               xcsTown=[SELECT Comune__c, Provincia__c, Id FROM XCS_Town__c LIMIT 1000];
            
        } catch (Exception e) {
            System.debug('errorMessage CreaAppuntamentoController getProvinceCommune '+e.getMessage());
            return null;
        }
        return xcsTown;
}
    
    public static Product2 getProdottoById(String IdProdotto){
        Product2 produit = new Product2();
        try{
                produit = [Select Id,Name, ProductCode FROM Product2  WHERE Id =: IdProdotto];
        }
        catch(Exception e){
                System.debug('errorMessage getProdottoById '+ e.getMessage() );
        }
        return  produit;
    } 

    /**------------------------------------------------------------------------------------
    *@Author Madicke BALDE
    *@date 2019/08/29
    *@description get Product2 by prodottoLvl1
    *@param prodottoLvl1
    *@return Product2
   *------------------------------------------------------------------------------------*/
  public static Product2 getProdottoByCodeProdotto(String codeProdotto){
    Product2 prodotto = new Product2();
   try {
      // Double lv1 = Double.valueOf(prodottoLvl1);
       prodotto = [SELECT Id, Livello__c FROM Product2 WHERE ProductCode =: codeProdotto ];
     
   } catch (Exception e) {
       AppuntamentoError.hasError = true;
       AppuntamentoError.errorMessage = 'prodotto non trovato con questo prodottoLvl1 '+codeProdotto;
     System.debug(' ########### errorMessage ###### '+e.getMessage());
     System.debug(' ########### errorMessage ###### '+e.getStackTraceString() );
   // throw new CGMWSUtils_1_0.CGMWSRException('[KO-PROD002]');

   }
   return prodotto;
  }
}