package com.development.mtam;

import android.app.Activity;
import android.app.ProgressDialog;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.View;
import android.view.Window;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Button;

public class InWebView extends Activity {
	
	private WebView wv;
	private String url;
	private Button backButton;
	private Button fwdButton;
	private Button refreshButton;
	private Button stopButton;
	private Button doneButton;
	private ProgressDialog MyDialog;
	private View mainarea;
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
	        super.onCreate(savedInstanceState);
	        requestWindowFeature(Window.FEATURE_NO_TITLE);
	        setContentView(R.layout.inwebview);
	        
	        Bundle extras = getIntent().getExtras();
	        if (extras == null) {
	        	return;
	        }
	    		
	        url = extras.getString("url");	        	       
	        
	        mainarea = (View) findViewById(R.id.mainarea);
	        
	        wv = (WebView) findViewById(R.id.thewebview);
	        wv.getSettings().setJavaScriptEnabled(true);
	        wv.getSettings().setUseWideViewPort(true);
	        wv.setScrollBarStyle(WebView.SCROLLBARS_INSIDE_OVERLAY);
	        wv.setInitialScale(50);
	        wv.clearCache(true);
	        
	        wv.setWebViewClient(new TheWebViewClient());
	        wv.loadUrl(url);
	        
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
	}
	
	/*@Override
    public void onAttachedToWindow() {
        super.onAttachedToWindow();
        TranslateAnimation anim = new TranslateAnimation(Animation.RELATIVE_TO_PARENT, (float)1.0, Animation.RELATIVE_TO_PARENT, (float)1.0, Animation.RELATIVE_TO_PARENT, (float)0.0, Animation.RELATIVE_TO_PARENT, (float)1.0);
        anim.setDuration(3000);
        //anim.setFillAfter(true);
        this.mainarea.startAnimation(anim);
    }
	
	@Override
	public void onDetachedFromWindow () {
		super.onDetachedFromWindow();
		TranslateAnimation anim = new TranslateAnimation(Animation.RELATIVE_TO_PARENT, (float)1.0, Animation.RELATIVE_TO_PARENT, (float)1.0, Animation.RELATIVE_TO_PARENT, (float)1.0, Animation.RELATIVE_TO_PARENT, (float)0.0);
        anim.setDuration(1500);
        this.mainarea.startAnimation(anim);		
	}*/
	
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
		        view.loadUrl(url);
		        return true;
		    }
		    
		    public void onPageStarted(WebView view, String url, Bitmap favicon){
		    	if(!InWebView.this.MyDialog.isShowing()){		    		
		    		InWebView.this.MyDialog.show();
		    	}		    
		    }
		    
		    public void onPageFinished(WebView view, String url){		    	
		    	if(InWebView.this.MyDialog.isShowing()){
		    		InWebView.this.MyDialog.dismiss();
		    	}
		    }
	 }
}
