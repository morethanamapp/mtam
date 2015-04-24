package com.development.mtam;

import java.io.ByteArrayOutputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;

import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONTokener;

import com.facebook.android.AsyncFacebookRunner;
import com.facebook.android.Facebook;
import com.facebook.android.FacebookError;
import com.facebook.android.AsyncFacebookRunner.RequestListener;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Bundle;
import android.text.Html;
import android.util.Log;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup.LayoutParams;
import android.view.Window;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.TextView;

public class LandmarkPointView extends Activity {
	
	private static final int REQUEST_CODE = 10;
	
	private AppFrame appDelegate;
	private Landmark activeLmk;
	
	private ImageButton pointbackButton;
	private ImageButton directionsButton;
	private ImageButton shareButton;
	private ImageButton bookmarkButton;
	
	private FrameLayout.LayoutParams firstButtonLayout;
	private FrameLayout.LayoutParams secondButtonLayout;
	private FrameLayout.LayoutParams thirdButtonLayout;
	private FrameLayout.LayoutParams fourthButtonLayout;
	
	private Boolean firstButtonAssigned;
	private Boolean secondButtonAssigned;
	private Boolean thirdButtonAssigned;	
	
	public ImageLoader imageLoader;
	
	private ImageView imageProfile;
	private Button viewonmapButton;
	private TextView landmarkTitle;
	private TextView landmarkDesc;
	private TextView landmarkAddr;
	private FrameLayout moreContentFrame;
	
	private LayoutInflater inflater = null;
	
	// Facebook
	public static final String TAG = "FACEBOOK CONNECT";
	private AsyncFacebookRunner mAsyncRunner;
	private Facebook mfacebook;		
	
	private ProgressDialog MyDialog;
	private SharedPreferences prefs;
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
	    requestWindowFeature(Window.FEATURE_NO_TITLE);
	    setContentView(R.layout.landmark_point_view);
	    
	    // Configure Twitter4j library.
	    
	    prefs = this.getSharedPreferences("userlogin", 0);
	    
	    
	    //--------------------------------------
	    
	    inflater = (LayoutInflater) getSystemService(Context.LAYOUT_INFLATER_SERVICE);
	    
	    appDelegate = ((AppFrame)this.getApplicationContext());
	    activeLmk = appDelegate.getCurrentLandmark();
	    
	    mfacebook = appDelegate.getFacebookObj();
		mAsyncRunner = new AsyncFacebookRunner(mfacebook);
	    
	    firstButtonAssigned = false;
	    secondButtonAssigned = false;
	    thirdButtonAssigned = false;
	    
	    firstButtonLayout = new FrameLayout.LayoutParams(LayoutParams.WRAP_CONTENT,LayoutParams.WRAP_CONTENT,Gravity.LEFT | Gravity.TOP);
	    firstButtonLayout.leftMargin = 20;
	    firstButtonLayout.topMargin = 15;
	    
	    secondButtonLayout = new FrameLayout.LayoutParams(LayoutParams.WRAP_CONTENT,LayoutParams.WRAP_CONTENT,Gravity.RIGHT | Gravity.TOP);
	    secondButtonLayout.rightMargin = 20;
	    secondButtonLayout.topMargin = 15;
	    
	    thirdButtonLayout = new FrameLayout.LayoutParams(LayoutParams.WRAP_CONTENT,LayoutParams.WRAP_CONTENT,Gravity.LEFT | Gravity.BOTTOM);
	    thirdButtonLayout.leftMargin = 20;
	    thirdButtonLayout.bottomMargin = 15;	    
	    
	    fourthButtonLayout = new FrameLayout.LayoutParams(LayoutParams.WRAP_CONTENT,LayoutParams.WRAP_CONTENT,Gravity.RIGHT | Gravity.BOTTOM);
	    fourthButtonLayout.rightMargin = 20;
	    fourthButtonLayout.bottomMargin = 15;
	    
