package com.development.mtam;

import java.util.List;

import com.development.myutils.FeedParser;
import com.development.myutils.FeedParserFactory;
import com.development.myutils.ParserType;
import com.development.myutils.mapviewballoons.CustomBalloonItemizedOverlay;
import com.google.android.maps.GeoPoint;
import com.google.android.maps.MapActivity;
import com.google.android.maps.MapController;
import com.google.android.maps.MapView;
import com.google.android.maps.MyLocationOverlay;
import com.google.android.maps.Overlay;
import com.google.android.maps.OverlayItem;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.location.Location;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.animation.AccelerateInterpolator;
import android.view.animation.Animation;
import android.view.animation.TranslateAnimation;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.ViewFlipper;
import android.widget.AdapterView.OnItemClickListener;

public class Mapp extends MapActivity {
	
	private static final int REQUEST_CODE = 10;
	private ViewFlipper maininterface;
	
	private ImageButton listBackButton;
	private ImageButton listLayersButton;
	private ImageButton mapviewButton;
	
	private ImageButton mappBackButton;	
	private ImageButton listviewButton;	
	private ImageButton locationButton;	
	private ImageButton mappLayersButton;
	
	private MapView mapview;
	private ListView listview;
	
	private MapController mc;
	private List<Overlay> mapOverlays;
	private Drawable drawable;
	private AppFrame appDelegate;
	
	private List<Landmark> lmks;
	private ProgressDialog MyDialog;
	private Location mylocation;
	private Boolean isShowingLocation;
	private MyLocationOverlay myLocationOverlay;
	private CustomBalloonItemizedOverlay mylocationballoonOverlay;
	private CustomBalloonItemizedOverlay balloonOverlay;
	public ImageLoader imageLoader;
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
	    requestWindowFeature(Window.FEATURE_NO_TITLE);
	    setContentView(R.layout.mapp_and_list);
	        
	    maininterface = (ViewFlipper) findViewById(R.id.mainflipper);
	    appDelegate = ((AppFrame)this.getApplicationContext());
	    mylocation = appDelegate.getLocation();	    	    
	    
	    isShowingLocation = false;
	    
