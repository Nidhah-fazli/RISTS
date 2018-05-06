<%@page import="dbc.Dbcon"%>
<%@page import="fb_data.FaceBookPageDetails"%>
<%@ page contentType="text/html; charset=iso-8859-1" language="java" import="java.sql.*" errorPage="" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Untitled Document</title>
<style type="text/css">
<!--
.style1 {font-size: 24px}
-->
</style></head>

<body>
<table width="1037" height="173" border="1">
  <tr>
    <td width="738" height="62"><div align="center"><span class="style1">COMMENTS</span></div></td>
    <td width="145"><div align="center">DATE</div></td>
    <td width="132"><div align="center">TIME</div></td>
  </tr>
    <%
    String acc=session.getAttribute("acc").toString();
    String post=request.getParameter("post_id");
    FaceBookPageDetails fb=new FaceBookPageDetails();
    fb.readComments(acc, post);
    try{
             dbc.Dbcon db=new Dbcon();
             Connection c=db.getcon();
             Statement st=c.createStatement();
             session.setAttribute("post", post);
             String str="select * from comment where msg_id='"+post+"'";
             ResultSet rs= st.executeQuery(str);
            while(rs.next())
            {
                session.setAttribute("cmt", rs.getString(3));
                session.setAttribute("date", rs.getString(4));
                session.setAttribute("time", rs.getString(5));
                String cmt=session.getAttribute("cmt").toString();
                String date=session.getAttribute("date").toString();
                String time=session.getAttribute("time").toString();
    %>
  <tr>
    <td height="103"><%=cmt%></td>
    <td><%=date%></td>
    <td><%=time%></td>
  </tr>
  <%
            }
            }catch(Exception e){}
          %>
</table>
<form id="form1" name="form1" method="post" action="">
  <label>
  <div align="center">
    <input type="submit" name="Submit" value="GET NGRAMS" />
  </div>
  </label>
</form>
</body>
</html>
<%
if(request.getParameter("Submit")!=null){
     response.sendRedirect("ngrams.jsp?id="+post);
}
%>