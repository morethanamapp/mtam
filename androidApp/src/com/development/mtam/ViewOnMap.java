package com.development.mtam;

import java.util.List;

import com.development.myutils.mapviewballoons.CustomBalloonItemizedOverlay;
import com.google.android.maps.GeoPoint;
import com.google.android.maps.MapActivity;
import com.google.android.maps.MapController;
import com.google.android.maps.MapView;
import com.google.android.maps.Overlay;
import com.google.android.maps.OverlayItem;

import android.graphics.drawable.Drawable;
import android.location.Location;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.widget.ImageButton;

public class ViewOnMap extends MapActivity {
	
	private ImageButton mappBackButton;
	private ImageButton locationButton;
	
	private MapView mapview;
	
	private MapController mc;
	private List<Overlay> mapOverlays;
	private Drawable drawable;
	private AppFrame appDelegate;
	private Landmark activeLmk;
	
	private Location mylocation;
	private Boolean isShowingLocation;
	private CustomBalloonItemizedOverlay mylocationballoonOverlay;
	private CustomBalloonItemizedOverlay balloonOverlay;
	public ImageLoader imageLoader;
		
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
	    requestWindowFeature(Window.FEATURE_NO_TITLE);
	    setContentView(R.layout.view_on_mapp);
	    
	    appDelegate = ((AppFrame)this.getApplicationContext());
	    activeLmk = appDelegate.getCurrentLandmark();
	    mylocation = appDelegate.getLocation();
	    
	    isShowingLocation = false;
	    
	    mappBackButton = (ImageButton) findViewById(R.id.mappbackButton);
	    mappBackButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
            	finish();
            }
        });
	    
	    locationButton = (ImageButton) findViewById(R.id.locationButton);
	    locationButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
            	showLocation();
            }
        });
	    
	    mapview = (MapView) findViewById(R.id.mapview);
	    mapview.setBuiltInZoomControls(true);
        mapview.setSatellite(false);
        mapOverlays = mapview.getOverlays();
        
        //GeoPoint point = new GeoPoint((int)(mylocation.getLatitude() * 1e6),(int)(mylocation.getLongitude() * 1e6));\
        GeoPoint point = new GeoPoint((int)(activeLmk.getLatitude() * 1e6),(int)(activeLmk.getLongtitude() * 1e6));
        
        drawable = this.getResources().getDrawable(R.drawable.pin_green_v2);
        balloonOverlay = new CustomBalloonItemizedOverlay(drawable,mapview);
        OverlayItem overlayitem = new OverlayItem(point, activeLmk.getTitle(), activeLmk.getAddress());
		balloonOverlay.addOverlay(overlayitem);
        
		mapOverlays.add(balloonOverlay);
        
        mc = mapview.getController();
        mc.animateTo(point);
        mc.setZoom(15);
        mapview.invalidate();
        
	}
	
	public void showLocation(){
		
		if(isShowingLocation){
						 								
			mapview.getOverlays().clear();
			mapview.getOverlays().add(balloonOverlay);
			
			GeoPoint point = new GeoPoint((int)(activeLmk.getLatitude() * 1e6),(int)(activeLmk.getLongtitude() * 1e6));
						
	        mc.animateTo(point);
	        mc.setZoom(15);
			
			mapview.invalidate();
						
			isShowingLocation = false;
			
		}else{
			
			Drawable mydrawable = this.getResources().getDrawable(R.drawable.pin_mylocation);
			
			mylocationballoonOverlay = new CustomBalloonItemizedOverlay(mydrawable,mapview);
			
			GeoPoint point = new GeoPoint((int)(mylocation.getLatitude() * 1e6),(int)(mylocation.getLongitude() * 1e6));
			
			OverlayItem overlayitem = new OverlayItem(point, "You Are Here", "...");
			mylocationballoonOverlay.addOverlay(overlayitem); 
			
			mapview.getOverlays().add(mylocationballoonOverlay);
			
			int minLat = (int)(activeLmk.getLatitude() * 1e6);
	    	int minLong = (int)(activeLmk.getLongtitude() * 1e6);
	    	int maxLat = (int)(activeLmk.getLatitude() * 1e6);
	    	int maxLong = (int)(activeLmk.getLongtitude() * 1e6);
	    	
	    	minLat  = Math.min( point.getLatitudeE6(), minLat);
   		 	minLong = Math.min( point.getLongitudeE6(), minLong);
   		 	maxLat  = Math.max( point.getLatitudeE6(), maxLat);
   		 	maxLong = Math.max( point.getLongitudeE6(), maxLong);
   		 	
   		 	mc.zoomToSpan((int) Math.abs( (minLat - maxLat)*1.8 ), (int) Math.abs( (minLong - maxLong)*1.8 ));
			
			mapview.invalidate();
			
			isShowingLocation = true;
		}					
	}
	
	@Override
	protected boolean isRouteDisplayed() {
		
		return false;
	}	
}
