package com.development.mtam;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.DateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.mime.HttpMultipartMode;
import org.apache.http.entity.mime.MultipartEntity;
import org.apache.http.entity.mime.content.FileBody;
import org.apache.http.entity.mime.content.StringBody;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.protocol.BasicHttpContext;
import org.apache.http.protocol.HttpContext;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.util.Log;
import android.view.View;
import android.view.Window;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.ImageView;

public class SubmitPoint extends Activity {
	
	private static final int REQUEST_IMAGE_CAPTURE_CODE = 5;
	private static final int REQUEST_IMAGE_CODE = 10;
	private static final int REQUEST_STATE_CODE = 15;
	private static final int REQUEST_WEB_CODE = 20;
	
	private static final String TAG = "SubmitPoint"; 
	
	static final String[] STATELIST = new String[] {"Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","District Of Columbia","Florida","Georgia","Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Carolina","North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington","West Virginia","Wisconsin","Wyoming"};
	
	private Uri selectedImageURI;
	private Bitmap yourSelectedImage;	
	
	private ImageView selectedPhotoView;
	private Button selectStateButton;
	private Button selectPhotoButton;
	private Button registerButton;
	private Button closeButton;
	private Button agreeButton;
	private CheckBox agreeCheckBox;
	
	private EditText locName;
	private EditText locAddr;
	private EditText locCity;
	private EditText locZip;
	private EditText locDesc;	
			
	private int selectedState;
	private AppFrame appDelegate;
	private ProgressDialog MyDialog;
	
	private String capturePhotoPath;
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		setContentView(R.layout.submitpoint);
		
		appDelegate = ((AppFrame)this.getApplicationContext());
		capturePhotoPath = null;
		
		locName = (EditText) findViewById(R.id.loc_name);		
		locAddr = (EditText) findViewById(R.id.loc_address);
		locCity = (EditText) findViewById(R.id.loc_city);
		locZip = (EditText) findViewById(R.id.loc_zip);
		locDesc = (EditText) findViewById(R.id.loc_description);
		
		selectedState = -1;
		
		selectedPhotoView = (ImageView) findViewById(R.id.photoSelectedImageView);
		agreeCheckBox = (CheckBox) findViewById(R.id.agreeCheckBox);		
		
