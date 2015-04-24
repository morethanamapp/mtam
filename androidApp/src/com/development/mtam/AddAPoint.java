package com.development.mtam;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.MalformedURLException;

import com.facebook.android.AsyncFacebookRunner;
import com.facebook.android.AsyncFacebookRunner.RequestListener;
import com.facebook.android.Facebook;
import com.facebook.android.FacebookError;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.os.Handler;
import android.util.TypedValue;
import android.view.View;
import android.view.Window;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

public class AddAPoint extends Activity {
	
	private static final int REQUEST_CODE = 5;
	
	private Button signinButton;
	private Button newmapperButton;
	private Button signOutButton;
	private Button addapointButton;
	private Button closeButton;
	private Button infoButton;
	
	private LinearLayout contentFrame;
	
	private ProgressDialog MyDialog;
	
	private TextView statusMessage;
	private AppFrame appDelegate;
	
	// Facebook
	public static final String TAG = "FACEBOOK CONNECT";
	private static final String[] PERMS = new String[] { "publish_stream", "offline_access", "email" };
	private AsyncFacebookRunner mAsyncRunner;
	private Facebook mfacebook;	
	
	private SharedPreferences prefs;
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		setContentView(R.layout.addapoint);
		
		appDelegate = ((AppFrame)this.getApplicationContext());			
		mfacebook = appDelegate.getFacebookObj();
		
		contentFrame = (LinearLayout) findViewById(R.id.contentFrame); 
		
		signinButton = (Button) findViewById(R.id.buttonSignin);
		signinButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
            	Intent i = new Intent(AddAPoint.this, Login.class);	      		          	
	            startActivityForResult(i, REQUEST_CODE);
            }
		});
				
		newmapperButton = (Button) findViewById(R.id.buttonNewMapper); 
		newmapperButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
            	Intent i = new Intent(AddAPoint.this, Register.class);	      		          	
	            startActivityForResult(i, REQUEST_CODE);
            }
		});
		
		signOutButton = (Button) findViewById(R.id.buttonSignout);
		signOutButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
            	signOut();
            }
		});
		
		addapointButton = (Button) findViewById(R.id.buttonAddAPoint);
		addapointButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
            	if(appDelegate.getLoginOk() == true){
            		Intent i = new Intent(AddAPoint.this, SubmitPoint.class);	      		          	
            		startActivityForResult(i, REQUEST_CODE);
            	}else{
            		Intent i = new Intent(AddAPoint.this, Login.class);	      		          	
    	            startActivityForResult(i, REQUEST_CODE);
            	}
            }
		});
		
		closeButton = (Button) findViewById(R.id.closebutton);
		closeButton.setOnClickListener(new View.OnClickListener() {
			public void onClick(View v) {
				finish();
			}
	    });
		
		infoButton = (Button) findViewById(R.id.infobutton);
	    infoButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
            	
            	Intent i = new Intent(AddAPoint.this, InfoView.class);
            	i.putExtra("section", "appaddapoint");
                startActivityForResult(i, REQUEST_CODE);
            }
        });
		
		statusMessage = (TextView) findViewById(R.id.status_message);
		
		MyDialog = new ProgressDialog(this);
		MyDialog.setTitle("");
	    MyDialog.setMessage(" Loading. Please wait ... ");
	    MyDialog.setIndeterminate(true);
	    MyDialog.setCancelable(true);
		
		checkLoginStat();
	}
	
	protected void onResume(){
        super.onResume();
        
        checkLoginStat();
        
    }
	
	private void signOut(){
		//Toast.makeText(getApplicationContext(), "SignOut",Toast.LENGTH_SHORT).show();
		
		 prefs = this.getSharedPreferences("userlogin", 0);
		 String type = prefs.getString("usertype", "");
		 
		 if(type.equals("FBAccount")){
			 
			 AsyncFacebookRunner asyncRunner = new AsyncFacebookRunner(mfacebook);
			 asyncRunner.logout(this, new LogoutRequestListener());
			 MyDialog.show();
			 
		 }else{
			 prefs.edit().clear().commit();
			 appDelegate.setLoginOk(false);
			 appDelegate.setUserid(null);
			 appDelegate.setUsername(null);
			 checkLoginStat();
		 }		 		 
	}
	
	private class LogoutRequestListener implements RequestListener {
		
		private Handler mHandler = new Handler();
		
		public void onComplete(String response, Object state) {
			// Dispatch on its own thread
			mHandler.post(new Runnable() {
				public void run() {
					MyDialog.dismiss();
					prefs.edit().clear().commit();
					appDelegate.setLoginOk(false);
					appDelegate.setUserid(null);
					appDelegate.setUsername(null);
					checkLoginStat();
				}
			});
		}
	 
		public void onIOException(IOException e, Object state) {
			// TODO Auto-generated method stub
	 
		}
	 
		public void onFileNotFoundException(FileNotFoundException e, Object state) {
			// TODO Auto-generated method stub
	 
		}
	 
		public void onMalformedURLException(MalformedURLException e, Object state) {
			// TODO Auto-generated method stub
	 
		}
	 
		public void onFacebookError(FacebookError e, Object state) {
			// TODO Auto-generated method stub
	 
		}
	}
	
	private void checkLoginStat(){
		
		if(appDelegate.getLoginOk() == true){
			
			signinButton.setVisibility(View.INVISIBLE);
			signinButton.setEnabled(false);
			
			newmapperButton.setVisibility(View.INVISIBLE);
			newmapperButton.setEnabled(false);
			
			signOutButton.setVisibility(View.VISIBLE);
			signOutButton.setEnabled(true);
			
			String welcomeMessage = "Welcome, "+appDelegate.getUsername();
			
			statusMessage.setTextSize(TypedValue.COMPLEX_UNIT_SP, 24);
			statusMessage.setText(welcomeMessage);					
			
			//contentFrame.removeView(signinButton);
			//contentFrame.removeView(newmapperButton);
			
		}else{
			
			statusMessage.setTextSize(TypedValue.COMPLEX_UNIT_SP, 16);
			statusMessage.setText(R.string.DefaultStatusText);
			
			signinButton.setVisibility(View.VISIBLE);
			signinButton.setEnabled(true);
			
			newmapperButton.setVisibility(View.VISIBLE);
			newmapperButton.setEnabled(true);
			
			signOutButton.setVisibility(View.INVISIBLE);
			signOutButton.setEnabled(false);
			
		}
		
	}
}
