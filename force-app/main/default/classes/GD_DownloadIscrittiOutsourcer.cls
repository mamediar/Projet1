public class GD_DownloadIscrittiOutsourcer{

       ApexPages.StandardSetController setCon;
	   
	   //Costruttore
	   public GD_DownloadIscrittiOutsourcer(ApexPages.StandardSetController controller)
	   {
		   this.setCon = controller;
		   system.debug('17_10_2019 setCon->'+setCon);
	   }


}