		agreeButton = (Button) findViewById(R.id.agreeButton);
		agreeButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
            	Intent i = new Intent(SubmitPoint.this, InWebView.class);
          		i.putExtra("url", "http://www.morethanamapp.org/request/upload_t_and_c.html");          		
                startActivityForResult(i, REQUEST_WEB_CODE);
            }
		});
		
		selectStateButton = (Button) findViewById(R.id.selectStateButton);
		selectStateButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
            	
            	Intent i = new Intent(SubmitPoint.this, StateSelectForSubmit.class);	      		          	
	            startActivityForResult(i, REQUEST_STATE_CODE);
            	
            }
		});
		
		selectPhotoButton = (Button) findViewById(R.id.selectPhotoButton);
		selectPhotoButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
            	showPhotoCaptureOptions();
            }
		});
		
		registerButton = (Button) findViewById(R.id.registerButton);
		registerButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
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
	
	private void showPhotoCaptureOptions(){
		
		final CharSequence[] locations = {"Take Photo", "Choose Photo"};

		AlertDialog.Builder builder = new AlertDialog.Builder(this);
	    builder.setTitle("Add A Photo");

	    builder.setItems(locations, new DialogInterface.OnClickListener()
	    {
	        public void onClick(DialogInterface dialog, int which)
	        {
	        	SubmitPoint.this.photoOptSelected(which);
	        } 
	    });

	    AlertDialog dlg = builder.create();
	    dlg.show();
		
	}
	
	private void photoOptSelected(int which){
		
		if(which == 0){
			String storageState = Environment.getExternalStorageState();
			if(storageState.equals(Environment.MEDIA_MOUNTED)) {
				
				capturePhotoPath = Environment.getExternalStorageDirectory().getName() + File.separatorChar + "Android/data/" + SubmitPoint.this.getPackageName() + "/files/" + md5(DateFormat.getDateTimeInstance().format(new Date())) + ".jpg";
	            File capturedPhotoFile = new File(capturePhotoPath);
	            try {
	                if(capturedPhotoFile.exists() == false) {
	                	capturedPhotoFile.getParentFile().mkdirs();
	                	capturedPhotoFile.createNewFile();
	                }

	            } catch (IOException e) {
	                Log.e(TAG, "Could not create file.", e);
	            }
	            Log.i(TAG, capturePhotoPath);

	            selectedImageURI = Uri.fromFile(capturedPhotoFile);	            
	            
				Intent intent = new Intent("android.media.action.IMAGE_CAPTURE");
				intent.putExtra( MediaStore.EXTRA_OUTPUT, selectedImageURI);
				startActivityForResult(intent, REQUEST_IMAGE_CAPTURE_CODE);
				
			}else {
	            new AlertDialog.Builder(SubmitPoint.this)
	            .setMessage("External Storeage (SD Card) is required.\n\nCurrent state: " + storageState)
	            .setCancelable(true).create().show();
	        }			
            
		}else if(which == 1){
			
			Intent i = new Intent(Intent.ACTION_PICK, android.provider.MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
			startActivityForResult(i, REQUEST_IMAGE_CODE);
			
		}
		
	}
	
	
	@Override
    public void onActivityResult(int requestCode,int resultCode,Intent data){
		super.onActivityResult(requestCode, resultCode, data);
				
		switch(requestCode) { 
	    case REQUEST_IMAGE_CODE:
	        if(resultCode == RESULT_OK){
	            selectedImageURI = data.getData();
	            try {
	            	
					yourSelectedImage = this.decodeUri(selectedImageURI);
					selectedPhotoView.setImageBitmap(yourSelectedImage);
					selectPhotoButton.setText("Change Photo >");
					
				} catch (FileNotFoundException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}									            	            
	            
	        }
	        break;
	    
	    case REQUEST_IMAGE_CAPTURE_CODE:
	    	if(resultCode == RESULT_OK){
	    		/*if(data != null){
	                Bitmap photo = (Bitmap) data.getExtras().get("data");
	                photo = Bitmap.createScaledBitmap(photo, 80, 80, false);
	                selectedPhotoView.setImageBitmap(photo);
	                selectPhotoButton.setText("Change Photo >");
	            }else{
	            	Toast.makeText(getApplicationContext(), "Image Capture Failed",Toast.LENGTH_SHORT).show();
	            }*/
	    		try {
	            	
					yourSelectedImage = this.decodeUri(selectedImageURI);
					selectedPhotoView.setImageBitmap(yourSelectedImage);
					selectPhotoButton.setText("Change Photo >");
					
				} catch (FileNotFoundException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}

	    	}else if(resultCode == RESULT_CANCELED){
	    		selectedImageURI = null;	    		
	    	}
	    	break;
	        
	    case REQUEST_STATE_CODE:
	    	if(resultCode == RESULT_OK){
	    		selectedState = data.getIntExtra("selectedstate", -1);
	    		selectStateButton.setText(STATELIST[selectedState]);
	    	}
	    	break;
	    }
									
    }
	
	private void validateSubmission(){
		
		Boolean errorFound = false;
		String errorMessage = "Please complete:\n";
		
		if(locName.getText().toString().trim().equals("")){
			errorFound = true;
			errorMessage = errorMessage+"Location Name\n";
		}
		
		if(locAddr.getText().toString().trim().equals("")){
			errorFound = true;
			errorMessage = errorMessage+"Address\n";
		}			
		
		if(locCity.getText().toString().trim().equals("")){
			errorFound = true;
			errorMessage = errorMessage+"City\n";
		}
		
		if(selectedState == -1){
			errorFound = true;
			errorMessage = errorMessage+"State\n";
		}
		
		if(locZip.getText().toString().trim().equals("")){
			errorFound = true;
			errorMessage = errorMessage+"Zip\n";
		}
		
		if(locDesc.getText().toString().trim().equals("")){
			errorFound = true;
			errorMessage = errorMessage+"Description\n";
		}
		
		if(!agreeCheckBox.isChecked()){
			errorFound = true;
			errorMessage = errorMessage+"Agree terms and conditions\n";
		}
		
		if(errorFound){
			AlertDialog.Builder builder = new AlertDialog.Builder(this);
			builder.setMessage(errorMessage).setPositiveButton("OK", dialogClickListener).show();
		}else{
			//Toast.makeText(getApplicationContext(), "Success",Toast.LENGTH_SHORT).show();
			//postData();
			postDataWithBinary();
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
	
	DialogInterface.OnClickListener submitdialogClickListener = new DialogInterface.OnClickListener() {
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
	
	public void postData() {
	    // Create a new HttpClient and Post Header
	    HttpClient httpclient = new DefaultHttpClient();	    
	    HttpPost httppost = new HttpPost("http://www.morethanamapp.org/request/add-mapp-point.php");

	    try {
	    		    		    	
	        // Add your data
	        List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>(2);
	        nameValuePairs.add(new BasicNameValuePair("user_id", appDelegate.getUserid()));
	        nameValuePairs.add(new BasicNameValuePair("title", locName.getText().toString()));
	        nameValuePairs.add(new BasicNameValuePair("details", locDesc.getText().toString()));
	        nameValuePairs.add(new BasicNameValuePair("addr", locAddr.getText().toString()));
	        nameValuePairs.add(new BasicNameValuePair("city", locCity.getText().toString()));
	        nameValuePairs.add(new BasicNameValuePair("state", ""+this.selectedState));
	        nameValuePairs.add(new BasicNameValuePair("zip", locZip.getText().toString()));
	        httppost.setEntity(new UrlEncodedFormEntity(nameValuePairs));

	        // Execute HTTP Post Request
	        HttpResponse response = httpclient.execute(httppost);	        
	        
			if(response.getStatusLine().getStatusCode() == 200){
				
				AlertDialog.Builder builder = new AlertDialog.Builder(this);
				builder.setMessage("Point successfully submitted").setPositiveButton("OK", submitdialogClickListener).show();
				
			}else{
				
				String login_error_msg = "Sorry request unsuccessful, please try again.";
				AlertDialog.Builder builder = new AlertDialog.Builder(this);
				builder.setMessage(login_error_msg).setPositiveButton("OK", dialogClickListener).show();
				
			}
	        
	    } catch (ClientProtocolException e) {
	        // TODO Auto-generated catch block
	    	e.printStackTrace();
	    } catch (IOException e) {
	        // TODO Auto-generated catch block
	    	e.printStackTrace();
	    }
	}
	
	public void postDataWithBinary() {
		
		MyDialog.show();		    
		RetreiveHttpTask task = new RetreiveHttpTask();    	
    	String reqURL = "http://www.morethanamapp.org/request/add-mapp-point.php";    	    
    	task.execute(reqURL);			
	
	}
	
	public class RetreiveHttpTask extends AsyncTask<String, Void, HttpResponse> {
		
		@Override
    	protected HttpResponse doInBackground(String... params) {
    		try {
    			    			    			    	
    			HttpClient httpclient = new DefaultHttpClient();
    			HttpContext localContext = new BasicHttpContext();
    			HttpPost httppost = new HttpPost(params[0]);
    			
    			MultipartEntity entity = new MultipartEntity(HttpMultipartMode.BROWSER_COMPATIBLE);
    	    	
	   	    	// Add your data
	   	        List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>(2);
	   	        nameValuePairs.add(new BasicNameValuePair("user_id", appDelegate.getUserid()));
	   	        nameValuePairs.add(new BasicNameValuePair("title", locName.getText().toString()));
	   	        nameValuePairs.add(new BasicNameValuePair("details", locDesc.getText().toString()));
	   	        nameValuePairs.add(new BasicNameValuePair("addr", locAddr.getText().toString()));
	   	        nameValuePairs.add(new BasicNameValuePair("city", locCity.getText().toString()));
	   	        nameValuePairs.add(new BasicNameValuePair("state", ""+SubmitPoint.this.selectedState));
	   	        nameValuePairs.add(new BasicNameValuePair("zip", locZip.getText().toString()));
	   	        
	   	        if(capturePhotoPath != null){
	   	        	nameValuePairs.add(new BasicNameValuePair("mappphoto", capturePhotoPath));
	   	        }else if(selectedImageURI != null){
	   	        	nameValuePairs.add(new BasicNameValuePair("mappphoto", getRealPathFromURI(selectedImageURI)));
	   	        }
	   	        
	   	        for(int index=0; index < nameValuePairs.size(); index++) {
		            if(nameValuePairs.get(index).getName().equalsIgnoreCase("mappphoto")) {
		                // If the key equals to "mappphoto", we use FileBody to transfer the data
		            	//Toast.makeText(getApplicationContext(), "photo url:"+nameValuePairs.get(index).getValue(),Toast.LENGTH_SHORT).show();
		            	Log.d(TAG, "Response: " + nameValuePairs.get(index).getValue());
		                entity.addPart(nameValuePairs.get(index).getName(), new FileBody(new File (nameValuePairs.get(index).getValue())));
		            } else {
		                // Normal string data
		                entity.addPart(nameValuePairs.get(index).getName(), new StringBody(nameValuePairs.get(index).getValue()));
		            }
		        }
	   	        httppost.setEntity(entity);
	   	        
	   	        // Execute HTTP Post Request
		        HttpResponse response = httpclient.execute(httppost, localContext);    		        		   
    			 
    		    return response;
    			
    		}catch (Exception e) {                
                throw new RuntimeException(e);            
            }
    		
    	}
    	@Override
    	protected void onPostExecute(HttpResponse response) {
    		
    		MyDialog.dismiss();
    		
			if(response.getStatusLine().getStatusCode() == 200){
				
				AlertDialog.Builder builder = new AlertDialog.Builder(SubmitPoint.this);
				builder.setMessage("Point successfully submitted").setPositiveButton("OK", submitdialogClickListener).show();
				
			}else{
				
				String login_error_msg = "Sorry request unsuccessful, please try again.";
				AlertDialog.Builder builder = new AlertDialog.Builder(SubmitPoint.this);
				builder.setMessage(login_error_msg).setPositiveButton("OK", dialogClickListener).show();
				
			}							    			    
        }		
	}
	
	public String getRealPathFromURI(Uri contentUri) {
        String[] proj = { MediaStore.Images.Media.DATA };
        Cursor cursor = managedQuery(contentUri, proj, null, null, null);
        int column_index = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
        cursor.moveToFirst();
        return cursor.getString(column_index);
    }


	
	
	private Bitmap decodeUri(Uri selectedImage) throws FileNotFoundException {

        // Decode image size
        BitmapFactory.Options o = new BitmapFactory.Options();
        o.inJustDecodeBounds = true;
        BitmapFactory.decodeStream(getContentResolver().openInputStream(selectedImage), null, o);

        // The new size we want to scale to
        final int REQUIRED_SIZE = 140;

        // Find the correct scale value. It should be the power of 2.
        int width_tmp = o.outWidth, height_tmp = o.outHeight;
        int scale = 1;
        while (true) {
            if (width_tmp / 2 < REQUIRED_SIZE
               || height_tmp / 2 < REQUIRED_SIZE) {
                break;
            }
            width_tmp /= 2;
            height_tmp /= 2;
            scale *= 2;
        }

        // Decode with inSampleSize
        BitmapFactory.Options o2 = new BitmapFactory.Options();
        o2.inSampleSize = scale;
        return BitmapFactory.decodeStream(getContentResolver().openInputStream(selectedImage), null, o2);

    }
	
	public static String md5(String s) 
	{
	    MessageDigest digest;
	    try 
	    {
	        digest = MessageDigest.getInstance("MD5");
	        digest.update(s.getBytes(),0,s.length());
	        String hash = new BigInteger(1, digest.digest()).toString(16);
	        return hash;
	    } 
	    catch (NoSuchAlgorithmException e) 
	    {
	        e.printStackTrace();
	    }
	    return "";
	}



}
