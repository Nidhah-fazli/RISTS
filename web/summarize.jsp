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
.NE {
	text-align: center;
}
</style>
</head>
    <%
    //for first post
       
    DefaultTableModel dt1gram = new DefaultTableModel(new String[][]{}, new String[]{"cmnt_id", "word"});
    DefaultTableModel dt2gram = new DefaultTableModel(new String[][]{}, new String[]{"cmnt_id", "word"});
    DefaultTableModel dt3gram = new DefaultTableModel(new String[][]{}, new String[]{"cmnt_id", "word"});
    
    DefaultTableModel dt_comment = new DefaultTableModel(new String[][]{}, new String[]{"cmt_id", "msg_id", "cmt", "date", "time", "vector"});
    
    //for second post
    
    DefaultTableModel dt1gram2 = new DefaultTableModel(new String[][]{}, new String[]{"cmnt_id", "word"});
    DefaultTableModel dt2gram2 = new DefaultTableModel(new String[][]{}, new String[]{"cmnt_id", "word"});
    DefaultTableModel dt3gram2 = new DefaultTableModel(new String[][]{}, new String[]{"cmnt_id", "word"});
    
    DefaultTableModel dt_comment2 = new DefaultTableModel(new String[][]{}, new String[]{"cmt_id", "msg_id", "cmt", "date", "time", "vector"});

    ArrayList<String> value = new ArrayList<String>();
    ArrayList<String> words = new ArrayList<String>();
    
    ArrayList<String> value1 = new ArrayList<String>();
    ArrayList<String> words1 = new ArrayList<String>();
    
    String one=session.getAttribute("one").toString();
    String two=session.getAttribute("two").toString();
    
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
    
    Statement st3=c.createStatement();
    Statement st4 = c.createStatement();    
    ResultSet rs1 = st3.executeQuery("select * from comment where msg_id='" + two + "'");
    String comment_no1 = "";
    while(rs1.next())
    {
        comment_no1 = rs1.getString(6);
        String comment_id1 = rs1.getString(1);
        String comment1 = rs1.getString(3);
        //splitting(comment, comment_id);
        //////////////////
        
        
        String[] keywords1 = null; 
        if(comment1.length() < 2){
            keywords1 = new String[1];
            keywords1[0] = "";
        }
        else{
            keywords1 = comment1.split("\\s");
        }
        value1 = new Generator().setKeywords(keywords1);

        try
        {    
            ResultSet nrs1 = null;
            
            String arr1[] = new String[value1.size()];
            value1.toArray(arr1);
            
            //creating one gram
            for(int j = 0; j < arr1.length; j++)
            {
                nrs1 = st4.executeQuery("select * from shrt_text where shrt_txt = '"+arr1[j]+"'");
                if(nrs1.next())
                {
                    arr1[j] = nrs1.getString(2); 
                }
                if(!arr1[j].equals("")&&arr1[j]!=null){
                dt1gram2.addRow(new String[]{comment_id1, arr1[j]});
                if (!words1.contains(arr1[j]))
                    words1.add(arr1[j]);
                }
            } 
            
            //creating two gram
            dt2gram2 = new DefaultTableModel(new String[][]{}, new String[]{"cmnt_id", "word"});
            for(int i = 0; i < dt1gram2.getRowCount() - 1; i++)
            {
                dt2gram2.addRow(new String[]{comment_id1, dt1gram2.getValueAt(i, 1) + " " + dt1gram2.getValueAt(i + 1, 1)});
            }

            //creating three gram
            dt3gram2 = new DefaultTableModel(new String[][]{}, new String[]{"cmnt_id", "word"});
            for(int i = 0; i < dt1gram2.getRowCount() - 2; i++)
            {
                dt3gram2.addRow(new String[]{comment_id1, dt1gram2.getValueAt(i, 1) + " " + dt1gram2.getValueAt(i + 1, 1) + " " + dt1gram2.getValueAt(i + 2, 1)});
            }
        }
        catch(Exception e)
        {
  
        }    
        
        //////////////////
        dt_comment2.addRow(new String[]{comment_id1, two, comment1, rs1.getString(4), rs1.getString(5), "vector"});
    }
    session.setAttribute("comment_no", comment_no1); 
    
