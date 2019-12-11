/**
 * @File Name          : GUA_DettaglioDealerCnt.cls
 * @Description        : 
 * @Author             : Mame Bousso kane
 * @CreatedDate        : 23/10/2019
 */
public with sharing class GUA_DettaglioDealerCnt {

    @AuraEnabled
    public static Map<String ,Object> getDealerByCase(String idCase){
        Map<String ,Object> returnValue = new  Map<String ,Object>();
        returnValue.put('erreur', false);
       try {
           Case dealerCase = Gua_ManageUnitaAffariQuery.getDealerByCase(idCase);
           returnValue.put('resultat',dealerCase);
       } catch (Exception e) {
            System.debug('errorMessage GUA_DettaglioDealerCnt getDealerByCase '+e.getMessage());
             returnValue.put('message', e.getMessage()+' '+e.getCause()+' '+e.getLineNumber());
             returnValue.put('erreur', true);
       }
        return returnValue;
    }

    @AuraEnabled
    public static Map<String ,Object> getFilialeById(String idAccount){
        Map<String ,Object> returnValue = new  Map<String ,Object>();
        returnValue.put('erreur', false);
       try {
           Account filialeCase = Gua_ManageUnitaAffariQuery.getFilialeById(idAccount);
           returnValue.put('filiale',filialeCase);
       } catch (Exception e) {
            System.debug('errorMessage GUA_DettaglioDealerCnt getFilialeById '+e.getMessage());
             returnValue.put('message', e.getMessage()+' '+e.getCause()+' '+e.getLineNumber());
             returnValue.put('erreur', true);
       }
        return returnValue;
    }

    @AuraEnabled
    public static Map<String ,Object> getCapoFiliale(String idFiliale){
        Map<String ,Object> returnValue = new  Map<String ,Object>();
        returnValue.put('erreur', false);
        returnValue.put('filiale', false);
        returnValue.put('resultat','');
       try {
            
            if(idFiliale!=null){
                returnValue.put('filiale', true);
                Account filiale = [SELECT Id,Name,CittaSede__pc,getCodice_Cliente__c,Provincia_Nascita__pc,Luogo_Nascita__pc,BillingAddress,ShippingStreet, 
                                    ShippingCity, ShippingState, ShippingPostalCode, NameRoleReference__c 
                                    FROM Account WHERE RecordType.Name='Branch'
                                    AND Id=:idFiliale limit 1];
                String roleReference = filiale.NameRoleReference__c;
                roleReference=roleReference.replace('_', ' ');
                User capoFiliale=[select id,name,profile.name,UserRole.Name from User 
                                                where  profile.name in (:PermissionUtils.BRANCH_MANAGER)
                                                and UserRole.Name=:roleReference limit 1];                
                if(capoFiliale.Id!=null){
                    returnValue.put('resultat',capoFiliale);
                }
            }else {
                returnValue.put('filiale', false);
            }
       } catch (Exception e) {
            System.debug('errorMessage GUA_DettaglioDealerCnt getCapoFiliale '+e.getMessage());
             returnValue.put('message', e.getMessage()+' '+e.getCause()+' '+e.getLineNumber());
             returnValue.put('erreur', true);
       }
        return returnValue;
    }
public with sharing class GUA_CSVparsingJSON {
   public String cognome{get;set;}
   public String nome{get;set;}
   public String data_caricamento{get;set;}
   public String data_delibera{get;set;}
   public String data_liquidazione{get;set;}
   public String importo_erogato{get;set;}
   public String cod_Convenzionato_H3G{get;set;}
   public String descr_Convenzionato_H3g{get;set;}
   public String codice_Fiscale_Conv{get;set;}
   public String partita_IVA_Conv{get;set;}
   public String codice_PV_H3G{get;set;}
   public String descr_PV_H3G{get;set;}
   public String num_I_telefono{get;set;}
   public String num_II_telefono{get;set;}
   public String codice_Filiale_Compass{get;set;}
   public String filiale_Compass{get;set;}
   public String gg_trascorsi_dalla_delibera{get;set;}
   public String gg_trascorsi_dalla_liquidazione{get;set;}
   public String anomalia_num_2{get;set;}
   public String anomalia_num_3{get;set;}
   public String anomalia_num_4{get;set;}
   public String anomalia_num_5{get;set;}

   //Constructor

Public GUA_CSVparsingJSON(String val1,String val2,String val3,String val4,String val5,String val6,String val7,
                          String val8,String val9,String val10,String val11,String val12,String val13,
                          String val14,String val15,String val16,String val17, String val18,
                          String val19,String val20,String val21, String val22){
        this.cognome = val1;
        this.nome = val2;
        this.data_caricamento = val3;
        this.data_delibera = Val4;
        this.data_liquidazione = val5;
        this.importo_erogato = val6;
        this.cod_Convenzionato_H3G = val7;
        this.descr_Convenzionato_H3g = val8;
        this.codice_Fiscale_Conv = val9;
        this.partita_IVA_Conv = val10;
        this.codice_PV_H3G = val11;
        this.descr_PV_H3G = val12;
        this.num_I_telefono = val13;
        this.num_II_telefono = val14;
        this.codice_Filiale_Compass = val15;
        this.filiale_Compass = val16;
        this.gg_trascorsi_dalla_delibera = val17;
        this.gg_trascorsi_dalla_liquidazione = val18;
        this.anomalia_num_2 = val19;
        this.anomalia_num_3 = val20;
        this.anomalia_num_4 = val21;
        this.anomalia_num_5 = val22;


    }
}
}