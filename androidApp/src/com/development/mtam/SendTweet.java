package com.development.mtam;

import twitter4j.Twitter;
import twitter4j.TwitterException;
import twitter4j.TwitterFactory;
import twitter4j.auth.AccessToken;
import twitter4j.auth.RequestToken;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.Window;
import android.webkit.WebView;
import android.widget.Toast;

public class SendTweet extends Activity {
	
	public static final String TAG = "TWITTER SEND";
	
	private AppFrame appDelegate;
	private Landmark activeLmk;	
	
	//Twitter
	private Twitter mTwitter;
	private RequestToken mReqToken;
	private static final String PREF_TwACCESS_TOKEN = "tw_accessToken";
	private static final String PREF_TwACCESS_TOKEN_SECRET = "tw_accessTokenSecret";
	private static final String CONSUMER_KEY = "fnWWO9x83OGr9KZR95niRw";
	private static final String CONSUMER_SECRET = "akg8tPrOFCo7RGanK0RmvMmpZAx6S8vCBYQmLtao";
	private static final String CALLBACK_URL = "mtam-tweet-to-twitter-android://tw";
	
	private ProgressDialog MyDialog;
	private SharedPreferences prefs;
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
	    requestWindowFeature(Window.FEATURE_NO_TITLE);
	    setContentView(R.layout.tweet_send);
	    
	    appDelegate = ((AppFrame)this.getApplicationContext());
	    activeLmk = appDelegate.getCurrentLandmark();	    
	    
	    // Configure Twitter4j library.
	    
	    prefs = this.getSharedPreferences("userlogin", 0);
	    mTwitter = new TwitterFactory().getInstance();
	    mTwitter.setOAuthConsumer(CONSUMER_KEY, CONSUMER_SECRET);
	    
	    
	    MyDialog = new ProgressDialog(this);
		MyDialog.setTitle("");
	    MyDialog.setMessage("Submitting. Please wait ... ");
	    MyDialog.setIndeterminate(true);
	    MyDialog.setCancelable(true);
	    
	    //check twitter status
	    if (prefs.contains(PREF_TwACCESS_TOKEN)) {
            Log.i(TAG, "Repeat User");
            twLoginAuthorisedUser();
		} else {
            Log.i(TAG, "New User");
            twLoginNewUser();
		}
	    
	}
	
	@Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        Log.i(TAG, "New Intent Arrived");
        handleTwitterResponse(intent);
    }
	
	@Override 
	public void onResume() { 
	    super.onResume();
	}
	
	private void handleTwitterResponse(Intent intent) {
        Uri uri = intent.getData();
        if (uri != null && uri.toString().startsWith(CALLBACK_URL)) { // If the user has just logged in
        //if (uri != null && uri.getScheme().toString().contains(CALLBACK_URL)&& !uri.toString().contains("denied")){
	
        	try{
        		String oauthVerifier = uri.getQueryParameter("oauth_verifier");

                authoriseNewUser(oauthVerifier);
                
        	}catch (NullPointerException ex) {
        		Log.i(TAG, "Handle Failed");
        		finish();
            }                
        }else{
        	Log.i(TAG, "Handle Failed");
        	finish();
        }
    }
	
	private void authoriseNewUser(String oauthVerifier) {
        try {
                AccessToken at = mTwitter.getOAuthAccessToken(mReqToken, oauthVerifier);
                mTwitter.setOAuthAccessToken(at);

                saveAccessToken(at);

                // Set the content view back after we changed to a webview
                setContentView(R.layout.tweet_send);
                
                //Submit Tweet
                TwitterShare();
                
        } catch (TwitterException e) {
                Toast.makeText(this, "Twitter auth error x01, try again later", Toast.LENGTH_SHORT).show();
                Log.e(TAG, e.getErrorMessage());
        }
	}
	
	private void saveAccessToken(AccessToken at) {
        String token = at.getToken();
        String secret = at.getTokenSecret();
        
        Editor editor = prefs.edit();
        editor.putString(PREF_TwACCESS_TOKEN, token);
        editor.putString(PREF_TwACCESS_TOKEN_SECRET, secret);
        editor.commit();
	}
	
	private void twLoginAuthorisedUser() {
        String token = prefs.getString(PREF_TwACCESS_TOKEN, null);
        String secret = prefs.getString(PREF_TwACCESS_TOKEN_SECRET, null);

        // Create the twitter access token from the credentials we got previously
        AccessToken at = new AccessToken(token, secret);

        mTwitter.setOAuthAccessToken(at);
        
        //Toast.makeText(this, "Welcome back", Toast.LENGTH_SHORT).show();
        
        //Submit Tweet
        TwitterShare();
	}	
	
	private void twLoginNewUser() {
        try {
                Log.i(TAG, "Request App Authentication");
                mReqToken = mTwitter.getOAuthRequestToken(CALLBACK_URL);

                Log.i(TAG, "Starting Webview to login to twitter");
                WebView twitterSite = new WebView(this);
                twitterSite.loadUrl(mReqToken.getAuthenticationURL());
                setContentView(twitterSite);

        } catch (TwitterException e) {
                Toast.makeText(this, "Twitter Login error, try again later", Toast.LENGTH_SHORT).show();
                Log.e(TAG, e.getErrorMessage());
        }
	}
	
	private void TwitterShare(){
		
		String message = "I found this cool landmark on More Than A Map(p),\n\nName:%s\n\nAddr:%s\n\n";
		String messageFormated = String.format(message, activeLmk.getTitle(), activeLmk.getAddress());
		
		try {
            mTwitter.updateStatus(messageFormated);
            
            AlertDialog.Builder builder = new AlertDialog.Builder(this);
			builder.setMessage("Tweet Successful!").setPositiveButton("OK", dialogClickListener).show();
            
            //Toast.makeText(this, "Tweet Successful!", Toast.LENGTH_SHORT).show();            
            
		} catch (TwitterException e) {
            
			AlertDialog.Builder builder = new AlertDialog.Builder(this);
			builder.setMessage("Tweet error, try again later.").setPositiveButton("OK", dialogClickListener).show();
			
			//Toast.makeText(this, "Tweet error, try again later", Toast.LENGTH_SHORT).show();
			
            Log.e(TAG, e.getErrorMessage());
            
		}
	}
	
	DialogInterface.OnClickListener dialogClickListener = new DialogInterface.OnClickListener() {
	    @Override
	    public void onClick(DialogInterface dialog, int which) {
	        switch (which){
	        case DialogInterface.BUTTON_POSITIVE:	        	
	            finish();
	            break;

	        case DialogInterface.BUTTON_NEGATIVE:
	            //No button clicked
	            break;
	        }
	    }
	};

}
