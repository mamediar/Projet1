/**
 * @File Name          : XCSChatterUtils.cls
 * @Description        : 
 * @Author             : Federico Negro
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 4/11/2019, 16:23:13
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    4/11/2019   Federico Negro     Initial Version
**/
public class XCSChatterUtils {


	public static void postMessageWithMention(String chatterGroupName, String objectToMentionId, String message, Boolean sendMessage ){
		System.debug('sono in XCSChatterUtils');

		if(sendMessage) {

			System.debug('XCSChatterUtils postMessageWithMention ');
			System.debug('chatterGroupName ' + chatterGroupName );
			System.debug('objectToMentionId ' + objectToMentionId );
			System.debug('message ' +message );
			System.debug('sendMessage '  + sendMessage );

			CollaborationGroup chatterGroup = [SELECT Id,Name FROM CollaborationGroup
			                                   WHERE Name = :chatterGroupName
			                                                LIMIT 1];


			ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
			ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
			ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
			ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();

			messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();

			textSegmentInput.text = message;
			messageBodyInput.messageSegments.add(textSegmentInput);

			mentionSegmentInput.id = chatterGroup.Id;
			messageBodyInput.messageSegments.add(mentionSegmentInput);


			feedItemInput.body = messageBodyInput;
			feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
			feedItemInput.subjectId = objectToMentionId;

			ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(null, feedItemInput);


		}
	}

	public static void postMessage(Id chatterGroup, String caseSelezionato, String note){

		ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
		ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
		ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
		ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();

		messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();

		textSegmentInput.text = note;
		messageBodyInput.messageSegments.add(textSegmentInput);

		mentionSegmentInput.id = chatterGroup;
		messageBodyInput.messageSegments.add(mentionSegmentInput);


		feedItemInput.body = messageBodyInput;
		feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
		feedItemInput.subjectId = caseSelezionato;

		ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(null, feedItemInput);



	}

	public static void postMessagePV(String recordId, String note){
		ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
		ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
		ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
		ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
		messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();

		textSegmentInput.text = note;
		messageBodyInput.messageSegments.add(textSegmentInput);

		feedItemInput.body = messageBodyInput;
		feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
		feedItemInput.subjectId = recordId;
		ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(null, feedItemInput);
	}

	//metodo per postare dal Site
	//Boris Commentato a fronte del deploy in Dev3
	public static void postFromSite(Id recordId, String message, String title) {
	/*	Create_Feed_Item__e myEvent = new Creat	e_Feed_Item__e(
                   UtenteId__c = recordId,
                   Body__c =message,
        		   Title__c = title);

        System.debug('feed item: '+myEvent);
        
        Database.SaveResult sr = EventBus.publish(myEvent);

        System.debug('feed item publish result: '+sr.isSuccess());
  
        if (sr.isSuccess()) {
            System.debug('Successfully published event.');
        } else {
            for(Database.Error err : sr.getErrors()) {
                System.debug('Error returned: ' +
                             err.getStatusCode() +
                             ' - ' +
                             err.getMessage());
            }
        }*/
	}

}