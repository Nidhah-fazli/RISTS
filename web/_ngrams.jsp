<%@page import="dbc.Dbcon"%>
<%@ page contentType="text/html; charset=iso-8859-1" language="java" import="java.sql.*" errorPage="" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Untitled Document</title>
<style type="text/css">
<!--
.style1 {font-size: 36px}
-->
</style>
</head>

<body>
<table width="1034" height="191" border="1" align="center">
  <tr>
    <td height="103"><div align="center" class="style1">n grams </div></td>
  </tr>
    <%
        String postid=session.getAttribute("post").toString();
        try{
             dbc.Dbcon db=new Dbcon();
             Connection c=db.getcon();
             Statement st=c.createStatement();
             String str="select * from comment where msg_id='"+postid+"'";
             ResultSet rs= st.executeQuery(str);
            while(rs.next())
            {
                
                String[] rr=rs.getString(3).split(" ");
                for(int i=0;i<rr.length;i++){
                    rr[i]=rr[i].replaceAll(".","");
                    
                    
                    
                
    %>
  <tr>
      <td><%=rr[i]%></td>
   
    <%
    }
                             
    %>
  </tr>
  <%
                     
            
            }
            }catch(Exception e){}
            
  %>
</table>
</body>
</html>
