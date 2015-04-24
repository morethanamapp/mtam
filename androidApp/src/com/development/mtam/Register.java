package com.development.mtam;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONTokener;

import com.facebook.android.AsyncFacebookRunner;
import com.facebook.android.AsyncFacebookRunner.RequestListener;
import com.facebook.android.DialogError;
import com.facebook.android.Facebook;
import com.facebook.android.Facebook.DialogListener;
import com.facebook.android.FacebookError;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.Window;
import android.widget.Button;
import android.widget.EditText;

public class Register extends Activity {
	
	private Button registerButton;
	private Button facebookButton;
	private Button closeButton;
	
	private EditText username;
	private EditText email;
	private EditText password;
	
	private AppFrame appDelegate;
	private ProgressDialog MyDialog;
	
	// Facebook
	public static final String TAG = "FACEBOOK CONNECT";
	private static final String[] PERMS = new String[] { "publish_stream", "offline_access", "email" };
	private AsyncFacebookRunner mAsyncRunner;
	private Facebook mfacebook;
	
	private String fbidpass;
	private String fbemail;
	private String fbdisplayname;
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		setContentView(R.layout.register);
		
		appDelegate = ((AppFrame)this.getApplicationContext());
		mfacebook = appDelegate.getFacebookObj();
		mAsyncRunner = new AsyncFacebookRunner(mfacebook);
		
		username = (EditText) findViewById(R.id.username);
		email = (EditText) findViewById(R.id.email);
		password = (EditText) findViewById(R.id.password);
		
		facebookButton = (Button) findViewById(R.id.buttonfacebook);
		facebookButton.setOnClickListener(new View.OnClickListener() {
			public void onClick(View v) {
				//Toast.makeText(getApplicationContext(), "Facebook Button",Toast.LENGTH_SHORT).show();
				doFacebook();
			}
	    });
		
		registerButton = (Button) findViewById(R.id.buttonRegister);
		registerButton.setOnClickListener(new View.OnClickListener() {
			public void onClick(View v) {
				
				//MyDialog.show();
				validateSubmission();
			}
	    });
		
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
	
