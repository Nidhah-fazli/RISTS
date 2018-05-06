<%@page import="java.util.ArrayList"%>
<%@page import="javax.swing.table.DefaultTableModel"%>
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
<table width="1022" border="1" align="center">
  <tr>
    <td width="296"><div align="center"><span class="style1">TERM</span></div></td>
    <td width="710"><div align="center"><span class="style1">VECTOR</span></div></td>
  </tr>
  <%
      DefaultTableModel dt1gram= (DefaultTableModel)session.getAttribute("dt1gram");
      DefaultTableModel dt_comment= (DefaultTableModel)session.getAttribute("dt_comment");
      ArrayList words=(ArrayList)session.getAttribute("words");
      String c;
      String c1;
      int v;
      for(int j=0;j < dt_comment.getRowCount() - 1;j++){
          c=(String)dt_comment.getValueAt(j, 0);
      for(int i = 0; i < dt1gram.getRowCount() - 1; i++){
          c1=(String)dt1gram.getValueAt(i, 0);
          String w=(String)dt1gram.getValueAt(i, 1);
          for(int k=0;k<words.size();k++){
          if(words.get(k).equals(w)&& c1==c){
              v=1;
          }
          else{
              v=0;
          }
          

   %>
  <tr>
    <td>&nbsp;<%=w%></td>
    <td>&nbsp;<%=v%></td>
  </tr>
    <%
    }
      }
          }
      }
    %>
</table>
</body>
</html>
