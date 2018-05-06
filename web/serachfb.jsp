<%@page import="fb_data.FaceBookPageDetails"%>
<%@ page contentType="text/html; charset=iso-8859-1" language="java" import="java.sql.*" errorPage="" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Untitled Document</title>
</head>

<body>
<form id="form1" name="form1" method="post" action="">
<table width="573" border="1">
  <tr>
    <td width="257">Search fb Page </td>
    <td width="300">
      <label></label>
        
      <input name="pagename" type="text" size="50" /></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>
      <label>
        <input type="submit" name="search" value="Search" />
        </label>    </td>
  </tr>
</table>
</form>
</body>
</html>
<%
    if(request.getParameter("search")!=null){
        String pn=request.getParameter("pagename");
        try {
            FaceBookPageDetails fb=new FaceBookPageDetails();
            String acc=fb.getAccessToken();
            session.setAttribute("acc", acc);
            fb.readPosts(acc, pn);
            response.sendRedirect("posts.jsp?page="+pn);
              
        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }
%>
