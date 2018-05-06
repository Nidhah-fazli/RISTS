<%@page import="java.util.Arrays"%>
<%@page import="java.util.Collections"%>
<%@page import="util.ClusterManager"%>
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

    int[][] vector = (int[][]) session.getAttribute("vector");
    ArrayList<String> words = (ArrayList<String>) session.getAttribute("words");
    String message_id = request.getParameter("id");
    
    int nwords = words.size();
    int[] cluster_center = new int[nwords];
    double fvc = 0;
    
    DefaultTableModel dt_comment = (DefaultTableModel) session.getAttribute("dt_comment");
    DefaultTableModel dt_cluster = new DefaultTableModel(null, new String[]{"cluster_id", "elements"});
    
    int ncomments = dt_comment.getRowCount();
    
    ClusterManager clmngr = new ClusterManager();
    clmngr.clusters((Object)message_id);
    
    int cluster_id = clmngr.getclstrid();
    ArrayList<int[]> ccs = new ArrayList<>();
    ArrayList<Integer> cids = new ArrayList<>();
        
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
        clmngr.insertcluster(cluster_id, message_id, ccenter);
        clmngr.insertelements(cluster_id, dt_comment.getValueAt(0, 0).toString(), 1); 
        
        for(int ix = 1; ix < ncomments; ix++)
        {
            int flag = 0;
            ArrayList<int[]> templist = new ArrayList<>();
            
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
                clmngr.insertcluster(cluster_id, message_id, ccenter);
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
               
                
    int[] a=ccs.get(ind);
    int[] b=ccs.get(ind1);
    
        float sum = 0, k = 0;
        for (int i = 0; i < a.length; i++)
        {
            k += a[i];
            sum += a[i] * b[i];
        }
        double sima= sum / k;
                
                ////////////
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
        dt_cluster = clmngr.clusters(message_id);
    }

%>
<body>
    <div style="overflow-x: scroll">
<form id="form1" name="form1" method="post" action="summary.jsp?id=<%= message_id %>">
  <table width="700" border="1" align="center">
    <tr>
      <th scope="col">Cluster</th>
      <th scope="col">Comment</th>
      <th scope="col">Distance</th>
      <th scope="col">Cluster Center</th>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
        <%        
    if(dt_cluster.getRowCount() > 0)
    {
        for(int i = 0; i < dt_cluster.getRowCount(); i++)
        {
        %>
    <tr>
      <td><%= dt_cluster.getValueAt(i, 0) %></td>
      <td><%= dt_cluster.getValueAt(i, 1) %></td>
      <td><%= dt_cluster.getValueAt(i, 2) %></td>
      <td><%= dt_cluster.getValueAt(i, 3) %></td>
    </tr>
        <%
        }
    }
        %>
    <tr>
      <td colspan="4">&nbsp;</td>
    </tr>
    <tr>
      <td height="23" colspan="4">
        <input type="submit" name="button" id="button" value="     Summary     " />
      </td>
    </tr>
  </table>
</form>
    </div>
</body>
</html>
    <jsp:include page="footer_expert.jsp"/>