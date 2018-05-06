/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package util;

import dbc.Dbcon;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javax.swing.table.DefaultTableModel;

/**
 *
 * @author akarsh
 */
public class ClusterManager {
    
    public void insertcluster(int cluster_id, String msgid, String center) throws SQLException
    {
        try{
        dbc.Dbcon db = new Dbcon();
        Connection con = db.getcon();
        Statement st = con.createStatement();
        
        String qry = "insert into clusters values('"+cluster_id+"','" + msgid + "','" + center + "')";
        st.executeUpdate(qry);
        con.close();
        }catch(Exception e){}
    }

    public void insertelements(int cluster_id, String cmt_id, double dist) throws SQLException
    {
        try{
        dbc.Dbcon db = new Dbcon();
        Connection con = db.getcon();
        Statement st = con.createStatement();
        
        String qry = "insert into cluster_elements values('" + cluster_id + "','" + cmt_id + "','" + dist + "')";
        st.executeUpdate(qry);
        con.close();
        }catch(Exception e){}
    }

    public void updatecluster(int clusterid, String center) throws SQLException
    {
        try{
        dbc.Dbcon db = new Dbcon();
        Connection con = db.getcon();
        Statement st = con.createStatement();
        
        String qry = "update clusters set cluster_center='" + center + "' where cluster_id='" + clusterid + "'";
        st.executeUpdate(qry);
        con.close();
        }catch(Exception e){}
    }
    
    public void updatecluster(int id1, int id2, String center) throws SQLException
    {
        try{
        dbc.Dbcon db = new Dbcon();
        Connection con = db.getcon();
        Statement st = con.createStatement();
        
        String qry = "update cluster_elements set cluster_id='" + id1 + "' where cluster_id='" + id2 + "'";
        st.executeUpdate(qry);
        qry = "delete from clusters where cluster_id='" + id2 + "'";
        st.executeUpdate(qry);
        updatecluster(id1, center);
        con.close();
        }catch(Exception e){}
    }

    public DefaultTableModel clusters(String msg) throws SQLException
    {
       
        DefaultTableModel dt_cluster = new DefaultTableModel(null, new String[]{"cluster_id", "comment_id", "dist", "cluster_center"});
         try{
        dbc.Dbcon db = new Dbcon();
        Connection con = db.getcon();
        Statement st = con.createStatement();
        
        String qry = "select cluster_elements.*,clusters.cluster_center from cluster_elements inner join clusters on clusters.cluster_id=cluster_elements.cluster_id where msg_id='" + msg + "'";
        ResultSet dt = st.executeQuery(qry); 
        while(dt.next())
        {
            dt_cluster.addRow(new String[]{dt.getString(1), dt.getString(2), dt.getString(3), dt.getString(4)});
        }
        con.close();
         }catch(Exception e){}
        return dt_cluster;
       
    }
    
    public DefaultTableModel clusters(Object msg) throws SQLException
    {
        try{
       dbc.Dbcon db = new Dbcon();
        Connection con = db.getcon();
        Statement st = con.createStatement();

        st.executeUpdate("delete from cluster_elements where cluster_id in (select cluster_id from clusters where msg_id='" + msg + "')");
        String qry = "delete from  clusters where msg_id='" + msg + "'";
        st.executeUpdate(qry);
        con.close();
           }catch(Exception e){} 
        return new DefaultTableModel();
        

    }
    
    public void removeelement(String comment_id) throws SQLException
    {
        try{
        dbc.Dbcon db = new Dbcon();
        Connection con = db.getcon();
        Statement st = con.createStatement();
        
        String qry = "delete from cluster_elements where cmt_id='" + comment_id + "'";
        st.executeUpdate(qry); 
        con.close();
        }catch(Exception e){} 
    }
    
    public void removecluster(String message_id) throws SQLException
    {
        try{
        dbc.Dbcon db = new Dbcon();
        Connection con = db.getcon();
        Statement st = con.createStatement();
        
        String qry = "delete from clusters where msg_id = '" + message_id + "'";
        st.executeUpdate(qry); 
        con.close();
        }catch(Exception e){} 
    }
    
    public int getclstrid() throws SQLException
    {
        int maxid = 0;
        try{
        dbc.Dbcon db = new Dbcon();
        Connection con = db.getcon();
        Statement st = con.createStatement();
        
        String qry = "select max(cluster_id)+1 from clusters";
        ResultSet rs = st.executeQuery(qry);
        
        if(rs.next())
        {
            try {
                maxid = rs.getInt(1);
            }
            catch (Exception ex) { }
            finally {
                if(maxid == 0)
                    maxid = 1;
            }
        }
        con.close();
        }catch(Exception e){} 
        return maxid;
        
    }
}
