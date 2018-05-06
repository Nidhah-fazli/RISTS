<%@page import="util.Stopwords"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.Collections"%>
<%@page import="util.ClusterManager"%>
<%@page import="util.Generator"%>
<%@page import="dbc.Dbcon"%>
<%@page import="java.util.ArrayList"%>
<%@page import="javax.swing.table.DefaultTableModel"%>
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
<style type="text/css">
.NEW {
	text-align: center;
}
.NEW {
	text-align: center;
	font-size: 36px;
}
</style>
</head>
<%
    DefaultTableModel dt1gram = new DefaultTableModel(new String[][]{}, new String[]{"cmnt_id", "word"});
    DefaultTableModel dt2gram = new DefaultTableModel(new String[][]{}, new String[]{"cmnt_id", "word"});
    DefaultTableModel dt3gram = new DefaultTableModel(new String[][]{}, new String[]{"cmnt_id", "word"});
    
    DefaultTableModel dt_comment = new DefaultTableModel(new String[][]{}, new String[]{"cmt_id", "msg_id", "cmt", "date", "time", "vector"});

    ArrayList<String> value = new ArrayList<String>();
    ArrayList<String> words = new ArrayList<String>();
    
    String one=session.getAttribute("one").toString();
%>

<%
    
    //+++++++NGRAMS++++++
    dbc.Dbcon db=new Dbcon();
    Connection c=db.getcon();
    Statement st=c.createStatement();
    Statement st2 = c.createStatement();    
    ResultSet rs = st.executeQuery("select * from comment where msg_id='" + one + "'");
    String comment_no = "";
    
     while(rs.next())
    {
        comment_no = rs.getString(6);
        String comment_id = rs.getString(1);
        String comment = rs.getString(3);
        //splitting(comment, comment_id);
        //////////////////
        
        
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
            ResultSet nrs = null;
            
            String arr[] = new String[value.size()];
            value.toArray(arr);
            
            //creating one gram
            for(int j = 0; j < arr.length; j++)
            {
                nrs = st2.executeQuery("select * from shrt_text where shrt_txt = '"+arr[j]+"'");
                if(nrs.next())
                {
                    arr[j] = nrs.getString(2); 
                }
                if(!arr[j].equals("")&&arr[j]!=null){
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
        
        //////////////////
        dt_comment.addRow(new String[]{comment_id, one, comment, rs.getString(4), rs.getString(5), "vector"});
    }
    session.setAttribute("comment_no", comment_no); 

%>

<%
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

<%!
   

    public float sim(int[] a, int[] b)
    {
        float sum = 0, k = 0;
        for (int i = 0; i < a.length; i++)
        {
            k += a[i];
            sum += a[i] * b[i];
        }
        return sum / k;
    }

 
%>


<%
    int[][] vector = (int[][]) session.getAttribute("vector");
    int[] cluster_center = new int[nwords];
    double fvc = 0;
    
    DefaultTableModel dt_cluster = new DefaultTableModel(null, new String[]{"cluster_id", "elements"});
    
    ClusterManager clmngr = new ClusterManager();
    clmngr.clusters((Object)one);
    
    int cluster_id = clmngr.getclstrid();
    ArrayList<int[]> ccs = new ArrayList<int[]>();
    ArrayList<Integer> cids = new ArrayList<Integer>();
        
    if(dt_comment.getRowCount() > 0)
    {
        dt_cluster.addRow(new String[]{Integer.toString(cluster_id), dt_comment.getValueAt(0, 0).toString()}); 
        String ccenter = "";
        for (int i = 0; i < nwords; i++)
        {
            cluster_center[i] = vector[0][i];
            ccenter += vector[0][i] + ",";
        }
        ccs.add(cluster_center);
        cids.add(cluster_id);
        clmngr.insertcluster(cluster_id, one, ccenter);
        clmngr.insertelements(cluster_id, dt_comment.getValueAt(0, 0).toString(), 1); 
        
        for(int ix = 1; ix < ncomments; ix++)
        {
            int flag = 0;
            ArrayList<int[]> templist = new ArrayList<int[]>();
            
            for (Object str : ccs) {
               templist.add((int[])str);
            }
            
            int index = -1;
            ArrayList<Double> simlist = new ArrayList<Double>();

            for (int[] clust_c : templist)
            {
                index++;
                fvc = 0; 
                double tw = 0, cw= 0;

                cluster_id = templist.indexOf(clust_c);
                cluster_id = cids.get(cluster_id);

                for (int n = 0; n < nwords; n++)
                {   
                    tw += (double)vector[ix][n];

                    double temp = (double)vector[ix][n] * (double)clust_c[n];
                    cw += temp;
                }

                double sima = cw /tw;
                simlist.add(sima);
            }

            double smax = Collections.max(simlist);
            int simmax = simlist.indexOf(smax);

            if (simmax >= .5d)
            {
                flag = 1;
                ccenter="";
                for (int ii = 0; ii < nwords; ii++)
                {
                    ccs.get(simmax)[ii] = ccs.get(simmax)[ii] | vector[ix][ii];
                    ccenter += ccs.get(simmax)[ii] + ",";
                }
                clmngr.insertelements(cids.get(simmax), dt_comment.getValueAt(ix, 0).toString(), smax); 
                clmngr.updatecluster(cluster_id, ccenter);
                dt_cluster.addRow(new String[]{Integer.toString(cluster_id), dt_comment.getValueAt(ix, 0).toString()});
            }

            if (flag == 0)
            {
                cluster_id = clmngr.getclstrid();
                cids.add(cluster_id);
                int[] newccenter = new int[nwords];
                ccenter = "";
                for (int ii = 0; ii < nwords; ii++)
                {
                    newccenter[ii] = vector[ix][ii];
                    ccenter += vector[ix][ii] + ",";
                }
                clmngr.insertcluster(cluster_id, one, ccenter);
                clmngr.insertelements(cluster_id, dt_comment.getValueAt(ix, 0).toString(), 1);    

                ccs.add(newccenter);
                dt_cluster.addRow(new String[]{Integer.toString(cluster_id), dt_comment.getValueAt(ix, 0).toString()}); 

            }
        }
        int ind = 1;

        for (ind = cids.get(0); ind < ccs.size(); ind++)
        {
            int flag = 1;

            for (int ind1 = ind + 1; ind1 < ccs.size(); ind1++)
            {
                double sima = sim(ccs.get(ind),ccs.get(ind1));

                if (sima > .5d)
                {  
                    flag = 1;
                    ccenter="";
                    for (int ii = 0; ii < nwords; ii++)
                    {
                        ccs.get(ind)[ii] = ccs.get(ind)[ii] | ccs.get(ind1)[ ii];
                        ccenter += ccs.get(ind)[ii] + ",";
                    }
//                    System.out.println("ind : "+ind+" ind1 : "+ind1);
                    clmngr.updatecluster(cids.get(ind), cids.get(ind1), ccenter); 
                }
            }
        }   
        dt_cluster = clmngr.clusters(one);
    }


%>

<%
    DefaultTableModel dtsumm = new DefaultTableModel(null, new String[]{"comments", "term", "clid", "count"});
    DefaultTableModel dtsummary = new DefaultTableModel(null, new String[]{"comments", "term", "clid", "count"});
    
    
    
    String[] wordarray;
    
    Statement st1 = c.createStatement();
    
    try
    {
        String qry = "select * from bsts_sum where msg_id = '" + one + "'";
        ResultSet rs1 = st1.executeQuery(qry);
        while(rs1.next())
        {
            wordarray = rs1.getString(3).split(",");
        }
        rs1.close();

        dtsummary = dtsumm;
        ArrayList<String> cid = new ArrayList<String>();

        String[] dtcls = null;
        qry = "select count(distinct cluster_id) from clusters where msg_id='" + one + "'";
        ResultSet dt = st.executeQuery(qry);
        if(dt.next())
        {
            dtcls = new String[dt.getInt(1)];
        }
        dt.close();

        qry = "select distinct cluster_id,cluster_center from clusters where msg_id='" + one + "'";
        ResultSet dts = st.executeQuery(qry);
        int dx = 0;
        while(dts.next())
        {
            dtcls[dx] = dts.getString(1);
            dx++;
        }
        dts.close();

    //    session.setAttribute("dt", dt);

        for(int dy = 0; dy < dtcls.length; dy++)
        { 
            String cluster_id1 = dtcls[dy];
            ResultSet ctcm = st.executeQuery("select count(distinct comment.cmt_id) from comment inner join cluster_elements on comment.cmt_id=cluster_elements.cmt_id where cluster_id='" + cluster_id1 + "'");
            int ctcnt = 0;
            if(ctcm.next())
            {
                ctcnt = ctcm.getInt(1);
            }
            ctcm.close();

            if(ctcnt > 0)
            {
                Statement stm = c.createStatement();
                ResultSet ctc = stm.executeQuery("select distinct cmt,comment.cmt_id from comment inner join cluster_elements on comment.cmt_id=cluster_elements.cmt_id where cluster_id='" + cluster_id1 + "'"); 

                String comm = "", cmnt = ""; 
                int cnt = 3;
                
                ctc.last();
                ctcnt = ctc.getRow();
                ctc.first();
                
                while(ctc.next()) 
                {
                    if(comm.length()<1000){
                        comm += "<ul> ";
                        cmnt += ctc.getString(1) + " ";
                        comm += " <li>" + ctc.getString(1) + " </li>";
                        comm += " </ul>";
                    }
                    
                }
                ctc.close();

                ArrayList<String> wc = new ArrayList<String>();
//                summ.clear();

                String[] wcarr = cmnt.split(" ");
                wc.addAll(Arrays.asList(wcarr));

                ArrayList<String> sumel = new ArrayList<String>();

                Statement stmt = c.createStatement();
                ResultSet ct = stmt.executeQuery("select distinct cmt,comment.cmt_id from comment inner join cluster_elements on comment.cmt_id=cluster_elements.cmt_id where cluster_id='" + cluster_id1 + "'"); 
                while(ct.next())
                {
                    sumel.clear();
                    for(int i = 0; i < dt1gram.getRowCount(); i++)
                    {
                        if(dt1gram.getValueAt(i, 0).toString().equals(ct.getString(2)))
                        {
                            sumel.add(dt1gram.getValueAt(i, 1).toString());
                        }
                    }
                    for(int i = 0; i < dt2gram.getRowCount(); i++)
                    {
                        if(dt2gram.getValueAt(i, 0).toString().equals(ct.getString(2)))
                        {
                            sumel.add(dt2gram.getValueAt(i, 1).toString());
                        }
                    }
                    for(int i = 0; i < dt3gram.getRowCount(); i++)
                    {
                        if(dt3gram.getValueAt(i, 0).toString().equals(ct.getString(2)))
                        {
                            sumel.add(dt3gram.getValueAt(i, 1).toString());
                        }
                    }
    //                summ.add(ct.getString(2));
                }
                ct.close();

                String elm = "";
                ArrayList<String> uniq = new ArrayList<String>();

                if (cmnt.trim().length() > 5)
                {
                    if (elm.length() < 3)
                    {
                        String[] stt = cmnt.split(" ");
                        int cntx = 0;
                        cntx = stt.length;
                        //string stpwrd;
                        int ip = 0;
                        for (int ix = 0; ix < cntx; ix++)
                        {
                            if (!elm.toLowerCase().contains(stt[ix].toLowerCase()))
                            {
                                if (!new Stopwords().stpwrd(stt[ix]))//if (!new TermPreprocessor().removeStopWords(stt[ix]).equals(null))
                                {
                                    if (ip == ix - 1)
                                        elm = elm.replace(",", " ") + " ";
                                    elm += stt[ix].replace("?", " ") + ",";
                                    ip = ix;
                                }
                            }
                        }
                    }

                    dtsummary.addRow(new String[]{comm.replace("?", " "), elm.replace(",", " "), cluster_id1, Integer.toString(ctcnt)}); 
                }
            }
        }
    }
    catch(Exception ex)
    {
        System.err.println(ex);
    }

%>




<body>
<table width="1036" height="102" border="1" align="center">
  <tr>
    <td height="53" class="NEW">BRAND 1'S SUMMARY</td>
    <td class="NEW">BRAND 2'S SUMMARY</td>
  </tr>
     <%        
    if(dtsummary.getRowCount() > 0)
    {
        for(int i = 0; i < dtsummary.getRowCount(); i++)
        {
        %>
  <tr>
      <td><%= dtsummary.getValueAt(i, 1) %></td>
    <td>&nbsp;</td>
    
    <td>&nbsp;</td>
  </tr>
    <%
        }
    }
    %>
</table>
</body>
</html>