package com.development.mtam;

import java.util.List;

import com.facebook.android.Facebook;
import com.google.android.maps.Overlay;

import android.app.Application;
import android.location.Location;

public class AppFrame extends Application {
	
	private Location mylocation;
	private Landmark currentLandmark;
	private List<Landmark> nearlmks;
		
	private List<Landmark> secondarylmks;
	
	private List<Overlay> currentMapOverlay;
	
	private Boolean loginOK;
	
	private String username;
	private String userid;
	
	private Facebook mfacebook;
	
	public Facebook getFacebookObj(){
		return mfacebook;
	}
	
	public void setFacebookObj(Facebook value){
		mfacebook = value;
	}
	
	public Boolean getLoginOk(){
		return loginOK;
	}
	
	public void setLoginOk(Boolean value){
		loginOK = value;
	}
	
	public void setUsername(String value){
		username = value;
	}
	
	public String getUsername(){
		return username;
	}
	
	public void setUserid(String value){
		userid = value;
	}
	
	public String getUserid(){
		return userid;
	}	
	
	public Location getLocation(){
		
		return mylocation;
	}
	
	public void setLocation(Location value){
		mylocation = value;
	}
	
	public Landmark getCurrentLandmark(){
		return currentLandmark;
	}
	
	public void setCurrentlandmark(Landmark value){
		currentLandmark = value;
	}
	
	public List<Landmark> getNearLandmarks(){
		return nearlmks;
	}
	
	public void setNearLandmarks(List<Landmark> value){
		nearlmks = value;
	}
	
	public List<Landmark> getSecondaryLandmarks(){
		
		return secondarylmks;
	}
	
	public void setSecondaryLandmarks(List<Landmark> value){
		secondarylmks = value;
	}
		
	
	public void setCurrentMapOverlay(List<Overlay> value){
		
		currentMapOverlay = value;
		
	}
	
	public List<Overlay> getCurrentMapOverlay(){
		
		return currentMapOverlay;
	}
}