	    listBackButton = (ImageButton) findViewById(R.id.listbackButton);
	    listBackButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
            	finish();
            }
        });
	    
	    mappBackButton = (ImageButton) findViewById(R.id.mappbackButton);
	    mappBackButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
            	finish();
            }
        });	    
	    
	    listviewButton = (ImageButton) findViewById(R.id.listviewButton);
	    listviewButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
            	maininterface.setInAnimation(inFromRightAnimation());
            	maininterface.setOutAnimation(outToLeftAnimation());
            	maininterface.showNext();
            }
        });
	    
	    mapviewButton = (ImageButton) findViewById(R.id.mappviewButton);
	    mapviewButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
            	maininterface.setInAnimation(inFromLeftAnimation());
            	maininterface.setOutAnimation(outToRightAnimation());
            	maininterface.showPrevious();
            }
        });
	    
	    listLayersButton = (ImageButton) findViewById(R.id.listlayersButton);
	    listLayersButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
            	showLayers();
            }
        });
	    
	    mappLayersButton = (ImageButton) findViewById(R.id.mapplayersButton);
	    mappLayersButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
            	showLayers();
            }
        });
	    
	    locationButton = (ImageButton) findViewById(R.id.locationButton);
	    locationButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
            	showLocation();
            }
        });
	    
	    listview = (ListView) findViewById(R.id.listview);
	    listview.setDividerHeight(2);
	    listview.setOnItemClickListener(new OnItemClickListener() {
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
            	
            	Landmark apoint = lmks.get(position);
        		appDelegate.setCurrentlandmark(apoint);
            	
            	Intent i = new Intent(Mapp.this, LandmarkPointView.class);          		          	
            	Mapp.this.startActivityForResult(i, REQUEST_CODE);
            	
            }
        });
	    
	    mapview = (MapView) findViewById(R.id.mapview);
	    mapview.setBuiltInZoomControls(true);
        mapview.setSatellite(false);
        mapOverlays = mapview.getOverlays();
        
        GeoPoint point = new GeoPoint((int)(mylocation.getLatitude() * 1e6),(int)(mylocation.getLongitude() * 1e6));
        
        mc = mapview.getController();
        mc.animateTo(point);
        mc.setZoom(15);
        mapview.invalidate();
        //showLocation();
        
        MyDialog = new ProgressDialog(this);
        MyDialog.setTitle("");
        MyDialog.setMessage(" Loading. Please wait ... ");
        MyDialog.setIndeterminate(true);
        MyDialog.setCancelable(true);
        
        loadFeed(ParserType.ANDROID_SAX);
        
	}
	
	private void loadFeed(ParserType type){
		
    	RetreiveFeedTask task = new RetreiveFeedTask();
    	
    	//String staticLink = "http://www.morethanamapp.org/request/get-mapp-points.php?lat=40.8716660&long=-73.8392810";
    	String genLink = "http://www.morethanamapp.org/request/get-mapp-points.php?lat=%f&long=%f";
    	String genlinkformated = String.format(genLink, mylocation.getLatitude(), mylocation.getLongitude());
    	
    	//task.execute(new String[] { "http://www.mic.com/events/manager/mobile_event_list.php?mode=ret_files" });
    	task.execute(genlinkformated);
    	
    	MyDialog.show();
    }
    
    public class RetreiveFeedTask extends AsyncTask<String, Void, List<Landmark>> {
    	    	    	
    	@Override
    	protected List<Landmark> doInBackground(String... params) {
    		try {
    			
    			FeedParser parser = FeedParserFactory.getParser(params[0], ParserType.ANDROID_SAX);
    			return parser.parse();
    			
    		}catch (Exception e) {                
                throw new RuntimeException(e);            
            }
    		
    	}
    	@Override
    	protected void onPostExecute(List<Landmark> feed) {
    		
    		lmks = feed;
    		appDelegate.setNearLandmarks(feed);
    		
    		listview.setAdapter(new LandmarkAdapter(Mapp.this, lmks));
    		Mapp.this.addMapPoints(lmks);
    		
	    	MyDialog.dismiss();
        }
    }
	
	
	//OTHER METHODS
	
    private void addMapPoints(List<Landmark> points){
    	
    	drawable = this.getResources().getDrawable(R.drawable.pin_green_v2);    	
    	
    	balloonOverlay = new CustomBalloonItemizedOverlay(drawable,mapview);
    	int minLat = Integer.MAX_VALUE;
    	int minLong = Integer.MAX_VALUE;
    	int maxLat = Integer.MIN_VALUE;
    	int maxLong = Integer.MIN_VALUE;
    	
    	for (Landmark apoint : points){
    		
    		GeoPoint point = new GeoPoint((int)(apoint.getLatitude() * 1e6),(int)(apoint.getLongtitude() * 1e6));
    		
    		minLat  = Math.min( point.getLatitudeE6(), minLat);
   		 	minLong = Math.min( point.getLongitudeE6(), minLong);
   		 	maxLat  = Math.max( point.getLatitudeE6(), maxLat);
   		 	maxLong = Math.max( point.getLongitudeE6(), maxLong);
    		
    		OverlayItem overlayitem = new OverlayItem(point, apoint.getTitle(), apoint.getAddress());
    		balloonOverlay.addOverlay(overlayitem);    		    	
    		
    		//allOverlays.add(balloonOverlay);
    	}
    	
    	if(points.size() > 10){
    	
    		Landmark closestLandmark = points.get((int)points.size() - (int)points.size()/3);
    	
    		if(closestLandmark.getDistance() > 3){
    		
    			GeoPoint point = new GeoPoint((int)(mylocation.getLatitude() * 1e6),(int)(mylocation.getLongitude() * 1e6));
    		
    			minLat  = point.getLatitudeE6();
   		 		minLong = point.getLongitudeE6();
   		 		maxLat  = point.getLatitudeE6();
   		 		maxLong = point.getLongitudeE6();
    		
   		 		GeoPoint point2 = new GeoPoint((int)(closestLandmark.getLatitude() * 1e6),(int)(closestLandmark.getLongtitude() * 1e6));
    		    		
    		
   		 		minLat  = Math.min( point2.getLatitudeE6(), minLat);
   		 		minLong = Math.min( point2.getLongitudeE6(), minLong);
   		 		maxLat  = Math.max( point2.getLatitudeE6(), maxLat);
   		 		maxLong = Math.max( point2.getLongitudeE6(), maxLong);
   		 	   		 	
    		}
    	}
    	    	
    	mapOverlays.add(balloonOverlay);    	    
    	
    	mapview.getController().zoomToSpan(Math.abs( minLat - maxLat ), Math.abs( minLong - maxLong ));
    	mapview.invalidate();
    	
    	showLocation();
    	
    }
    
	@Override
	protected boolean isRouteDisplayed() {
		
		return false;
	}	
	
	
	public void showLayers(){
		
		//final CharSequence[] locations = {"All Points", "More Than A Month Points", "Mapper Points", "My Bookmarks", "Search"};
		final CharSequence[] locations = {"All Points", "More Than A Month Points", "Mapper Points", "My Bookmarks"};
		
		
		AlertDialog.Builder builder = new AlertDialog.Builder(this);
	    builder.setTitle("LAYERS");

	    builder.setItems(locations, new DialogInterface.OnClickListener()
	    {
	        public void onClick(DialogInterface dialog, int which)
	        {
	        	Mapp.this.layerSelected(which);
	        } 
	    });

	    AlertDialog dlg = builder.create();
	    dlg.show();
		
	}
	
	public void layerSelected(int which){
		
		if(which == 0){
			//All Points
			
			Intent i = new Intent(this, StateSelectView.class);			
	        startActivityForResult(i, REQUEST_CODE);
			
		}else if(which == 1){
			//More Than A Month Points
			
			Intent i = new Intent(this, LandmarkLayerListView.class);
			i.putExtra("pointtype", "film");
			i.putExtra("stateINT", -1);
			i.putExtra("title", "More Than A Month Points");
	        startActivityForResult(i, REQUEST_CODE);
			
		}else if(which == 2){
			//Mapper Points
			
			Intent i = new Intent(this, LandmarkLayerListView.class);
			i.putExtra("pointtype", "user");
			i.putExtra("stateINT", -1);
			i.putExtra("title", "Mapper Points");
	        startActivityForResult(i, REQUEST_CODE);
	        
		}else if(which == 3){
			//My Bookmarks
			
			Intent i = new Intent(this, BookmarkListView.class);
			startActivityForResult(i, REQUEST_CODE);
			
		}else if(which == 4){
			//Search
			
			Toast.makeText(getApplicationContext(), "Search Coming Soon...",Toast.LENGTH_SHORT).show();
		}		
	}
	
	public void showLocation(){
		
		if(isShowingLocation){
						 		
			//mapOverlays.remove(mylocationballoonOverlay);
			
			//Toast.makeText(getApplicationContext(), "Remove My Location",Toast.LENGTH_SHORT).show();
			
			mapview.getOverlays().clear();
			mapview.getOverlays().add(balloonOverlay);
			
			mapview.invalidate();
			
			//myLocationOverlay.disableCompass();
			/*myLocationOverlay.disableMyLocation();
			mapOverlays.remove(myLocationOverlay);*/
			isShowingLocation = false;
			
		}else{
			
			Drawable mydrawable = this.getResources().getDrawable(R.drawable.pin_mylocation);
			
			mylocationballoonOverlay = new CustomBalloonItemizedOverlay(mydrawable,mapview);
			
			GeoPoint point = new GeoPoint((int)(mylocation.getLatitude() * 1e6),(int)(mylocation.getLongitude() * 1e6));
			
			OverlayItem overlayitem = new OverlayItem(point, "You Are Here", "...");
			mylocationballoonOverlay.addOverlay(overlayitem); 
			
			mapview.getOverlays().add(mylocationballoonOverlay);
			//mapOverlays.add(mylocationballoonOverlay);
			
			mapview.invalidate();
			
			/*myLocationOverlay = new MyLocationOverlay(this, mapview);
			mapOverlays.add(myLocationOverlay);
	        //myLocationOverlay.enableCompass(); // if you want to display a compass also
	        myLocationOverlay.enableMyLocation();*/
			
			isShowingLocation = true;
		}					
	}
	
	//LIST ADAPTER
	public class LandmarkAdapter extends BaseAdapter {
        
    	private Context mContext;    	
        private List<Landmark> lmkARR;
        private LayoutInflater inflater = null;
        
        public LandmarkAdapter(Context c, List<Landmark> msg){
            mContext = c;
            lmkARR = msg;
            imageLoader = new ImageLoader(c.getApplicationContext());
            inflater = (LayoutInflater)c.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        }

        public int getCount() {
            return lmkARR.size();
        }

        public Object getItem(int position) {
            return null;
        }

        public long getItemId(int position) {
            return 0;
        }
        
        public class ViewHolder{
        	public ImageView imageView;
            public TextView item_title;
            public TextView item_desc;
            public TextView item_distance;
        }
        
        // create a new ImageView for each item referenced by the Adapter
        public View getView(int position, View convertView, ViewGroup parent) {
        	View vi=convertView;
            ViewHolder holder;
            
            if(convertView==null){
                vi = inflater.inflate(R.layout.listview_item_row, null);
                holder=new ViewHolder();
                holder.imageView = (ImageView)vi.findViewById(R.id.srcimage);
                holder.item_title = (TextView)vi.findViewById(R.id.item_title);
                holder.item_desc = (TextView)vi.findViewById(R.id.item_desc);
                holder.item_distance = (TextView)vi.findViewById(R.id.item_distance);
                vi.setTag(holder);
            }
            else{
                holder = (ViewHolder)vi.getTag();
            }
            
            holder.item_title.setText(lmkARR.get(position).getTitle());            
            holder.item_desc.setText(lmkARR.get(position).getDescription());
            
            String distance_str = "%.1f mi";            
            holder.item_distance.setText(String.format(distance_str, lmkARR.get(position).getDistance()));
            
            holder.imageView.setTag(lmkARR.get(position).getPhoto());
            imageLoader.DisplayImage(lmkARR.get(position).getPhoto(), ((Activity) mContext), holder.imageView);
            
            return vi;
        }        
    }
	
	
	//ANIMATION METHODS
	private Animation inFromRightAnimation() {

		Animation inFromRight = new TranslateAnimation(
				Animation.RELATIVE_TO_PARENT,  +1.0f, Animation.RELATIVE_TO_PARENT,  0.0f,
				Animation.RELATIVE_TO_PARENT,  0.0f, Animation.RELATIVE_TO_PARENT,   0.0f
		);
		
		inFromRight.setDuration(500);
		inFromRight.setInterpolator(new AccelerateInterpolator());
		return inFromRight;
	}
	
	private Animation outToLeftAnimation() {
		Animation outtoLeft = new TranslateAnimation(
				Animation.RELATIVE_TO_PARENT,  0.0f, Animation.RELATIVE_TO_PARENT,  -1.0f,
				Animation.RELATIVE_TO_PARENT,  0.0f, Animation.RELATIVE_TO_PARENT,   0.0f
		);
		outtoLeft.setDuration(500);
		outtoLeft.setInterpolator(new AccelerateInterpolator());
		return outtoLeft;
	}

	private Animation inFromLeftAnimation() {
		Animation inFromLeft = new TranslateAnimation(
				Animation.RELATIVE_TO_PARENT,  -1.0f, Animation.RELATIVE_TO_PARENT,  0.0f,
				Animation.RELATIVE_TO_PARENT,  0.0f, Animation.RELATIVE_TO_PARENT,   0.0f
		);
		inFromLeft.setDuration(500);
		inFromLeft.setInterpolator(new AccelerateInterpolator());
		return inFromLeft;
	}
	
	private Animation outToRightAnimation() {
		Animation outtoRight = new TranslateAnimation(
				Animation.RELATIVE_TO_PARENT,  0.0f, Animation.RELATIVE_TO_PARENT,  +1.0f,
				Animation.RELATIVE_TO_PARENT,  0.0f, Animation.RELATIVE_TO_PARENT,   0.0f
		);
		outtoRight.setDuration(500);
		outtoRight.setInterpolator(new AccelerateInterpolator());
		return outtoRight;
	}
	
}
