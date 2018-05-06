<%@page import="java.util.ArrayList"%>
<%@page import="util.Generator"%>
<%@page import="dbc.Dbcon"%>
<%@page import="javax.swing.table.DefaultTableModel"%>
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
</head>
<%
       
    DefaultTableModel dt1gram = new DefaultTableModel(new String[][]{}, new String[]{"cmnt_id", "word"});
    DefaultTableModel dt2gram = new DefaultTableModel(new String[][]{}, new String[]{"cmnt_id", "word"});
    DefaultTableModel dt3gram = new DefaultTableModel(new String[][]{}, new String[]{"cmnt_id", "word"});
    
    DefaultTableModel dt_comment = new DefaultTableModel(new String[][]{}, new String[]{"cmt_id", "msg_id", "cmt", "date", "time", "vector"});

    ArrayList<String> value = new ArrayList<String>();
    ArrayList<String> words = new ArrayList<String>();
    
    

%>

<%

    Dbcon db = new Dbcon();
    Connection con = db.getcon();
    Statement st = con.createStatement();
    String message_id=session.getAttribute("post").toString();
    ResultSet rs = st.executeQuery("select * from comment where msg_id='" + message_id + "'");
    String comment_no = "";
    while(rs.next())
    {
        comment_no = rs.getString(6);
        String comment_id = rs.getString(1);
        String comment = rs.getString(3);
//        splitting(comment, comment_id);
        ////
        String[] keywords = null; 
        if(comment.length() < 2){
            keywords = new String[1];
            keywords[0] = "";
        }
        else{
            keywords = comment.split("\\s");
        }
        value = new Generator().setKeywords(keywords);

        try
        {    
            Statement st1 = con.createStatement();
            ResultSet nrs = null;
            
            String arr[] = new String[value.size()];
            value.toArray(arr);
            
            //creating one gram
            for(int j = 0; j < arr.length; j++)
            {
                nrs = st1.executeQuery("select * from shrt_text where shrt_txt = '"+arr[j]+"'");
                if(nrs.next())
                {
                    arr[j] = nrs.getString(2); 
                }
                if(!arr[j].equals("")){
                dt1gram.addRow(new String[]{comment_id, arr[j]});
                if (!words.contains(arr[j]))
                    words.add(arr[j]);
                }
            } 
            
            //creating two gram
            dt2gram = new DefaultTableModel(new String[][]{}, new String[]{"cmnt_id", "word"});
            for(int i = 0; i < dt1gram.getRowCount() - 1; i++)
            {
                dt2gram.addRow(new String[]{comment_id, dt1gram.getValueAt(i, 1) + " " + dt1gram.getValueAt(i + 1, 1)});
            }

            //creating three gram
            dt3gram = new DefaultTableModel(new String[][]{}, new String[]{"cmnt_id", "word"});
            for(int i = 0; i < dt1gram.getRowCount() - 2; i++)
            {
                dt3gram.addRow(new String[]{comment_id, dt1gram.getValueAt(i, 1) + " " + dt1gram.getValueAt(i + 1, 1) + " " + dt1gram.getValueAt(i + 2, 1)});
            }
        }
        catch(Exception e)
        {
  
        } 
        ///
        dt_comment.addRow(new String[]{comment_id, message_id, comment, rs.getString(4), rs.getString(5), "vector"});
    }
    session.setAttribute("comment_no", comment_no); 
    String post=session.getAttribute("post").toString();
%>
<body>
<form id="form1" name="form1" method="post" action="bsts.jsp?id="+post">
  <table width="300" border="3" align="center">
    <tr>
      <td><table width="100" border="1">
        <tr>
          <th scope="col">1-Gram Words</th>
        </tr>
        <tr>
          <td>&nbsp;</td>  
        </tr>
        <%        
    if(dt1gram.getRowCount() > 0)
    {
        for(int i = 0; i < dt1gram.getRowCount(); i++)
        {
            if(dt1gram.getValueAt(i, 1)!=null&&!dt1gram.getValueAt(i, 1).equals("")){
        %>
        <tr>
            <td><%= dt1gram.getValueAt(i, 1) %></td>
        </tr>
        <%
        }
        }
    }
        %>
      </table></td>
      <td>&nbsp;</td>
      <td><table width="100" border="1">
        <tr>
          <th scope="col">2-Gram Words</th>
        </tr>
        <tr>
          <td>&nbsp;</td>
        </tr>
        <%        
    if(dt2gram.getRowCount() > 0)
    {
        for(int i = 0; i < dt2gram.getRowCount(); i++)
        {
            if(dt2gram.getValueAt(i, 1)!=null&&!dt2gram.getValueAt(i, 1).equals("")){
        %>
        <tr>
            <td><%= dt2gram.getValueAt(i, 1) %></td>
        </tr>
        <%
            }
        }
    }
        %>
      </table></td>
      <td>&nbsp;</td>
      <td><table width="100" border="1">
        <tr>
          <th scope="col">3-Gram Words</th>
        </tr>
        <tr>
          <td>&nbsp;</td>
        </tr>
        <%        
    if(dt3gram.getRowCount() > 0)
    {
        for(int i = 0; i < dt3gram.getRowCount(); i++)
        {
            String tg=dt3gram.getValueAt(i, 1).toString();
            if(tg!=null&&!tg.equals("")){
        %>
        <tr>
          <td><%= tg %></td>
        </tr>
        <%
            }
        }
    }
        session.setAttribute("dt1gram", dt1gram); 
        session.setAttribute("dt2gram", dt2gram); 
        session.setAttribute("dt3gram", dt3gram); 
        
        session.setAttribute("words", words);
        session.setAttribute("dt_comment", dt_comment);
        
        dt1gram = null;
        dt2gram = null;
        dt3gram = null;
        
        %>
      </table></td>
    </tr>
    <tr>
      <td colspan="5">&nbsp;</td>
    </tr>
    <tr>
    	<td colspan="5"><div align="center">
    	  <input type="submit" name="button" id="button" value="     Comment Vector     " />
    	</div></td>
    </tr>
  </table>
</form>
</body>
</html>
