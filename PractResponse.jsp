	<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>

 <%@ page language="java" import="java.lang.*" session="false" isErrorPage="false" %>
         <%
             //Replace this with your secret key from the citrus panel
             String secret_key = "f4d7c357a7d496468eb1ba8d5ff6a564f8ac48cd";

             String data="";
             String txnId=request.getParameter("TxId");
             String txnStatus=request.getParameter("TxStatus"); 
             String amount=request.getParameter("amount"); 
             String pgTxnId=request.getParameter("pgTxnNo");
             String issuerRefNo=request.getParameter("issuerRefNo"); 
             String authIdCode=request.getParameter("authIdCode");
             String firstName=request.getParameter("firstName");
             String lastName=request.getParameter("lastName");
             String pgRespCode=request.getParameter("pgRespCode");
             String zipCode=request.getParameter("addressZip");
             String resSignature=request.getParameter("signature");
             //String originalAmount=request.getParameter("originalAmount");
          	 //String adjustedAmount=request.getParameter("adjustedAmount");
             //String transactionAmount=request.getParameter("transactionAmount");
             
             //Binding all required parameters in one string (i.e. data)
             if (txnId != null) {
                 data += txnId;
             }
             if (txnStatus != null) {
                 data += txnStatus;
             }
             if (amount != null) {
                 data += amount;
             }
             if (pgTxnId != null) {
                 data += pgTxnId;
             }
             if (issuerRefNo != null) {
                 data += issuerRefNo;
             }
             if (authIdCode != null) {
                 data += authIdCode;
             }
             if (firstName != null) {
                 data += firstName;
             }
             if (lastName != null) {
                 data += lastName;
             }
             if (pgRespCode != null) {
                 data += pgRespCode;
             }
             if (zipCode != null) {
                 data += zipCode;
             }
             
             javax.crypto.Mac mac = javax.crypto.Mac.getInstance("HmacSHA1");
             mac.init(new javax.crypto.spec.SecretKeySpec(secret_key.getBytes(), "HmacSHA1"));
             byte[] hexBytes = new org.apache.commons.codec.binary.Hex().encode(mac.doFinal(data.getBytes()));
             String signature = new String(hexBytes, "UTF-8");

             boolean flag = true;
             if (resSignature !=null && !resSignature.equalsIgnoreCase("") 
                 && !signature.equalsIgnoreCase(resSignature)) {
                 flag = false;
             }
             if (flag) {
         %>
                 Your Unique Transaction/Order Id : <%=txnId%><br/>
                 Transaction Status : <%=txnStatus%>
                 
         <% } else { %>
                 <label width="125px;">Citrus Response Signature and Our (Merchant) Signature Mis-Match</label>
         <% } %>

</body>
</html>