%>
<%
        //+++++++TERMVECTORS++++++

    int ncomments = dt_comment.getRowCount();
    int cngrams = dt1gram.getRowCount();
    int nwords = words.size();
    int[][] vect = new int[ncomments][nwords]; // term vector(2D matrix)
    
    int ncomments1 = dt_comment2.getRowCount();
    int cngrams1 = dt1gram2.getRowCount();
    int nwords1 = words1.size();
    int[][] vect1 = new int[ncomments1][nwords1]; // term vector(2D matrix)
    
    //creating termvector for first post
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
    
    //creating termvector for second post
    for (int i = 0; i < ncomments1; i++)
    {
        String str1 = "";
        String cmid1 = dt_comment2.getValueAt(i, 0).toString();
        for (int j = 0; j < nwords1; j++)
        {
            for(int k = 0; k < cngrams1; k++)
            {
                if(dt1gram2.getValueAt(k, 0).toString().equals(cmid1) && dt1gram2.getValueAt(k, 1).toString().equals(words1.get(j)))
                {
                    vect1[i][j] = 1;
                }
            }
            str1 += vect1[i][j] + ",";
        }

        dt_comment2.setValueAt(str1, i, 5);
        session.setAttribute("vector1", vect1); 
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
    
     public float sim1(int[] a, int[] b)
    {
        float sum1 = 0, k1 = 0;
        for (int i = 0; i < a.length; i++)
        {
            k1 += a[i];
            sum1 += a[i] * b[i];
        }
        return sum1 / k1;
    }
%>
<%
    int[][] vector = (int[][]) session.getAttribute("vector");
    int[][] vector1 = (int[][]) session.getAttribute("vector1");
    
    
    int[] cluster_center = new int[nwords];
    double fvc = 0;
    
    int[] cluster_center1 = new int[nwords1];
    double fvc1 = 0;
    
    
    DefaultTableModel dt_cluster = new DefaultTableModel(null, new String[]{"cluster_id", "elements"});
    
    DefaultTableModel dt_cluster2 = new DefaultTableModel(null, new String[]{"cluster_id", "elements"});
    
    
    ClusterManager clmngr = new ClusterManager();
    clmngr.clusters((Object)one);
    ClusterManager clmngr1 = new ClusterManager();
    clmngr1.clusters((Object)two);
    
    int cluster_id = clmngr.getclstrid();
    int cluster_id1 = clmngr1.getclstrid();
    
    ArrayList<int[]> ccs = new ArrayList<int[]>();
    ArrayList<Integer> cids = new ArrayList<Integer>();
    
    ArrayList<int[]> ccs1 = new ArrayList<int[]>();
    ArrayList<Integer> cids1 = new ArrayList<Integer>();
        
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

    if(dt_comment2.getRowCount() > 0)
    {
        dt_cluster2.addRow(new String[]{Integer.toString(cluster_id1), dt_comment2.getValueAt(0, 0).toString()}); 
        String ccenter1 = "";
        for (int i = 0; i < nwords1; i++)
        {
            cluster_center1[i] = vector1[0][i];
            ccenter1 += vector1[0][i] + ",";
        }
        ccs1.add(cluster_center1);
        cids1.add(cluster_id1);
        clmngr1.insertcluster(cluster_id1, two, ccenter1);
        clmngr1.insertelements(cluster_id1, dt_comment2.getValueAt(0, 0).toString(), 1); 
        
        for(int ix = 1; ix < ncomments1; ix++)
        {
            int flag1 = 0;
            ArrayList<int[]> templist1 = new ArrayList<int[]>();
            
            for (Object str1 : ccs1) {
               templist1.add((int[])str1);
            }
            
            int index1 = -1;
            ArrayList<Double> simlist1 = new ArrayList<Double>();

            for (int[] clust_c1 : templist1)
            {
                index1++;
                fvc1 = 0; 
                double tw1 = 0, cw1= 0;

                cluster_id1 = templist1.indexOf(clust_c1);
                cluster_id1 = cids1.get(cluster_id1);

                for (int n1 = 0; n1 < nwords1; n1++)
                {   
                    tw1 += (double)vector[ix][n1];

                    double temp1 = (double)vector[ix][n1] * (double)clust_c1[n1];
                    cw1 += temp1;
                }

                double sima1 = cw1 /tw1;
                simlist1.add(sima1);
            }

            double smax1 = Collections.max(simlist1);
            int simmax1 = simlist1.indexOf(smax1);

            if (simmax1 >= .5d)
            {
                flag1 = 1;
                ccenter1="";
                for (int ii = 0; ii < nwords1; ii++)
                {
                    ccs1.get(simmax1)[ii] = ccs1.get(simmax1)[ii] | vector1[ix][ii];
                    ccenter1 += ccs1.get(simmax1)[ii] + ",";
                }
                clmngr1.insertelements(cids1.get(simmax1), dt_comment2.getValueAt(ix, 0).toString(), smax1); 
                clmngr1.updatecluster(cluster_id1, ccenter1);
                dt_cluster2.addRow(new String[]{Integer.toString(cluster_id1), dt_comment2.getValueAt(ix, 0).toString()});
            }

            if (flag1 == 0)
            {
                cluster_id1 = clmngr1.getclstrid();
                cids1.add(cluster_id1);
                int[] newccenter1 = new int[nwords1];
                ccenter1 = "";
                for (int ii = 0; ii < nwords1; ii++)
                {
                    newccenter1[ii] = vector1[ix][ii];
                    ccenter1 += vector1[ix][ii] + ",";
                }
                clmngr1.insertcluster(cluster_id1, two, ccenter1);
                clmngr1.insertelements(cluster_id1, dt_comment2.getValueAt(ix, 0).toString(), 1);    

                ccs1.add(newccenter1);
                dt_cluster2.addRow(new String[]{Integer.toString(cluster_id1), dt_comment2.getValueAt(ix, 0).toString()}); 

            }
        }
        int ind1 = 1;

        for (ind1 = cids1.get(0); ind1 < ccs1.size(); ind1++)
        {
            int flag1 = 1;

            for (int ind2 = ind1 + 1; ind2 < ccs1.size(); ind2++)
            {
                double sima1 = sim1(ccs1.get(ind1),ccs1.get(ind2));

                if (sima1 > .5d)
                {  
                    flag1 = 1;
                    ccenter1="";
                    for (int ii = 0; ii < nwords1; ii++)
                    {
                        ccs1.get(ind1)[ii] = ccs1.get(ind1)[ii] | ccs1.get(ind2)[ ii];
                        ccenter1 += ccs1.get(ind1)[ii] + ",";
                    }
//                    System.out.println("ind : "+ind+" ind1 : "+ind1);
                    clmngr1.updatecluster(cids1.get(ind1), cids1.get(ind2), ccenter1); 
                }
            }
        }   
        dt_cluster2 = clmngr1.clusters(two);
    }

%>
<%
    DefaultTableModel dtsumm = new DefaultTableModel(null, new String[]{"comments", "term", "clid", "count"});
    DefaultTableModel dtsummary = new DefaultTableModel(null, new String[]{"comments", "term", "clid", "count"});
    
    String[] wordarray;
    
    DefaultTableModel dtsumm2 = new DefaultTableModel(null, new String[]{"comments", "term", "clid", "count"});
    DefaultTableModel dtsummary2 = new DefaultTableModel(null, new String[]{"comments", "term", "clid", "count"});
    
    String[] wordarray1;

    
    Statement st5=c.createStatement();
    
    try
    {
        String qry = "select * from bsts_sum where msg_id = '" + one + "'";
        ResultSet rs3 = st5.executeQuery(qry);
        while(rs3.next())
        {
            wordarray = rs3.getString(3).split(",");
        }
        rs3.close();

        dtsummary = dtsumm;
        ArrayList<String> cid = new ArrayList<String>();

        String[] dtcls = null;
        qry = "select count(distinct cluster_id) from clusters where msg_id='" + one + "'";
        ResultSet dt = st5.executeQuery(qry);
        if(dt.next())
        {
            dtcls = new String[dt.getInt(1)];
        }
        dt.close();

        qry = "select distinct cluster_id,cluster_center from clusters where msg_id='" + one + "'";
        ResultSet dts = st5.executeQuery(qry);
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
            String cluster_id2 = dtcls[dy];
            ResultSet ctcm = st.executeQuery("select count(distinct comment.cmt_id) from comment inner join cluster_elements on comment.cmt_id=cluster_elements.cmt_id where cluster_id='" + cluster_id2 + "'");
            int ctcnt = 0;
            if(ctcm.next())
            {
                ctcnt = ctcm.getInt(1);
            }
            ctcm.close();

            if(ctcnt > 0)
            {
                Statement stm = c.createStatement();
                ResultSet ctc = stm.executeQuery("select distinct cmt,comment.cmt_id from comment inner join cluster_elements on comment.cmt_id=cluster_elements.cmt_id where cluster_id='" + cluster_id2 + "'"); 

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

                ArrayList<String> wc1 = new ArrayList<String>();
//                summ.clear();

                String[] wcarr = cmnt.split(" ");
                wc1.addAll(Arrays.asList(wcarr));

                ArrayList<String> sumel = new ArrayList<String>();

                Statement stmt = c.createStatement();
                ResultSet ct = stmt.executeQuery("select distinct cmt,comment.cmt_id from comment inner join cluster_elements on comment.cmt_id=cluster_elements.cmt_id where cluster_id='" + cluster_id2 + "'"); 
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

                    dtsummary.addRow(new String[]{comm.replace("?", " "), elm.replace(",", " "), cluster_id2, Integer.toString(ctcnt)}); 
                }
            }
        }
    }
    catch(Exception ex)
    {
        System.err.println(ex);
    }
    
    Statement st6=c.createStatement();
    
    try
    {
        String qry1 = "select * from bsts_sum where msg_id = '" + two + "'";
        ResultSet rs4 = st6.executeQuery(qry1);
        while(rs4.next())
        {
            wordarray1 = rs4.getString(3).split(",");
        }
        rs4.close();

        dtsummary2 = dtsumm2;
        ArrayList<String> cid = new ArrayList<String>();

        String[] dtcls1 = null;
        qry1 = "select count(distinct cluster_id) from clusters where msg_id='" + two + "'";
        ResultSet dt1 = st6.executeQuery(qry1);
        if(dt1.next())
        {
            dtcls1 = new String[dt1.getInt(1)];
        }
        dt1.close();

        qry1 = "select distinct cluster_id,cluster_center from clusters where msg_id='" + two + "'";
        ResultSet dts1 = st6.executeQuery(qry1);
        int dx1 = 0;
        while(dts1.next())
        {
            dtcls1[dx1] = dts1.getString(1);
            dx1++;
        }
        dts1.close();

    //    session.setAttribute("dt", dt);

        for(int dy1 = 0; dy1 < dtcls1.length; dy1++)
        { 
            String cluster_id3 = dtcls1[dy1];
            ResultSet ctcm1 = st.executeQuery("select count(distinct comment.cmt_id) from comment inner join cluster_elements on comment.cmt_id=cluster_elements.cmt_id where cluster_id='" + cluster_id3 + "'");
            int ctcnt1 = 0;
            if(ctcm1.next())
            {
                ctcnt1 = ctcm1.getInt(1);
            }
            ctcm1.close();

            if(ctcnt1 > 0)
            {
                Statement stm1 = c.createStatement();
                ResultSet ctc1 = stm1.executeQuery("select distinct cmt,comment.cmt_id from comment inner join cluster_elements on comment.cmt_id=cluster_elements.cmt_id where cluster_id='" + cluster_id3 + "'"); 

                String comm1 = "", cmnt1 = ""; 
                int cnt1 = 3;
                
                ctc1.last();
                ctcnt1 = ctc1.getRow();
                ctc1.first();
                
                while(ctc1.next()) 
                {
                    if(comm1.length()<1000){
                        comm1 += "<ul> ";
                        cmnt1 += ctc1.getString(1) + " ";
                        comm1 += " <li>" + ctc1.getString(1) + " </li>";
                        comm1 += " </ul>";
                    }
                    
                }
                ctc1.close();

                ArrayList<String> wc11 = new ArrayList<String>();
//                summ.clear();

                String[] wcarr1 = cmnt1.split(" ");
                wc11.addAll(Arrays.asList(wcarr1));

                ArrayList<String> sumel1 = new ArrayList<String>();

                Statement stmt1 = c.createStatement();
                ResultSet ct1 = stmt1.executeQuery("select distinct cmt,comment.cmt_id from comment inner join cluster_elements on comment.cmt_id=cluster_elements.cmt_id where cluster_id='" + cluster_id3 + "'"); 
                while(ct1.next())
                {
                    sumel1.clear();
                    for(int i = 0; i < dt1gram2.getRowCount(); i++)
                    {
                        if(dt1gram2.getValueAt(i, 0).toString().equals(ct1.getString(2)))
                        {
                            sumel1.add(dt1gram2.getValueAt(i, 1).toString());
                        }
                    }
                    for(int i = 0; i < dt2gram2.getRowCount(); i++)
                    {
                        if(dt2gram2.getValueAt(i, 0).toString().equals(ct1.getString(2)))
                        {
                            sumel1.add(dt2gram2.getValueAt(i, 1).toString());
                        }
                    }
                    for(int i = 0; i < dt3gram2.getRowCount(); i++)
                    {
                        if(dt3gram2.getValueAt(i, 0).toString().equals(ct1.getString(2)))
                        {
                            sumel1.add(dt3gram2.getValueAt(i, 1).toString());
                        }
                    }
    //                summ.add(ct.getString(2));
                }
                ct1.close();

                String elm1 = "";
                ArrayList<String> uniq1 = new ArrayList<String>();

                if (cmnt1.trim().length() > 5)
                {
                    if (elm1.length() < 3)
                    {
                        String[] stt1 = cmnt1.split(" ");
                        int cntx1 = 0;
                        cntx1 = stt1.length;
                        //string stpwrd;
                        int ip1 = 0;
                        for (int ix = 0; ix < cntx1; ix++)
                        {
                            if (!elm1.toLowerCase().contains(stt1[ix].toLowerCase()))
                            {
                                if (!new Stopwords().stpwrd(stt1[ix]))//if (!new TermPreprocessor().removeStopWords(stt[ix]).equals(null))
                                {
                                    if (ip1 == ix - 1)
                                        elm1 = elm1.replace(",", " ") + " ";
                                    elm1 += stt1[ix].replace("?", " ") + ",";
                                    ip1 = ix;
                                }
                            }
                        }
                    }

                    dtsummary2.addRow(new String[]{comm1.replace("?", " "), elm1.replace(",", " "), cluster_id3, Integer.toString(ctcnt1)}); 
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
<table width="1099" height="71" border="1" align="center">
  <tr>
    <td width="541" class="NEW">BAND 1'S SUMMARY</td>
    <td width="542" class="NE">BRAND 2'S SUMMARY</td>
  </tr>
   
  <tr>
       <%        
    if(dtsummary.getRowCount() > 0)
    {
        for(int i = 0; i < dtsummary.getRowCount(); i++)
        {
        %>
      <td><%= dtsummary.getValueAt(i, 1) %></td>
    <td>&nbsp;</td>
     <% } } %>
     
      <%        
    if(dtsummary2.getRowCount() > 0)
    {
        for(int i = 0; i < dtsummary2.getRowCount(); i++)
        {
        %>
    <td><%= dtsummary2.getValueAt(i, 1) %></td>
    <td>&nbsp;</td>
     <% } } %>
  </tr>
   
</table>
</body>
</html>