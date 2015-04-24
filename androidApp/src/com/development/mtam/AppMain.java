package com.development.mtam;

import com.facebook.android.Facebook;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.widget.Button;

public class AppMain extends Activity {
	
	private Button aboutButton;
	private Button addapointButton;
	private Button mappButton;
	private Button infoButton;
	
	private static final int REQUEST_CODE = 10;
	
	// application id from facebook.com/developers
	public static final String APP_ID = "222123861164178";
	// log tag for any log.x statements	
	public static final String TAG = "FACEBOOK CONNECT";
	
	// facebook vars
	private Facebook mFacebook;	
	
	private Location loc;
	private LocationListener locationListener;
	private LocationManager locationManager;
	private AppFrame appDelegate;
	
	@Override
	 public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
	    requestWindowFeature(Window.FEATURE_NO_TITLE);
	    setContentView(R.layout.main);
	    
	    mFacebook = new Facebook(APP_ID);	    
	    
	    appDelegate = ((AppFrame)this.getApplicationContext());
	    appDelegate.setLoginOk(false);	    
	    	    
	    
	    SharedPreferences prefs = this.getSharedPreferences("userlogin", 0);
	    if(prefs.contains("usertype")){
	    	String type = prefs.getString("usertype", "");
	    	if(type.equals("MTAMAccount")){
	    		appDelegate.setUserid(prefs.getString("userid", null));
		    	appDelegate.setUsername(prefs.getString("username", null));
		    	appDelegate.setLoginOk(true);
	    	}else if(type.equals("FBAccount")){
	    		
	    		String access_token = prefs.getString("fb_access_token", null);
	            long expires = prefs.getLong("fb_access_expires", 0);
	            if(access_token != null) {
	            	mFacebook.setAccessToken(access_token);
	            }
	            if(expires != 0) {
	            	mFacebook.setAccessExpires(expires);
	            }
	    		
	            if(mFacebook.isSessionValid()){
	            	appDelegate.setUserid(prefs.getString("userid", null));
			    	appDelegate.setUsername(prefs.getString("username", null));
			    	appDelegate.setLoginOk(true);
	            }
	            
	    	}
	    	
	    }else{
	    	
	    	prefs.edit().clear().commit();
	    	
	    }
	    
	    appDelegate.setFacebookObj(mFacebook);
	    
	    aboutButton = (Button) findViewById(R.id.aboutbutton);
	    aboutButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
            	
            	Intent i = new Intent(AppMain.this, About.class); 	    	   
                startActivityForResult(i, REQUEST_CODE);
            }
        });
	    
	    addapointButton = (Button) findViewById(R.id.addapointbutton);
	    addapointButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
            	//Toast.makeText(getApplicationContext(), "Selected Add a point",Toast.LENGTH_SHORT).show();
            	Intent i = new Intent(AppMain.this, AddAPoint.class); 	    	   
                startActivityForResult(i, REQUEST_CODE);
            }
        });
	    
	    mappButton = (Button) findViewById(R.id.mappbutton);
	    mappButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
            	
            	Intent i = new Intent(AppMain.this, Mapp.class); 	    	   
                startActivityForResult(i, REQUEST_CODE);
            }
        });
	    
	    infoButton = (Button) findViewById(R.id.infobutton);
	    infoButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
            	
            	Intent i = new Intent(AppMain.this, InfoView.class);
            	i.putExtra("section", "appmain");
                startActivityForResult(i, REQUEST_CODE);
            }
        });
	    
	    
	    locationManager = (LocationManager) this.getSystemService(Context.LOCATION_SERVICE);
        // Define a listener that responds to location updates
        locationListener = new LocationListener() {
            public void onLocationChanged(Location location) {
              // Called when a new location is found by the network location provider.
            	if(location != null){
            		makeUseOfNewLocation(location);
            	}
            }

            public void onStatusChanged(String provider, int status, Bundle extras) {}

            public void onProviderEnabled(String provider) {}

            public void onProviderDisabled(String provider) {}
          };

        // Register the listener with the Location Manager to receive location updates        
        locationManager.requestLocationUpdates(LocationManager.NETWORK_PROVIDER, 0, 0, locationListener);
        Location lastKnownLocation = locationManager.getLastKnownLocation(LocationManager.NETWORK_PROVIDER);
        
        if(lastKnownLocation != null){
        	makeUseOfNewLocation(lastKnownLocation);
        }
	    
	 }
	
	protected void makeUseOfNewLocation(Location lt){
		
		loc = new Location(lt);
		appDelegate.setLocation(loc);		
		
		//mylocation.setLatitude(lt.getLatitude());
		//mylocation.setLongitude(lt.getLongitude());
	}
	
	@Override
	public void finish() {
		locationManager.removeUpdates(locationListener);
		super.finish();
	}
}
