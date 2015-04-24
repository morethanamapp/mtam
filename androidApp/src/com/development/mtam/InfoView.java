package com.development.mtam;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONTokener;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.View;
import android.view.Window;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Button;

public class InfoView extends Activity {
	
	private WebView wv;
	private String section;
	private Button backButton;
	private Button fwdButton;
	private Button refreshButton;
	private Button stopButton;
	private Button doneButton;
	private ProgressDialog MyDialog;
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
	        super.onCreate(savedInstanceState);
	        requestWindowFeature(Window.FEATURE_NO_TITLE);
	        setContentView(R.layout.inwebview);
	        
	        Bundle extras = getIntent().getExtras();
	        if (extras == null) {
	        	return;
	        }
	    		
	        section = extras.getString("section");
	        
	        wv = (WebView) findViewById(R.id.thewebview);
	        wv.getSettings().setJavaScriptEnabled(true);
	        wv.getSettings().setUseWideViewPort(true);
	        wv.setScrollBarStyle(WebView.SCROLLBARS_INSIDE_OVERLAY);
	        wv.setInitialScale(50);
	        wv.clearCache(true);
	        
	        wv.setWebViewClient(new TheWebViewClient());
	        
	        backButton = (Button) findViewById(R.id.backbutton);
	        backButton.setOnClickListener(new View.OnClickListener() {
	            public void onClick(View v) {
	                if(wv.canGoBack()){
	                	wv.goBack();                	
	                }
	            }
	        });        
	        
	        
	        fwdButton = (Button) findViewById(R.id.fwdbutton);
	        fwdButton.setOnClickListener(new View.OnClickListener() {
	            public void onClick(View v) {
	                if(wv.canGoForward()){
	                	wv.goForward();
	                }
	            }
	        });
	        
	        stopButton = (Button) findViewById(R.id.stopbutton);
	        stopButton.setOnClickListener(new View.OnClickListener() {
	            public void onClick(View v) {
	            	
	            	wv.stopLoading();
	            	
	            }
	        });
	        
	        refreshButton = (Button) findViewById(R.id.refreshbutton);
	        refreshButton.setOnClickListener(new View.OnClickListener() {
	            public void onClick(View v) {
	            	
	            	wv.reload();
	            	
	            }
	        });
	        
	        doneButton = (Button) findViewById(R.id.donebutton);
	        doneButton.setOnClickListener(new View.OnClickListener() {
	            public void onClick(View v) {
	            	
	            	finish();
	            	
	            }
	        });
	        
	        MyDialog = new ProgressDialog(this);
	        MyDialog.setTitle("");
	        MyDialog.setMessage(" Loading. Please wait ... ");
	        MyDialog.setIndeterminate(true);
	        MyDialog.setCancelable(true);
	        
	        postData();
	        
	}
	
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if ((keyCode == KeyEvent.KEYCODE_BACK)) {
           if(wv.canGoBack()){
        	   wv.goBack();
        	   return true;
           }else{
        	   finish();
        	   return true;
        	   
           }	           
       }
       return this.onKeyDown(keyCode, event);
	}
	
	private class TheWebViewClient extends WebViewClient {		   
		   
		   @Override
		    public boolean shouldOverrideUrlLoading(WebView view, String url) {
		        
		        if(url.equals("http://www.morethanamapp.org/showreviews/")){
		        	Uri marketUri = Uri.parse("market://details?id=" + InfoView.this.getPackageName());
		        	Intent i = new Intent(Intent.ACTION_VIEW, marketUri);
		        	startActivity(i);
		        }else{
		        	view.loadUrl(url);
		        }
		        
		        return true;
		    }
		    
		    public void onPageStarted(WebView view, String url, Bitmap favicon){
		    	if(!InfoView.this.MyDialog.isShowing()){
		    		InfoView.this.MyDialog.show();
		    	}		    
		    }
		    
		    public void onPageFinished(WebView view, String url){		    	
		    	if(InfoView.this.MyDialog.isShowing()){
		    		InfoView.this.MyDialog.dismiss();
		    	}
		    }
	 }
	
	public void postData() {
		
		MyDialog.show();		    
		RetreiveHttpTask task = new RetreiveHttpTask();    	
    	String reqURL = "http://www.morethanamapp.org/request/get-app-details-android.php?section=%s";
    	String reUrlFormated = String.format(reqURL, section);
    	task.execute(reUrlFormated);
    	
	}
	
	public class RetreiveHttpTask extends AsyncTask<String, Void, HttpResponse> {
		
		@Override
    	protected HttpResponse doInBackground(String... params) {
    		try {
    			    			    			    	
    			HttpClient httpclient = new DefaultHttpClient();	    
    			//HttpPost httppost = new HttpPost(params[0]);
    			HttpGet httpget = new HttpGet(params[0]);
    			    			
    		    // Execute HTTP Post Request
    		    HttpResponse response = httpclient.execute(httpget);
    			 
    		    return response;
    			
    		}catch (Exception e) {                
                throw new RuntimeException(e);            
            }
    		
    	}
    	@Override
    	protected void onPostExecute(HttpResponse response) {
    		
    		try {
	        	if(response.getStatusLine().getStatusCode() == 200){
	        		
	        		StringBuilder stb = inputStreamToString(response.getEntity().getContent());
					JSONObject object = (JSONObject) new JSONTokener(stb.toString()).nextValue();
					String content_url = object.getString("content");
					
					wv.loadUrl(content_url);
					
					//MyDialog.dismiss();
					
	        	}else{
	        		
	        		MyDialog.dismiss();
	        		String login_error_msg = "Sorry user request unsuccessful, please try again.";
	        		AlertDialog.Builder builder = new AlertDialog.Builder(InfoView.this);
	    			builder.setMessage(login_error_msg).setPositiveButton("OK", dialogClickListener).show();
	        		
	        	}
				
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IllegalStateException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}    			    
        }		
	}
	
	DialogInterface.OnClickListener dialogClickListener = new DialogInterface.OnClickListener() {
	    @Override
	    public void onClick(DialogInterface dialog, int which) {
	        switch (which){
	        case DialogInterface.BUTTON_POSITIVE:	        	
	            
	            break;

	        case DialogInterface.BUTTON_NEGATIVE:
	            //No button clicked
	            break;
	        }
	    }
	};
	
	private StringBuilder inputStreamToString(InputStream is) {
	    String line = "";
	    StringBuilder total = new StringBuilder();
	    
	    // Wrap a BufferedReader around the InputStream
	    BufferedReader rd = new BufferedReader(new InputStreamReader(is));
	
	    // Read response until the end
	    try {
			while ((line = rd.readLine()) != null) { 
			    total.append(line); 
			}
		} catch (IOException e) {
			
			e.printStackTrace();
		}
	    
	    // Return full string
	    return total;
	}
	
}
