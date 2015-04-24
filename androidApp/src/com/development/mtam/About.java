package com.development.mtam;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Button;

public class About extends Activity {
	
	private WebView wv;
	private Button closeButton;
	private ProgressDialog MyDialog;
	private static final int REQUEST_CODE = 10;
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
	        super.onCreate(savedInstanceState);
	        	        
	        requestWindowFeature(Window.FEATURE_NO_TITLE);	        	        
	        
	        setContentView(R.layout.about);
	        
	        wv = (WebView) findViewById(R.id.about_webview);
	        wv.getSettings().setJavaScriptEnabled(true);
	        wv.getSettings().setUseWideViewPort(true);
	        wv.setScrollBarStyle(WebView.SCROLLBARS_INSIDE_OVERLAY);
	        //wv.setBackgroundColor(R.color.transparent);
	        wv.setBackgroundColor(0);
	        wv.clearCache(true);
	        
	        wv.setWebViewClient(new TheWebViewClient());
	        wv.loadUrl("http://www.morethanamapp.org/request/about.html");
	        
	        
	        closeButton = (Button) findViewById(R.id.closebutton);
	        closeButton.setOnClickListener(new View.OnClickListener() {
	            public void onClick(View v) {
	            	finish();
	            }
	        });	        	        
	        
	        MyDialog = new ProgressDialog(this);
	        MyDialog.setTitle("");
	        MyDialog.setMessage(" Loading. Please wait ... ");
	        MyDialog.setIndeterminate(true);
	        MyDialog.setCancelable(true);
	 }
	
	private class TheWebViewClient extends WebViewClient {	   
		   
		   @Override
		    public boolean shouldOverrideUrlLoading(WebView view, String url) {
		        //view.loadUrl(url);
		        
			   	Intent i = new Intent(About.this, InWebView.class);
          		i.putExtra("url", url);
                startActivityForResult(i, REQUEST_CODE);
                
		        return true;
		    }
		    
		    public void onPageStarted(WebView view, String url, Bitmap favicon){
		    	if(!About.this.MyDialog.isShowing()){		    		
		    		About.this.MyDialog.show();
		    	}
		    	//About.this.wv.setBackgroundColor(R.color.transparent);
		    	About.this.wv.setBackgroundColor(0);
		    }
		    
		    public void onPageFinished(WebView view, String url){		    	
		    	if(About.this.MyDialog.isShowing()){
		    		About.this.MyDialog.dismiss();
		    	}
		    	//About.this.wv.setBackgroundColor(R.color.transparent);
		    	About.this.wv.setBackgroundColor(0);
		    }
	 }
}
