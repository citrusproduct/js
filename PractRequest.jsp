<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
   <head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
		
	<script src="http://code.jquery.com/jquery-1.11.1.min.js"> </script>
   <script src="https://icp.citruspay.com/js/citrus.js"> </script>
   <script src="https://icp.citruspay.com/js/jquery.payment.min.js"> </script>
    

    <%@ page import="java.text.Format" %>
	<%@ page import="javax.crypto.Mac" %>
	<%@ page import="javax.crypto.spec.SecretKeySpec" %>
	<%@ page import="java.util.Random" %>
	<%-- <%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %> --%> 
    
    
  </head>

<body>
	
<%
    //These parameters and signature-generation should be used on server side
    //Need to change with your Secret Key
    String secret_key = "f4d7c357a7d496468eb1ba8d5ff6a564f8ac48cd"; 
    
    //Need to change with your Access Key
    String access_Key = "66PT1PDZ38A5OB1PTF01"; 
    
    //Should be unique for every transaction
    String txnID = String.valueOf(System.currentTimeMillis()); 
    
    //Need to change with your Order Amount
    String amount = "9.00";
    //Need to change with your Return URL
    String returnURL = "http://localhost:8085/TestApp/PractResponse.jsp";
    //Need to change with your Notify URL
    String notifyUrl = "www.YourDomain.com/notifyResponsePage";

     String data = "merchantAccessKey=" + access_Key + "&transactionId=" + txnID + "&amount=" + amount;
     javax.crypto.Mac mac = javax.crypto.Mac.getInstance("HmacSHA1");
     mac.init(new javax.crypto.spec.SecretKeySpec(secret_key.getBytes(), "HmacSHA1"));
     byte[] hexBytes = new org.apache.commons.codec.binary.Hex().encode(mac.doFinal(data.getBytes()));
     String securitySignature = new String(hexBytes, "UTF-8");

	  

   // out.print(securitySignature);
%>
    
  

<form align="center" >
	<input type="hidden" id="citrusFirstName" value="John" /><br />
	<input type="text" id="citrusLastName" value="Smith" /><br />
	<input type="text" id="citrusEmail" value="abc@domain.com" /><br />
	<input type="text" id="citrusStreet1" value="street1" /><br />
	<input type="text" id="citrusStreet2" value="street2" /><br />
	<input type="text" id="citrusCity" value="Pune" /><br />
	<input type="text" id="citrusState" value="Maharashtra" /><br />
	<input type="text" id="citrusCountry" value="India" /><br />
	<input type="text" id="citrusZip" value="424001" /><br />
	<input type="text" id="citrusMobile" value="9999999999" /><br />
	          
	<input type="text" readonly id="citrusAmount" value="<%= amount %>" /><br />
	<input type="text" readonly id="citrusMerchantTxnId" value="<%= txnID %>" /><br />
	<input type="hidden" readonly id="citrusSignature" value="<%= securitySignature %>" /><br />
	<input type="hidden" readonly id="citrusReturnUrl" value="<%= returnURL %>" /><br />
	<input type="hidden" readonly id="citrusNotifyUrl" value="<%= notifyUrl %>" /><br />

 PAY BY CC/DC ************************************************************************************************************************************************<br />

 <select id="citrusCardType">
        <option selected="selected" value="credit">Credit</option>
        <option value="debit">Debit</option>
    </select>
    <select id="citrusScheme">
        <option selected="selected" value="visa">VISA</option>
        <option value="mastercard">MASTER</option>
    </select>
    Card Number:
    <input type="text" id="citrusNumber" value=""/>	<br />
     Name as on Card:
    <input type="text" id="citrusCardHolder" value="mayur"/><br />
    Card Expiry Month/Year:
    <input type="text" id="citrusExpiry" value="01/2022"/><br />
     Card CVV:
    <input type="text" id="citrusCvv" value="123"/><br />
    <input type="button" value="Pay Now" id="citrusCardPayButton"/><br />
    
  Pay by Netbanking:
            ************************************************************************************************************************************************<br />
    Select Bank:  
     <select id="citrusAvailableOptions">
    </select>
    <input type="button" value="Pay by netbanking" id="citrusNetbankingButton" /><br />
    
  </form>
</body>
 
  
     <script type="text/javascript">
    CitrusPay.Merchant.Config = {
        // Merchant details
        Merchant: {
            accessKey: '66PT1PDZ38A5OB1PTF01', //Replace with your access key
            vanityUrl: 'rr5dhnsvew'  //Replace with your vanity URL
        }
    }; 
    fetchPaymentOptions();
    
    function handleCitrusPaymentOptions(citrusPaymentOptions) {
        if (citrusPaymentOptions.netBanking != null)
            for (i = 0; i < citrusPaymentOptions.netBanking.length; i++) {
                var obj = document.getElementById("citrusAvailableOptions");
                var option = document.createElement("option");
                option.text = citrusPaymentOptions.netBanking[i].bankName;
                option.value = citrusPaymentOptions.netBanking[i].issuerCode;
                obj.add(option);
            }
    }
  
        //Net Banking
         $('#citrusNetbankingButton').on("click", function () { makePayment("netbanking") });                     
        //Card Payment
        $("#citrusCardPayButton").on("click", function () { makePayment("card") });
        
        $("#citrusCashPayButton").on("click", function(){makePayment("citrusbanking")});
   
    
    function citrusServerErrorMsg(errorResponse) {
        alert(errorResponse);
        console.log(errorResponse);
    }
    function citrusClientErrMsg(errorResponse) {
        alert(errorResponse);
        console.log(errorResponse);
    }
    
    
    //UI validations
    jQuery(document).ready(function() {	
    	jQuery.support.cors = true; 
    	
    	// setup card inputs;	 	
    	jQuery('#citrusExpiry').payment('formatCardExpiry');
    	jQuery('#citrusCvv').payment('formatCardCVC');
    	jQuery('#citrusNumber').keyup(function () {
    	    debugger;
    			var cardNum = jQuery('#citrusNumber').val().replace(/\s+/g, '');		
    			var type = jQuery.payment.cardType(cardNum);
    			
    			console.log(type);
    			//jQuery("#citrusNumber").css("background-image", "url(resource/amex.png)");						
    			
    			//jQuery("#citrusNumber").css("background-image",  "url(resource/" + type + ".png)");
    			
    			 jQuery("#citrusNumber").css({"background-image": "url(resource/" + type + ".png)","background-repeat":"no-repeat","background-position":"right"});
    			
    			//jQuery("#citrusNumber").css("background-image", "url(http://icp.citruspay.com/Gallery/images/" + type + ".png)"); 
    			if(type!='amex')
                jQuery("#citrusCvv").attr("maxlength","3");
                else
                jQuery("#citrusCvv").attr("maxlength","4");						
    			jQuery('#citrusNumber').payment('formatCardNumber');											
    			jQuery("#citrusScheme").val(type);		
    	});				 
    }); 

    
    </script>
    </html>
    
    
    