/**
*  EmailMessage  WebService
*  @description  Handle Email Sent Notify
*  @author Sana Badji
*          
*  @date  13/05/2019
*
*/
@RestResource(UrlMapping = '/SentNotify')
global with sharing class MailSentNotifyApexClass extends CGMServiceWsr_1_0 {
    public static List<String> errorFields = new List<String>();

    /*
     * @author Sana BADJI
     * @modified by abdoulaye.diopdev3@compass.com.dev
     * @modified date 01/11/2019
     * @description class MailSentNotifyResponse 
     */
    @HttpPost
    global static MailSentNotifyResponse mailSentNotify(String destionatariCC, String mittente,
        String utenteEsternoOrInterno, String corpoHtml,String corpoText,
        String template,String allegati,String oggetto, String destinatario, String mailId, 
        String crmIncidentId, String  accountId) {
        //FromAddress=mittente, 
        EmailMessage thisEmailMessage= new EmailMessage(
        CcAddress=destionatariCC,
        FromName=utenteEsternoOrInterno,
        HtmlBody=corpoHtml,
        Subject=oggetto, 
        TextBody=corpoText,
        ToAddress=destinatario,
        RelatedToId=accountId,
        BccAddress=mailId,
        ParentId=crmIncidentId);
        MailSentNotifyResponse mailSentNotifyResponse = new MailSentNotifyResponse(1L, '');
        try {
            upsert thisEmailMessage;
            System.debug('thisEmailMessage '+thisEmailMessage);
            mailSentNotifyResponse.resultCode = 0L;
            mailSentNotifyResponse.resultMessage = 'Success';
        } catch (Exception e) {
            mailSentNotifyResponse.resultCode = 1L;
            mailSentNotifyResponse.resultMessage = e.getMessage()+' '+e.getStackTraceString();
        }
        
        return mailSentNotifyResponse;
    }

    // Add Email Message Relation for id of the sender
    // EmailMessageRelation emr = new EmailMessageRelation(
    // emailMessageId= thisEmailMessage.Id,
    // relationId = '005B0000003qHvOIAU', // user id of the sender
    // relationType = 'FromAddress'
    // );
    // insert emr;

    global class EmailMessageWrapper extends ObjectWrapper {
        global String destionatariCC { get; set; }
        global String mittente { get; set; }
        global String utenteEsternoOrInterno { get; set; }
        global String corpoHtml { get; set; }
        global String corpoText { get; set; }
        global String template { get; set; }
        global String allegati { get; set; }
        global String oggetto { get; set; }
        global String destinatario { get; set; }
        global String mailId { get; set; }
        global String crmIncidentId { get; set; }
        global String  accountId { get; set; }

        global  EmailMessageWrapper(EmailMessage emailMessage) {
            super(emailMessage);
        }
    }

    /*
     * @author abdoulaye.diopdev3@compass.com.dev
     * @date  01/11/2019
     * @description class MailSentNotifyResponse 
     */
    global class MailSentNotifyResponse extends  GenericResponse {
        public Long resultCode {get; set;}
        public String resultMessage {get; set;}
        global MailSentNotifyResponse(Long resultCode, String resultMessage){
            super(resultCode, resultMessage);
        }
    }
}