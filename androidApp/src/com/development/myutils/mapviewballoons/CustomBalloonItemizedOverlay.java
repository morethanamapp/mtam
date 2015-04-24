package com.development.myutils.mapviewballoons;

import java.util.ArrayList;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.drawable.Drawable;
import com.development.mtam.AppFrame;
import com.development.mtam.Landmark;
import com.development.mtam.LandmarkPointView;
import com.google.android.maps.MapView;
import com.google.android.maps.OverlayItem;

public class CustomBalloonItemizedOverlay extends BalloonItemizedOverlay<OverlayItem> {
	
	private static final int REQUEST_CODE = 10;
	
	private ArrayList<OverlayItem> mOverlays = new ArrayList<OverlayItem>();
	
	private AppFrame appDelegate;
	private MapView mpview;
	final Context mContext;
	
	public CustomBalloonItemizedOverlay(Drawable defaultMarker, MapView mapView) {
		super(boundCenterBottom(defaultMarker), mapView);
		mContext = mapView.getContext();
		mpview = mapView;
		appDelegate = ((AppFrame)mContext.getApplicationContext());
	}
	
	public void addOverlay(OverlayItem overlay) {
		mOverlays.add(overlay);
		populate();
	}
	
	@Override
	protected OverlayItem createItem(int i) {
		return mOverlays.get(i);
	}

	@Override
	public int size() {
		return mOverlays.size();
	}
	
	@Override
	protected boolean onBalloonTap(int index, OverlayItem item) {
		
		if(!item.getTitle().equals("You Are Here")){
		
			Landmark apoint = appDelegate.getNearLandmarks().get(index);
			appDelegate.setCurrentlandmark(apoint);
		
			//Toast.makeText(mContext, "Index Selected "+index, Toast.LENGTH_SHORT).show();
		
			Intent i = new Intent(mContext, LandmarkPointView.class); 
			((Activity) mContext).startActivityForResult(i, REQUEST_CODE);
			
			
			return true;
		}else{
			
			return false;			
		}		
	}

}