	@Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        mfacebook.authorizeCallback(requestCode, resultCode, data);
    }
	
	private void doFacebook(){
		
		facebookButton.setEnabled(false);
		username.setEnabled(false);
		email.setEnabled(false);
		password.setEnabled(false);
		registerButton.setEnabled(false);
		
		if (!mfacebook.isSessionValid()) {
												
			final SharedPreferences prefs = this.getSharedPreferences("userlogin", 0);		
			mfacebook.authorize(this, PERMS, new DialogListener() {
	            @Override
	            public void onComplete(Bundle values) {
	                SharedPreferences.Editor editor = prefs.edit();
	                editor.putString("fb_access_token", mfacebook.getAccessToken());
	                editor.putLong("fb_access_expires", mfacebook.getAccessExpires());	                
	                editor.commit();
	                
	                MyDialog.show();
	                mAsyncRunner.request("me", new FBDetailsRequestListener());
	                
	            }            
	
	            @Override
	            public void onCancel() {}
	
				@Override
				public void onFacebookError(FacebookError e) {
					// TODO Auto-generated method stub
					
				}
	
				@Override
				public void onError(DialogError e) {
					// TODO Auto-generated method stub
					
				}
	        });
		}		
	}
	
	private class FBDetailsRequestListener implements RequestListener {
		
		public void onComplete(String response, Object state) {
			try {
				
				JSONObject json = (JSONObject) new JSONTokener(response).nextValue();
				final String fb_id = json.getString("id");
				final String fb_email = json.getString("email");
				final String fb_displayname = json.getString("name");
				
				Register.this.runOnUiThread(new Runnable() {
		  			public void run() {
		  				fbidpass = fb_id;
						fbemail = fb_email;
						fbdisplayname = fb_displayname;
						
						postFBData();
		  			}
		  		});
				
			} catch (JSONException e) {
		  		Log.w(TAG, "JSON Error in response");
		  	} catch (FacebookError e) {
		  		Log.w(TAG, "Facebook Error: " + e.getMessage());
		  	}
			
			MyDialog.dismiss();
		}
		
		public void onIOException(IOException e, Object state) {
			Log.d(TAG, e.getLocalizedMessage());		 
		 }
		 
		public void onFileNotFoundException(FileNotFoundException e, Object state) {		  	
			Log.d(TAG, e.getLocalizedMessage());
		}
		 
		public void onMalformedURLException(MalformedURLException e, Object state) {
			Log.d(TAG, e.getLocalizedMessage());		
		}
		 
		public void onFacebookError(FacebookError e, Object state) {
			Log.d(TAG, e.getLocalizedMessage());
		 
		}
	}
	
	
	private void validateSubmission(){
		
		Boolean errorFound = false;
		String errorMessage = "Please complete:\n";
		
		if(username.getText().toString().trim().equals("")){
			errorFound = true;
			errorMessage = errorMessage+"Username\n";
		}
		
		if(!isEmailValid(email.getText().toString().trim())){
			errorFound = true;
			errorMessage = errorMessage+"Email\n";
		}
		
		if(password.getText().toString().trim().equals("")){
			errorFound = true;
			errorMessage = errorMessage+"Password\n";
		}
		
		if(errorFound){
			AlertDialog.Builder builder = new AlertDialog.Builder(this);
			builder.setMessage(errorMessage).setPositiveButton("OK", dialogClickListener).show();
		}else{
			//Toast.makeText(getApplicationContext(), "Success",Toast.LENGTH_SHORT).show();
			
			facebookButton.setEnabled(false);
			username.setEnabled(false);
			email.setEnabled(false);
			password.setEnabled(false);
			registerButton.setEnabled(false);
			
			postData();			
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
	
	public static boolean isEmailValid(String email) {
	    boolean isValid = false;

	    String expression = "^[\\w\\.-]+@([\\w\\-]+\\.)+[A-Z]{2,4}$";
	    CharSequence inputStr = email;

	    Pattern pattern = Pattern.compile(expression, Pattern.CASE_INSENSITIVE);
	    Matcher matcher = pattern.matcher(inputStr);
	    if (matcher.matches()) {
	        isValid = true;
	    }
	    return isValid;
	}
	
	public void postData() {
		
		MyDialog.show();		    
		RetreiveHttpTask task = new RetreiveHttpTask();    	
    	String reqURL = "http://www.morethanamapp.org/request/registeruser.php";    	    
    	task.execute(reqURL);
    	
	}
	
	public void postFBData(){
						   
		RetreiveFBHttpTask task = new RetreiveFBHttpTask();    	
    	String reqURL = "http://www.morethanamapp.org/request/registeruser_viafacebook.php";    	    
    	task.execute(reqURL);
		
	}
	
	public class RetreiveHttpTask extends AsyncTask<String, Void, HttpResponse> {
		
		@Override
    	protected HttpResponse doInBackground(String... params) {
    		try {
    			    			    			    	
    			HttpClient httpclient = new DefaultHttpClient();	    
    			HttpPost httppost = new HttpPost(params[0]);
    			
    			List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>(2);
    		    nameValuePairs.add(new BasicNameValuePair("user", username.getText().toString()));
    		    nameValuePairs.add(new BasicNameValuePair("email", email.getText().toString()));
    		    nameValuePairs.add(new BasicNameValuePair("pass", password.getText().toString()));
    		    httppost.setEntity(new UrlEncodedFormEntity(nameValuePairs));

    		    // Execute HTTP Post Request
    		    HttpResponse response = httpclient.execute(httppost);
    			 
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
					String userid = object.getString("user_id");
					String username = object.getString("username");							
					
					appDelegate.setLoginOk(true);
					appDelegate.setUserid(userid);
					appDelegate.setUsername(username);
					
					SharedPreferences prefs = Register.this.getSharedPreferences("userlogin", 0);
					SharedPreferences.Editor editor = prefs.edit();
					editor.putString("userid", userid);
					editor.putString("username", username);
					editor.putString("usertype", "MTAMAccount");
					editor.commit();
					
					MyDialog.dismiss();
					finish();
					
	        	}else if(response.getStatusLine().getStatusCode() == 401){
	        		
	        		MyDialog.dismiss();
	        		String login_error_msg = "Sorry user already exists, please try another username and email";
	        		AlertDialog.Builder builder = new AlertDialog.Builder(Register.this);
	    			builder.setMessage(login_error_msg).setPositiveButton("OK", dialogClickListener).show();
	        		
	        	}else{
	        		
	        		MyDialog.dismiss();
	        		String login_error_msg = "Sorry user creation unsuccessful, please try again.";
	        		AlertDialog.Builder builder = new AlertDialog.Builder(Register.this);
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
	
	public class RetreiveFBHttpTask extends AsyncTask<String, Void, HttpResponse> {
		
		@Override
    	protected HttpResponse doInBackground(String... params) {
    		try {
    			    			    			    	
    			HttpClient httpclient = new DefaultHttpClient();	    
    			HttpPost httppost = new HttpPost(params[0]);
    			
    			List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>(2);    		   
    		    nameValuePairs.add(new BasicNameValuePair("email",Register.this.fbemail));
    		    nameValuePairs.add(new BasicNameValuePair("pass", Register.this.fbidpass));
    		    httppost.setEntity(new UrlEncodedFormEntity(nameValuePairs));

    		    // Execute HTTP Post Request
    		    HttpResponse response = httpclient.execute(httppost);
    			 
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
					String userid = object.getString("user_id");										
					
					appDelegate.setLoginOk(true);
					appDelegate.setUserid(userid);
					appDelegate.setUsername(fbdisplayname);
					appDelegate.setFacebookObj(mfacebook);
					
					SharedPreferences prefs = Register.this.getSharedPreferences("userlogin", 0);
					SharedPreferences.Editor editor = prefs.edit();
					editor.putString("userid", userid);
					editor.putString("username", fbdisplayname);
					editor.putString("usertype", "FBAccount");
					editor.commit();
					
					MyDialog.dismiss();
					finish();
					
	        	}else if(response.getStatusLine().getStatusCode() == 401){
	        		
	        		MyDialog.dismiss();
	        		String login_error_msg = "Sorry user already exists, please try another username and email";
	        		AlertDialog.Builder builder = new AlertDialog.Builder(Register.this);
	    			builder.setMessage(login_error_msg).setPositiveButton("OK", dialogClickListener).show();
	        		
	        	}else{
	        		
	        		MyDialog.dismiss();
	        		String login_error_msg = "Sorry user creation unsuccessful, please try again.";
	        		AlertDialog.Builder builder = new AlertDialog.Builder(Register.this);
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
