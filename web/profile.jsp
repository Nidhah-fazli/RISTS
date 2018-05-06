 <%@page import="dbc.Dbcon"%>
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
<script src="SpryAssets/SpryMenuBar.js" type="text/javascript"></script>
<link href="SpryAssets/SpryMenuBarHorizontal.css" rel="stylesheet" type="text/css" />
</head>

<body>
  <%
  response.setHeader("Cache-Control","no-cache");
  response.setHeader("Cache-Control","no-store");
  response.setHeader("Pragma","no-cache");
  response.setDateHeader ("Expires", 0);

  if(session.getAttribute("email")==null)
      response.sendRedirect("login.jsp");

  %>
    <%
    
    String name=session.getAttribute("name").toString();
    String email=session.getAttribute("email").toString();
    
    
    try{
             dbc.Dbcon db=new Dbcon();
             Connection c=db.getcon();
             Statement st=c.createStatement();
             
             String str="select * from userdet where uname='"+name+"' and password='"+email+"'";
             ResultSet rs= st.executeQuery(str);
            
    
    %>
 <form id="form4" name="form4" method="post" action="">
   <table width="354" height="37" border="0" align="right">
     <tr>
       <td width="76"><a href="editprof.jsp">Edit Profile</a></td>
      
       <td width="78"><ul id="MenuBar1" class="MenuBarHorizontal">
         <li><a class="MenuBarItemSubmenu" href="#">Notification</a>
              <%
             if(rs.next())
            {
                String n=rs.getString(4);
            if(n=="y"){
                
            Statement st1=c.createStatement();
             
             String str1="select * from notification where name='welcome'";
             ResultSet rs1= st1.executeQuery(str1);   
           
       %>
           <ul>
             <li><a href="#"><%=rs1.getString(2)%></a></li>
             
           </ul>
           <%}
            }
            }catch(Exception e){}
       %>
         </li>         
       </ul></td>
       
       <td width="111"><a href="#">Send Feedback</a></td>
       <td width="71"><a href="logout.jsp">Logout</a></td>
     </tr>
   </table>
</form>
<tr>
   <td width="164"><p>&nbsp;</p>    
      <table width="371" border="1">
        <tr>
          <td width="160">Name</td>
          <td width="195"><%=name%></td>
        </tr>
        <tr>
          <td>Email</td>
          <td><%=email%></td>
        </tr>
  </table></td>
</tr>
  <p>&nbsp;</p>
<table width="19%" border="0" align="right">
  <tr>
    <td width="57%"><form id="form1" name="form1" method="post" action="">
      <label>
      <input type="submit" name="Submit" value="Search fb Page" />
      </label>
        </form>
    </td>
  </tr>
  <tr>
    <td><form id="form2" name="form2" method="post" action="">
      <label>
      <input type="submit" name="Submit2" value="Compare Brands Posts" />
      </label>
        </form>
    </td>
  </tr>
  <tr>
    <td height="23"><form id="form3" name="form3" method="post" action="">
      <label>
      <input type="submit" name="Submit3" value="Search by Hashtag" />
      </label>
        </form>
    </td>
  </tr>
</table>
<p>&nbsp;</p>
<script type="text/javascript">
var MenuBar1 = new Spry.Widget.MenuBar("MenuBar1", {imgDown:"SpryAssets/SpryMenuBarDownHover.gif", imgRight:"SpryAssets/SpryMenuBarRightHover.gif"});
</script>
</body>
</html>
<%
    if(request.getParameter("Submit")!=null)
{   
     response.sendRedirect("serachfb.jsp");
}
    else if (request.getParameter("Submit2")!=null)
{   
     response.sendRedirect("comparison.jsp");
}
    else if (request.getParameter("Submit3")!=null)
{   
     response.sendRedirect("serachfb.jsp");
}
%>