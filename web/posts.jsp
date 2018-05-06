<%@page import="dbc.Dbcon"%>
<%@page contentType="text/html; charset=iso-8859-1" language="java" import="java.sql.*" errorPage="" %>
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
<table width="1015" height="438" border="1" align="center">
  <tr>
    <td width="496" height="58"><div align="center">
      <blockquote>
        <p class="style1">POSTS</p>
      </blockquote>
    </div></td>
  </tr>
  <tr>
    <td><table width="1004" height="125" border="1">
      <form action="" method="get">
        <tr>
          <td width="73" height="43">DATE</td>
          <td width="530"><div align="center">POSTS</div></td>
          <td width="193"><div align="center">LINK</div></td>
          <td width="180"><div align="center"></div></td>
        </tr>
      <%
      String pagename=request.getParameter("page");
      try{
             dbc.Dbcon db=new Dbcon();
             Connection c=db.getcon();
             Statement st=c.createStatement();
             
             String str="select * from message where msg_frm='"+pagename+"'";
             ResultSet rs= st.executeQuery(str);
            while(rs.next())
            {
                session.setAttribute("msgdate", rs.getString(3));
                session.setAttribute("msg", rs.getString(5));
                session.setAttribute("stry", rs.getString(6));
                String msgdate=session.getAttribute("msgdate").toString();
                String msg=session.getAttribute("msg").toString();
                String stry=session.getAttribute("stry").toString();
                String[] rr=rs.getString(1).split("_");
      %>
          <tr>
          <td height="74"><%=msgdate%></td>
          <td><%=msg%><br/>
              <%=stry%></td>
              <td><a href="https://www.facebook.com/<%=pagename%>/posts/<%=rr[1]%>">Link</a></td>
          <td><a href="comments.jsp?post_id=<%=rs.getString(1)%>"><input name="select" type="button" value="SELECT" /></a></td>
        </tr>
          <%
            }
            }catch(Exception e){}
          %>
      </form>
    </table></td>
  </tr>
</table>
</body>
</html>