	    pointbackButton = (ImageButton) findViewById(R.id.pointbackButton);
	    pointbackButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
            	finish();
            }
        });
	    directionsButton = (ImageButton) findViewById(R.id.directionsButton);
	    directionsButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
            	showDirections();
            }
        });
	    shareButton = (ImageButton) findViewById(R.id.shareButton);
	    shareButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
            	shareOptions();
            }
        });
	    bookmarkButton = (ImageButton) findViewById(R.id.bookmarkButton);
	    bookmarkButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
            	addBookmark();
            }
        });
	    
	    imageProfile = (ImageView) findViewById(R.id.imageProfile);
	    landmarkTitle = (TextView) findViewById(R.id.landmark_title);
	    landmarkDesc = (TextView) findViewById(R.id.landmark_desc);
	    landmarkAddr = (TextView) findViewById(R.id.landmark_address);
	    moreContentFrame = (FrameLayout) findViewById(R.id.moreContentFrame);
	    
	    viewonmapButton = (Button) findViewById(R.id.viewonmapButton);
	    viewonmapButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
            	viewOnMap();
            }
        });
	    	    	    
	    populateDetails();
	    addMoreContentButtons();
	    
	    MyDialog = new ProgressDialog(this);
		MyDialog.setTitle("");
	    MyDialog.setMessage("Submitting. Please wait ... ");
	    MyDialog.setIndeterminate(true);
	    MyDialog.setCancelable(true);
	}			
	
	private void populateDetails(){
		
		landmarkTitle.setText(activeLmk.getTitle());
		landmarkDesc.setText(activeLmk.getDescription());
		landmarkAddr.setText(activeLmk.getAddress());
		
		imageProfile.setTag(activeLmk.getPhoto());
		imageLoader = new ImageLoader(this.getApplicationContext());
		imageLoader.DisplayImage(activeLmk.getPhoto(), this, imageProfile);
		
	}
	
	private void addMoreContentButtons(){
		
		if(activeLmk.getGallery() != null){
			
			firstButtonAssigned = true;
			
			View vi = inflater.inflate(R.layout.more_photo_button, null);
			
			int htpx = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_SP, 22, getResources().getDisplayMetrics());
			int wdpx = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_SP, 81, getResources().getDisplayMetrics());
			
			firstButtonLayout.width = wdpx;
			firstButtonLayout.height = htpx;
			
			vi.setLayoutParams(firstButtonLayout);			
			this.moreContentFrame.addView(vi);
		}
		
		if(activeLmk.getVideos() != null){
			if(!firstButtonAssigned){
				
				firstButtonAssigned = true;
				
				View vi = inflater.inflate(R.layout.more_video_button, null);
				
				int htpx = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_SP, 25, getResources().getDisplayMetrics());
				int wdpx = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_SP, 74, getResources().getDisplayMetrics());
				
				firstButtonLayout.width = htpx;
				firstButtonLayout.height = wdpx;
				
				vi.setLayoutParams(firstButtonLayout);
				this.moreContentFrame.addView(vi);
				
			}else{
				
				secondButtonAssigned = true;
				
				View vi = inflater.inflate(R.layout.more_video_button, null);
				
				int htpx = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_SP, 25, getResources().getDisplayMetrics());
				int wdpx = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_SP, 74, getResources().getDisplayMetrics());
				
				secondButtonLayout.width = wdpx;
				secondButtonLayout.height = htpx;
				
				vi.setLayoutParams(secondButtonLayout);
				this.moreContentFrame.addView(vi);
				
			}
		}
		
		if(activeLmk.getAudios() != null){
			
			if(!firstButtonAssigned){				
				firstButtonAssigned = true;
				
				View vi = inflater.inflate(R.layout.more_audio_button, null);
				
				int htpx = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_SP, 25, getResources().getDisplayMetrics());
				int wdpx = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_SP, 71, getResources().getDisplayMetrics());
				
				firstButtonLayout.width = wdpx;
				firstButtonLayout.height = htpx;
				
				vi.setLayoutParams(firstButtonLayout);
				this.moreContentFrame.addView(vi);
				
			}else if(!secondButtonAssigned){
				secondButtonAssigned = true;
				
				View vi = inflater.inflate(R.layout.more_audio_button, null);
				
				int htpx = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_SP, 25, getResources().getDisplayMetrics());
				int wdpx = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_SP, 71, getResources().getDisplayMetrics());
				
				secondButtonLayout.width = wdpx;
				secondButtonLayout.height = htpx;
				
				vi.setLayoutParams(secondButtonLayout);
				this.moreContentFrame.addView(vi);
				
			}else{				
				thirdButtonAssigned = true;
				
				View vi = inflater.inflate(R.layout.more_audio_button, null);
				
				int htpx = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_SP, 25, getResources().getDisplayMetrics());
				int wdpx = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_SP, 71, getResources().getDisplayMetrics());
				
				thirdButtonLayout.width = wdpx;
				thirdButtonLayout.height = htpx;
				
				vi.setLayoutParams(thirdButtonLayout);
				this.moreContentFrame.addView(vi);
			}
		}
		
		if(activeLmk.getLinks() != null){
			if(!firstButtonAssigned){				
				firstButtonAssigned = true;
				
				View vi = inflater.inflate(R.layout.more_links_button, null);
				
				int htpx = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_SP, 23, getResources().getDisplayMetrics());
				int wdpx = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_SP, 70, getResources().getDisplayMetrics());
				
				firstButtonLayout.width = htpx;
				firstButtonLayout.height = wdpx;
				
				vi.setLayoutParams(firstButtonLayout);
				this.moreContentFrame.addView(vi);
				
			}else if(!secondButtonAssigned){
				secondButtonAssigned = true;
				
				View vi = inflater.inflate(R.layout.more_links_button, null);
				
				int htpx = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_SP, 23, getResources().getDisplayMetrics());
				int wdpx = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_SP, 70, getResources().getDisplayMetrics());
				
				secondButtonLayout.width = wdpx;
				secondButtonLayout.height = htpx;
				
				vi.setLayoutParams(secondButtonLayout);
				this.moreContentFrame.addView(vi);
				
			}else if(!thirdButtonAssigned){
				thirdButtonAssigned = true;
				
				View vi = inflater.inflate(R.layout.more_links_button, null);
				
				int htpx = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_SP, 23, getResources().getDisplayMetrics());
				int wdpx = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_SP, 70, getResources().getDisplayMetrics());
				
				thirdButtonLayout.width = wdpx;
				thirdButtonLayout.height = htpx;
				
				vi.setLayoutParams(thirdButtonLayout);
				this.moreContentFrame.addView(vi);
				
			}else {
				
				View vi = inflater.inflate(R.layout.more_links_button, null);
				
				int htpx = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_SP, 23, getResources().getDisplayMetrics());
				int wdpx = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_SP, 70, getResources().getDisplayMetrics());
				
				fourthButtonLayout.width = wdpx;
				fourthButtonLayout.height = htpx;
				
				vi.setLayoutParams(fourthButtonLayout);
				this.moreContentFrame.addView(vi);
			}
		}
		
	}
	
	
	private void showDirections(){
		//Toast.makeText(getApplicationContext(), "Show Directions",Toast.LENGTH_SHORT).show();
		
		String genLink = "http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f";
    	String genlinkformated = String.format(genLink, appDelegate.getLocation().getLatitude(), appDelegate.getLocation().getLongitude(), activeLmk.getLatitude(), activeLmk.getLongtitude());
		
		Intent intent = new Intent(android.content.Intent.ACTION_VIEW, Uri.parse(genlinkformated));
		startActivity(intent);
		
	}
	
	private void shareOptions(){
		
		final CharSequence[] locations = {"Facebook", "Twitter", "Email"};
		//final CharSequence[] locations = {"Facebook", "Email"};
		
		AlertDialog.Builder builder = new AlertDialog.Builder(this);
	    builder.setTitle("Share With...");

	    builder.setItems(locations, new DialogInterface.OnClickListener()
	    {
	        public void onClick(DialogInterface dialog, int which)
	        {
	        	LandmarkPointView.this.shareSelected(which);
	        } 
	    });

	    AlertDialog dlg = builder.create();
	    dlg.show();
		
	}
	
	private void shareSelected(int which){
		
		if(which == 0){			
			FBShare();
			
		}else if(which == 1){
			
			Intent i = new Intent(this, SendTweet.class);          		          	
	    	this.startActivityForResult(i, REQUEST_CODE);
			
		}else if(which == 2){
			EmailShare();
		}
	}
	
	private void FBShare(){
		String msgUrl = "http://www.morethanamapp.org/";
		String msgtitle = "More Than A Map(p)";
		String message = "I found this cool landmark on More Than A Map(p), the app that lets you explore and upload African American History in the palm of your hand!\n\nName:%s\n\nAddr:%s\n\nGet the App:%s\n\n";
		String messageFormated = String.format(message, activeLmk.getTitle(), activeLmk.getAddress(), msgUrl);
		
		byte[] photodata = null;
		Bitmap pointPhoto = null;
		pointPhoto = getBitmapFromURL(activeLmk.getPhoto());
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		pointPhoto.compress(Bitmap.CompressFormat.JPEG, 100, baos);
		photodata = baos.toByteArray();
        
		Bundle param = new Bundle();
		param.putString("caption", msgtitle);
		param.putString("message", messageFormated);
		if(photodata != null){
			param.putByteArray("picture", photodata);
		}
		
		MyDialog.show();
		mAsyncRunner.request("me/photos", param, "POST", new SampleUploadListener(), null);
	}		
	
	private void EmailShare(){
		
		String msgUrl = "http://www.morethanamapp.org/";
		String msgtitle = "[More Than A Map(p)] Check out this cool landmark";
		String message = "I found this cool landmark on More Than A Map(p), the app that lets you explore and upload African American History in the palm of your hand!<br><br>Name:%s<br><br>Addr:%s<br><br><a href='%s'>Get the App</a>";
		String messageFormated = String.format(message, activeLmk.getTitle(), activeLmk.getAddress(),msgUrl);
		
		
		Intent intent = new Intent(Intent.ACTION_SEND);
		intent.setType("text/html");
		intent.putExtra(Intent.EXTRA_SUBJECT, msgtitle);
		intent.putExtra(Intent.EXTRA_TEXT, Html.fromHtml(messageFormated));
		Intent mailer = Intent.createChooser(intent, null);
		startActivity(mailer);
	}
	
	public class SampleUploadListener implements RequestListener {

	    public void onComplete(final String response, final Object state) {
	        try {
	            // process the response here: (executed in background thread)
	            Log.d(TAG, "Response: " + response.toString());
	            JSONObject json = (JSONObject) new JSONTokener(response).nextValue();
	            //JSONObject json = Util.parseJson(response);
	            //final String src = json.getString("src");
	            
	            LandmarkPointView.this.runOnUiThread(new Runnable() {
		  			public void run() {
		  				
						MyDialog.dismiss();
												
		  			}
		  		});

	        } catch (JSONException e) {
	            Log.w(TAG, "JSON Error in response");
	        } catch (FacebookError e) {
	            Log.w(TAG, "Facebook Error: " + e.getMessage());
	        }
	    }

	    @Override
	    public void onFacebookError(FacebookError e, Object state) {    
	    }

		@Override
		public void onIOException(IOException e, Object state) {
			// TODO Auto-generated method stub
			
		}

		@Override
		public void onFileNotFoundException(FileNotFoundException e,
				Object state) {
			// TODO Auto-generated method stub
			
		}

		@Override
		public void onMalformedURLException(MalformedURLException e,
				Object state) {
			// TODO Auto-generated method stub
			
		}
	}
	
	public static Bitmap getBitmapFromURL(String src) {
	    try {
	        URL url = new URL(src);
	        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
	        connection.setDoInput(true);
	        connection.connect();
	        InputStream input = connection.getInputStream();
	        Bitmap myBitmap = BitmapFactory.decodeStream(input);
	        return myBitmap;
	    } catch (IOException e) {
	        e.printStackTrace();
	        return null;
	    }
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
	
	
	private void addBookmark(){
		//Toast.makeText(getApplicationContext(), "Add Bookmark",Toast.LENGTH_SHORT).show();
		
		SharedPreferences prefs = this.getSharedPreferences("mtamBookmarks", 0);
		
		if(prefs.contains("mtamBookmarkcount")){
									
			int size = prefs.getInt("mtamBookmarkcount", 0);
			
			//Toast.makeText(getApplicationContext(), "BM Count "+size,Toast.LENGTH_SHORT).show();
			
			SharedPreferences.Editor editor = prefs.edit();
			
			
			//CHECK BOOKMARK ALREADY IN PLACE
			
			Boolean foundbm = false;
			int curvalue = -1;
			
			for(int i=0; i<size; i++){
				curvalue = prefs.getInt("BookmarkEntry_"+i, 0);
				if(curvalue == activeLmk.getLandmarkID()){
					foundbm = true;
				}
			}
			
			if(!foundbm){
				editor.putInt("mtamBookmarkcount", size+1);
				
				editor.putInt("BookmarkEntry_" + size, activeLmk.getLandmarkID());
				
				editor.commit();
				
				AlertDialog.Builder builder = new AlertDialog.Builder(this);
				builder.setMessage("Bookmark Successfully added").setPositiveButton("OK", dialogClickListener).show();
								
			}else{
				
				AlertDialog.Builder builder = new AlertDialog.Builder(this);
				builder.setMessage("Bookmark is already exists").setPositiveButton("OK", dialogClickListener).show();
				
			}
			
			/*int size = prefs.getInt("mtamBookmarkcount", 0);
			int bookmarks[] = new int[size+1];
			
			for(int i=0; i<size; i++){
				bookmarks[i] = prefs.getInt("BookmarkEntry_"+i, 0);
			}
			
			bookmarks[size] = activeLmk.getLandmarkID();			
			
			SharedPreferences.Editor editor = prefs.edit();  
			editor.putInt("mtamBookmarkcount", bookmarks.length);  
			
			for(int i=0;i<bookmarks.length;i++){  
			    editor.putInt("BookmarkEntry_" + i, bookmarks[i]);
			}						
			
			editor.commit();*/  
			
		}else{
			
			//Toast.makeText(getApplicationContext(), "First Entry",Toast.LENGTH_SHORT).show();
			
			SharedPreferences.Editor editor = prefs.edit();
			editor.putInt("mtamBookmarkcount", 1);
			
			editor.putInt("BookmarkEntry_" + 0, activeLmk.getLandmarkID());
			
			editor.commit();
			
			AlertDialog.Builder builder = new AlertDialog.Builder(this);
			builder.setMessage("Bookmark Successfully added").setPositiveButton("OK", dialogClickListener).show();
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
	
	private void viewOnMap(){
		//Toast.makeText(getApplicationContext(), "View On Map Coming Soon...",Toast.LENGTH_SHORT).show();
		
		Intent i = new Intent(this, ViewOnMap.class);          		          	
    	this.startActivityForResult(i, REQUEST_CODE);
	}
	
	
	//BUTTON CLICK MEDTHODS
	public void showMorePhotos(View view){
		//Toast.makeText(getApplicationContext(), "Show More Photos",Toast.LENGTH_SHORT).show();
		
		Intent i = new Intent(this, PhotoViewer.class);          		          	
    	this.startActivityForResult(i, REQUEST_CODE);
		
	}
	
	public void showMoreVideos(View view){
		//Toast.makeText(getApplicationContext(), "Show More Videos",Toast.LENGTH_SHORT).show();
		
		Intent i = new Intent(this, MoreContentListView.class);
  		i.putExtra("contentType", "Videos");          		
        startActivityForResult(i, REQUEST_CODE);
	}
	
	public void showMoreAudios(View view){
		//Toast.makeText(getApplicationContext(), "Show More Audios",Toast.LENGTH_SHORT).show();
		
		Intent i = new Intent(this, MoreContentListView.class);
  		i.putExtra("contentType", "Audios");          		
        startActivityForResult(i, REQUEST_CODE);
	}
	
	public void showMoreLinks(View view){
		//Toast.makeText(getApplicationContext(), "Show More Links",Toast.LENGTH_SHORT).show();
		
		Intent i = new Intent(this, MoreContentListView.class);
  		i.putExtra("contentType", "Links");          		
        startActivityForResult(i, REQUEST_CODE);
	}
}
