package com.development.mtam;

import java.util.List;
import com.development.myutils.FeedParser;
import com.development.myutils.FeedParserFactory;
import com.development.myutils.ParserType;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.AdapterView.OnItemClickListener;

public class BookmarkListView extends Activity {
	
	private static final int REQUEST_CODE = 10;
	
	private ListView lv;
	private ProgressDialog MyDialog;
	private ImageButton backButton;
	private TextView listTitle;
	private List<Landmark> lmks;
	private AppFrame appDelegate;	
	
	public ImageLoader imageLoader;
	private String bookmarklist = "";
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
	    requestWindowFeature(Window.FEATURE_NO_TITLE);
	    setContentView(R.layout.bookmark_list_view);
	    
	    appDelegate = ((AppFrame)this.getApplicationContext());        
        
        backButton = (ImageButton) findViewById(R.id.backButton);
	    backButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
            	finish();
            }
        });
	    
	    listTitle = (TextView) findViewById(R.id.list_title);
	    listTitle.setText("Bookmarks");
        
	    lv = (ListView) findViewById(R.id.layerlistview);
	    lv.setDividerHeight(2);
	    lv.setOnItemClickListener(new OnItemClickListener() {
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
            	
            	Landmark apoint = lmks.get(position);
        		appDelegate.setCurrentlandmark(apoint);
            	
            	Intent i = new Intent(BookmarkListView.this, LandmarkPointView.class);          		          	
            	BookmarkListView.this.startActivityForResult(i, REQUEST_CODE);
            	
            }
        });
	    
	    
	    //GRAB BOOKMARK LISTING
	    
	    SharedPreferences prefs = this.getSharedPreferences("mtamBookmarks", 0);
	    if(prefs.contains("mtamBookmarkcount")){
	    	
	    	int size = prefs.getInt("mtamBookmarkcount", 0);
			int curvalue = -1;
			
			for(int i=0; i<size; i++){
				curvalue = prefs.getInt("BookmarkEntry_"+i, 0);
				
				//bookmarklist.concat(curvalue+",");
				bookmarklist = bookmarklist+curvalue+",";
			}
			
			//Toast.makeText(getApplicationContext(), ""+curvalue,Toast.LENGTH_SHORT).show();
			
			/*bookmarks[size] = activeLmk.getLandmarkID();			
			
			SharedPreferences.Editor editor = prefs.edit();  
			editor.putInt("mtamBookmarkcount", bookmarks.length);  
			
			for(int i=0;i<bookmarks.length;i++){  
			    editor.putInt("BookmarkEntry_" + i, bookmarks[i]);
			}						
			
			editor.commit();*/
	    	
	    }else{
	    	//Alert NO Bookmarks Found
	    	
	    	AlertDialog.Builder builder = new AlertDialog.Builder(this);
			builder.setMessage("Sorry, you do not have any bookmarks").setPositiveButton("OK", dialogClickListener).show();
	    	
	    }
	    
	    
	    MyDialog = new ProgressDialog(this);
        MyDialog.setTitle("");
        MyDialog.setMessage(" Loading. Please wait ... ");
        MyDialog.setIndeterminate(true);
        MyDialog.setCancelable(true);
        
        loadFeed(ParserType.ANDROID_SAX);
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
	
	private void loadFeed(ParserType type){
		
    	RetreiveFeedTask task = new RetreiveFeedTask();    	    
    	
    	//String staticLink = "http://www.morethanamapp.org/request/get-mapp-points.php?lat=40.8716660&long=-73.8392810";
    	
    	String genLink = "http://www.morethanamapp.org/request/get-mapp-points.php?lat=0&long=0&get_all=%s&bookmarklist=%s";
    	String genlinkformated = String.format(genLink, "bookmarks", bookmarklist);
    	    	   	    	
    	//Toast.makeText(getApplicationContext(), genlinkformated,Toast.LENGTH_SHORT).show();
    	
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
    		appDelegate.setSecondaryLandmarks(feed);
    		
    		lv.setAdapter(new LandmarkAdapter(BookmarkListView.this, lmks));    		    		
	    	MyDialog.dismiss();
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
                
                holder.item_distance.setVisibility(View.INVISIBLE);
                
                vi.setTag(holder);
            }
            else{
                holder = (ViewHolder)vi.getTag();
            }
            
            holder.item_title.setText(lmkARR.get(position).getTitle());            
            holder.item_desc.setText(lmkARR.get(position).getDescription());
            
            /*String distance_str = "%.1f mi";            
            holder.item_distance.setText(String.format(distance_str, lmkARR.get(position).getDistance()));*/
            
            holder.imageView.setTag(lmkARR.get(position).getPhoto());
            imageLoader.DisplayImage(lmkARR.get(position).getPhoto(), ((Activity) mContext), holder.imageView);
            
            return vi;
        }        
    }
	
	
}
