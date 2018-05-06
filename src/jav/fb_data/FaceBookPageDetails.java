package fb_data;


import com.sun.corba.se.spi.presentation.rmi.StubAdapter;
import dbc.Dbcon;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLConnection;
import java.sql.Connection;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;


/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 *
 * @author Lenovo
 */


public class FaceBookPageDetails {
    //https://www.facebook.com/search/posts/?q=%23HAI
    String appID="822825894563193";//"1964467363793852";//1522829564471523
    String appSecret="f74118b2afdbd62fe5a940f2398442b1";//"7be0b34bcc9619570447144026b6c5e3";//5e38e9e839dc9cabdf0749e797b972a8

    public String getAccessToken(){
        String accessToken="";
        String url="https://graph.facebook.com/oauth/access_token?grant_type=client_credentials&client_id="+appID+"&client_secret="+appSecret;
  
        try {
            URL ur=new URL(url);
            URLConnection urc=ur.openConnection();
            InputStream in=urc.getInputStream();
            BufferedReader br=new BufferedReader(new InputStreamReader(in));
            String jsonString="";
            jsonString=br.readLine();
            JSONParser jsonParsor=new JSONParser();
            JSONObject jsonObject= (JSONObject) jsonParsor.parse(jsonString);
            accessToken=(String) jsonObject.get("access_token");
            System.out.println(accessToken);
        } catch (Exception e) {
        }
        return accessToken;
    }
    
    public void readPosts(String accessToken,String pageName){
    
        String status="";
        String url="https://graph.facebook.com/"+pageName+"/posts?access_token="+accessToken;
        String msgid="";
        String msg="";
        String ct="";
        String story="";
        System.out.println("inside");
        //String url="https://graph.facebook.com/ search?q=%23 &limit=10000 &access_token="+accessToken;
        System.out.println(url);
         try {
            URL ur=new URL(url);
            URLConnection urc=ur.openConnection();
            InputStream in=urc.getInputStream();
            BufferedReader br=new BufferedReader(new InputStreamReader(in));
            String jsonString="";
            jsonString=br.readLine();
            JSONParser jsonParsor=new JSONParser();
            JSONObject jsonObject= (JSONObject) jsonParsor.parse(jsonString);
            JSONArray ja=(JSONArray)jsonObject.get("data");
             dbc.Dbcon db=new Dbcon();
            Connection c=db.getcon();
            Statement st=c.createStatement();
            st.executeUpdate("delete from message where msg_frm='"+pageName+"'");
            for(int i=0;i<ja.size();i++){
               JSONObject jso= (JSONObject)ja.get(i);
               msgid=(String) jso.get("id");
               ct=(String) jso.get("created_time");
               try{
                   msg=(String) jso.get("message");
               }catch (Exception e) {
                System.out.println(e.toString());
            }
            
            try{
                   story=(String) jso.get("story");
               }catch (Exception e) {
           // System.out.println(e.toString());
            }
           
            
            if(msg!=null){
                msg=msg.replace("'", "");
            }
            else{
                msg="";
            }
            if(story!=null){
                story=story.replace("'", "");
            }
            else{
                story="";
            }
            String[] datetime=ct.split("T");
            if(!(story.equalsIgnoreCase("")&&msg.equalsIgnoreCase(""))){
                
            st.executeUpdate("insert into message values('"+msgid+"','"+pageName+"','"+datetime[0]+"','"+datetime[1]+"','"+msg+"','"+story+"')");
           // System.out.println(jsonString);
            }
            
            }
            

        } catch (Exception e) {
            // System.out.println(e.toString());
        }finally{
            
         }
    }
  
    
    public static void main(String[] args){
        
        try {
            FaceBookPageDetails fb=new FaceBookPageDetails();
            String acc=fb.getAccessToken();
            fb.readPosts(acc, "msdhoni");
              
        } catch (Exception e) {
            System.out.println(e.toString());
        }
        
    }

   public void readComments(String acc,String post){
       String cmtid="";
        String cmt="";
        String cts="";
       System.out.println("comments====================");
         try{
            URL url=new URL("https://graph.facebook.com/"+post+"/comments?access_token="+ acc);
            URLConnection urc=url.openConnection();
            InputStream in=urc.getInputStream();
            BufferedReader rd = new BufferedReader(new InputStreamReader(in));
           
            String jsonString=rd.readLine();
            System.out.println(jsonString);
            JSONParser jsonParsor=new JSONParser();
            JSONObject jsonObject= (JSONObject) jsonParsor.parse(jsonString);
            JSONArray ja=(JSONArray)jsonObject.get("data");
            dbc.Dbcon db=new Dbcon();
            Connection c=db.getcon();
            Statement st=c.createStatement();
            st.executeUpdate("delete from comment where msg_id='"+post+"'");
            for(int i=0;i<ja.size();i++){
               JSONObject jso= (JSONObject)ja.get(i);
               cmtid=(String) jso.get("id");
               cts=(String) jso.get("created_time");
               cmt=(String) jso.get("message");
               cmt=cmt.replace("'", "");
               String[] datetime=cts.split("T");
               st.executeUpdate("insert into comment values('"+cmtid+"','"+post+"','"+cmt+"','"+datetime[0]+"','"+datetime[1]+"',null)");
            }
            
        } catch (Exception e) {
             System.out.println("errrr:"+e);
        } 
   }
}

