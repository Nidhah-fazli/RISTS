<%@page import="java.io.FileOutputStream"%>
<%@page import="java.io.File"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.lang.String"%>
<%@page import="dbc.Dbcon"%>
<%@page import="java.util.ArrayList"%>
<%@page import="javax.swing.table.DefaultTableModel"%>
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
</head>

<%

    DefaultTableModel dt1gram = (DefaultTableModel) session.getAttribute("dt1gram");
    DefaultTableModel dt_comment = (DefaultTableModel) session.getAttribute("dt_comment");
    ArrayList<String> words = (ArrayList<String>) session.getAttribute("words");
    String message_id=session.getAttribute("post").toString();
        
    int ncomments = dt_comment.getRowCount();
    int cngrams = dt1gram.getRowCount();
    int nwords = words.size();
    int[][] vect = new int[ncomments][nwords]; // term vector(2D matrix)
    
    //creating termvector
    for (int i = 0; i < ncomments; i++)
    {
        String str = "";
        String cmid = dt_comment.getValueAt(i, 0).toString();
        for (int j = 0; j < nwords; j++)
        {
            for(int k = 0; k < cngrams; k++)
            {
                if(dt1gram.getValueAt(k, 0).toString().equals(cmid) && dt1gram.getValueAt(k, 1).toString().equals(words.get(j)))
                {
                    vect[i][j] = 1;
                }
            }
            str += vect[i][j] + ",";
        }

        dt_comment.setValueAt(str, i, 5);
        session.setAttribute("vector", vect); 
    }

%>    
    
<body>
    <div style="overflow-x: scroll">
<form id="form1" name="form1" method="post" action="bsts_result.jsp?id=<%= message_id %>">
  <table width="500" border="1" align="center">
    <tr>
      <th scope="col">Comment</th>
      <th scope="col">Term Vector</th>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
        <%        
    if(dt_comment.getRowCount() > 0)
    {
        for(int i = 0; i < dt_comment.getRowCount(); i++)
        {
        %>
    <tr>
      <td><%= dt_comment.getValueAt(i, 2) %></td>
      <td><%= dt_comment.getValueAt(i, 5) %></td>
    </tr>
        <%
        }
    }
        %>
    <tr>
      <td height="23" colspan="2">
        <input type="submit" name="button" id="button" value="     Batch STS     " />
      </td>
    </tr>
  </table>
</form>
    </div>
</body>
</html>
