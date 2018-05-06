<%@page import="java.util.Arrays"%>
<%@page import="dbc.Dbcon"%>
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
</style>
</head>

<body>
    <form id="form1" name="form1" method="get" action="bcomments.jsp">
  <table width="1055" border="1" align="center">
    <tr>
      <td width="531"><div align="center" class="style1">BRAND1</div></td>
      <td width="508"><div align="center"><span class="style1">BRAND2</span></div></td>
    </tr>
    <tr>
        <%
            String first=session.getAttribute("first").toString();
            String second=session.getAttribute("second").toString();
        %>
      <td height="75"><table width="508" border="0">
        <tr>
          <td width="80">DATE</td>
          <td width="230">POSTS</td>
          <td width="123">LINK</td>
          <td width="70">SELECT</td>
        </tr>
        
               <%
    try{
             dbc.Dbcon db=new Dbcon();
             Connection c=db.getcon();
             Statement st=c.createStatement();
             String str="select * from message where msg_frm='"+first+"'";
             ResultSet rs= st.executeQuery(str);
            while(rs.next()){
                session.setAttribute("msgdate", rs.getString(3));
                session.setAttribute("msg", rs.getString(5));
                session.setAttribute("stry", rs.getString(6));
                session.setAttribute("msgid", rs.getString(1));
                String msgdate=session.getAttribute("msgdate").toString();
                String msg=session.getAttribute("msg").toString();
                String stry=session.getAttribute("stry").toString();
                String one=session.getAttribute("msgid").toString();
                String[] rr=rs.getString(1).split("_");
                
    %>
        <tr>
          <td><%=msgdate%></td>
          <td><%=msg%><br/><%=stry%></td>
          <td><a href="https://www.facebook.com/<%=first%>/posts/<%=rr[1]%>">Link</a></td>
          <td><label>
            <div align="center">
                <input type="radio" name="radio" value=<%=one%> />
              </div>
          </label></td>
        </tr>
          <%
            }
            }catch(Exception e){}
        %>
        
              </table> </td>
          
      <td><table width="508" border="0">
        <tr>
          <td width="69">DATE</td>
          <td width="236">POSTS</td>
          <td width="99">LINK</td>
          <td width="64">SELECT</td>
        </tr>
               <%
            try{
                dbc.Dbcon db=new Dbcon();
                Connection c=db.getcon();
                Statement st=c.createStatement();
                String str1="select * from message where msg_frm='"+second+"'";
                ResultSet rs1= st.executeQuery(str1);
            while(rs1.next()){
                session.setAttribute("msgdate1", rs1.getString(3));
                session.setAttribute("msg1", rs1.getString(5));
                session.setAttribute("stry1", rs1.getString(6));
                session.setAttribute("msgid1", rs1.getString(1));
                String msgdate1=session.getAttribute("msgdate1").toString();
                String msg1=session.getAttribute("msg1").toString();
                String stry1=session.getAttribute("stry1").toString();
                String two=session.getAttribute("msgid1").toString();
                String[] rr1=rs1.getString(1).split("_");
              %>
        <tr>
          <td><%=msgdate1%></td>
          <td><%=msg1%><br/><%=stry1%></td>
          <td><a href="https://www.facebook.com/<%=second%>/posts/<%=rr1[1]%>">Link</a></td>
          <td><label>
            <div align="center">
              <input type="radio" name="radio1" value="<%=two%>" />
              </div>
          </label></td>
        </tr>
           <%
            }
            }catch(Exception e){}
        %>
        
              </table></td>
    </tr>
  </table>
     
  <div align="center">
      <input type="submit" name="nextn" value="GET COMMENTS OF SELECTED POSTS" />
  </div>
</form>
</body>
</html>
  <%
if(request.getParameter("nextn")!=null){
    
         if(request.getParameter("radio")!=null && request.getParameter("radio1")!= null){
        String checked;
        String checked1;
        checked=request.getParameter("radio");
        checked1=request.getParameter("radio1");
        session.setAttribute("one", checked);
        session.setAttribute("two", checked1); 
        }
         
        response.sendRedirect("bcomments.jsp");
   
}
%>