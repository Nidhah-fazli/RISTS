<%--
    Document   : signup
    Created on : Dec 17, 2017, 11:16:56 AM
    Author     : Nowshad
--%>

<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dbc.Dbcon" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <script type="text/javascript">
       function val(){
           if(document.getElementById("name").value==""){
           alert("False entry");
           return false;
       }
           if(document.getElementById("email").value==""){
           alert("False entry");
           return false;
       }
           if(document.getElementById("pass").value==""){
               alert("False entry");
           return false;
           }
           if(document.getElementById("pass1").value==""){
               alert("False entry");
           return false;
           }
               if(document.getElementById("pass").value != document.getElementById("pass1").value){
                   alert("Password confirmation failed");
           return false;
               }
           
           
           
    }
            
       </script>
            
    </head>
    <body>
        <!--A Design by W3layouts
Author: W3layout
Author URL: http://w3layouts.com
License: Creative Commons Attribution 3.0 Unported
License URL: http://creativecommons.org/licenses/by/3.0/
-->
<!DOCTYPE html>
<html lang="en">

<head>
	<title>Classic Enquiry Form a Flat Responsive Widget Template :: w3layouts </title>
	<!-- Meta tags -->
	<meta name="viewport" content="width=device-width, initial-scale=1" />
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="keywords" content="Classic Enquiry Form Responsive Widget, Audio and Video players, Login Form Web Template, Flat Pricing Tables, Flat Drop-Downs, Sign-Up Web Templates, Flat Web Templates, Login Sign-up Responsive Web Template, Smartphone Compatible Web Template, Free Web Designs for Nokia, Samsung, LG, Sony Ericsson, Motorola Web Design"
	/>
	<script type="application/x-javascript">
		addEventListener("load", function() { setTimeout(hideURLbar, 0); }, false); function hideURLbar(){ window.scrollTo(0,1); }
	</script>
	<!-- Meta tags -->
	<!--stylesheets-->
	<link href="css/style.css" rel='stylesheet' type='text/css' media="all">
	<!--//style sheet end here-->
	<!-- font-awesome icons-agile -->
	<link rel="stylesheet" href="css/font-awesome.min.css" />

	<!-- //font-awesome icons-agile -->
	<link href="//fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,600,700" rel="stylesheet">
         <!-- Bootstrap core CSS -->
    <link href="vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom fonts for this template -->
    <link href="vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
    <link href='https://fonts.googleapis.com/css?family=Open+Sans:300italic,400italic,600italic,700italic,800italic,400,300,600,700,800' rel='stylesheet' type='text/css'>
    <link href='https://fonts.googleapis.com/css?family=Merriweather:400,300,300italic,400italic,700,700italic,900,900italic' rel='stylesheet' type='text/css'>

    <!-- Plugin CSS -->
    <link href="vendor/magnific-popup/magnific-popup.css" rel="stylesheet">

    <!-- Custom styles for this template -->
    <link href="css/creative.min.css" rel="stylesheet">
</head>

<body>
    <nav class="navbar navbar-expand-lg navbar-light fixed-top" id="mainNav">
      <div class="container">
        <a class="navbar-brand js-scroll-trigger" href="#page-top">INCRESTS</a>
        <button class="navbar-toggler navbar-toggler-right" type="button" data-toggle="collapse" data-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarResponsive">
          <ul class="navbar-nav ml-auto">
            <li class="nav-item">
              <a class="nav-link js-scroll-trigger" href="index.jsp">Home</a>
            </li>

            <li class="nav-item">
              <a class="nav-link js-scroll-trigger" href="newjsp.jsp">Login</a>
            </li>
            
          </ul>
        </div>
      </div>
    </nav>


	<h1 class="header-w3ls">
		Sign Up</h1>
	<div class="appointment-w3">
		<form action="#" method="post">
				<h2>Enter your registration details.</h2>
                  <div class="line-w3ls"> </div>
				<div class="login-w3ls">
					<div class="icons-agile">
						<span class="fa fa-user" aria-hidden="true"></span>
						<input type="text" name="name" id="name" placeholder="Name" required="">

						<div class="clear"></div>
					</div>
					<div class="icons-agile ">
						<span class="fa fa-envelope" aria-hidden="true"></span>
						<input type="email" name="email" id="email" placeholder="Email" required="">

						<div class="clear"></div>
					</div>
					<div class="icons-agile">
                                     
						<span class="fa fa-keyboard-o" aria-hidden="true"></span>
						<input type="password" name="pass" id="pass" placeholder="Password" required="">

						<div class="clear"></div>
					</div>
                                    <div class="icons-agile">
						<span class="fa fa-keyboard-o" aria-hidden="true"></span>
						<input type="password" name="pass1" id="pass1" placeholder="Confirm Password" required="">

						<div class="clear"></div>
					</div>
					

					
					
					<div class="btnn">
                                            <input type="submit" name="button" onclick="return val()" id="button" value="Submit">
					</div>
				</div>
		</form>
	</div>

	<div class="copy">
		<p>&copy;2017 Classic Enquiry Form. All Rights Reserved | Design by <a href="http://www.W3Layouts.com" target="_blank">W3Layouts</a></p>
	</div>
	<script type='text/javascript' src='js/jquery-2.2.3.min.js'></script>
<script>
	$('#chooseFile').bind('change', function () {
  var filename = $("#chooseFile").val();
  if (/^\s*$/.test(filename)) {
    $(".file-upload").removeClass('active');
    $("#noFile").text("No file chosen..."); 
  }
  else {
    $(".file-upload").addClass('active');
    $("#noFile").text(filename.replace("C:\\fakepath\\", "")); 
  }
});
</script>
</body>

</html>
        </form>
    </body>
</html>
<%
    if(request.getParameter("button")!=null)
    {
        String un=request.getParameter("name");
        String un1=request.getParameter("email");
        String un2=request.getParameter("pass");
        String un3=request.getParameter("pass1");
        try{
            dbc.Dbcon db=new Dbcon();
            Connection c=db.getcon();
            Statement st=c.createStatement();
           
            st.executeUpdate("insert into userdet(uname,email,password,new) values('"+un+"','"+un1+"','"+un2+"','y')");
            response.sendRedirect("login.jsp");
            
            
        }catch (Exception e){
        out.print(e.toString());
        }
    }
%>