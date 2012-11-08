<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Error.aspx.cs" Inherits="Error" %>


 <!doctype html >

<head>
   <title>Ooops</title>
  <style>
    html, body, form
    {
        padding:0px;
        margin:0px;
    }
    #error
    {
        color: #F2804B;
	    font-family:  Arial, Helvetica, sans-serif; 
	    font-size: 12px;
	    text-decoration: none;
	    display: block;  
	    padding:20px 40px;     
	    margin:50px;
	    border:1px solid #F2804B;
	    text-align:center;
    }
    
  </style>
</head>
<body>
<form runat="server" id="form1">
<div id="error">
    <p>An error has occured, please try again later or contact us if you continue to see this message.</p>
   </div>

</form>
</body>

</html>


