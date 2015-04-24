package com.development.mtam;

import java.io.File;
import java.util.List;

import android.app.Activity;
import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.media.AudioManager;
import android.net.Uri;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.webkit.MimeTypeMap;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.ImageButton;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.AdapterView.OnItemClickListener;

public class MoreContentListView extends Activity {
	
	private static final int REQUEST_CODE = 10;
	
	private AppFrame appDelegate;
	private Landmark activeLmk;
	
	private ListView lv;
	private ImageButton backButton;
	private TextView listTitle;
	
	private String contentType;
	private String listItemTile;
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
	    requestWindowFeature(Window.FEATURE_NO_TITLE);
	    setContentView(R.layout.landmark_layer_list_view);
	    
	    Bundle extras = getIntent().getExtras();
        if (extras == null) {
        	return;
        }               
        
        contentType = extras.getString("contentType");               
        
        appDelegate = ((AppFrame)this.getApplicationContext());
        activeLmk = appDelegate.getCurrentLandmark();
        
        backButton = (ImageButton) findViewById(R.id.backButton);
	    backButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
            	finish();
            }
        });
        
        listTitle = (TextView) findViewById(R.id.list_title);
	    listTitle.setText(contentType);
	    
	    lv = (ListView) findViewById(R.id.layerlistview);
	    lv.setDividerHeight(2);
	    lv.setOnItemClickListener(new OnItemClickListener() {
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
            	
            	showContent(position);
            	
            }
        });
	    
	    if(contentType.equals("Videos")){
	    	lv.setAdapter(new TheListAdapter(this, activeLmk.getVideos()));
	    	listItemTile = "Video";
	    }else if(contentType.equals("Audios")){
	    	lv.setAdapter(new TheListAdapter(this, activeLmk.getAudios()));
	    	listItemTile = "Audio";
	    }else if(contentType.equals("Links")){
	    	lv.setAdapter(new TheListAdapter(this, activeLmk.getLinks()));
	    	listItemTile = "Link";
	    }
	}
	
	@Override
	public void onResume(){
		
		//AudioManager audioManager = (AudioManager) getSystemService(AUDIO_SERVICE);

		AudioManager mAudioManager = (AudioManager) this.getSystemService(Context.AUDIO_SERVICE);
		if (mAudioManager.isMusicActive()) {

			Intent i = new Intent("com.android.music.musicservicecommand"); 
			i.putExtra("command", "pause"); this.sendBroadcast(i); 
		}
		
		super.onResume();
	}
	
	private void showContent(int position){
		
		if(contentType.equals("Videos")){
			
			Intent intent = new Intent(Intent.ACTION_VIEW, 
    				Uri.parse(activeLmk.getVideos().get(position)));
    		startActivity(intent);
			
		}else if(contentType.equals("Audios")){
			
			ContentResolver cR = this.getContentResolver();
			MimeTypeMap mime = MimeTypeMap.getSingleton();
			String type = mime.getExtensionFromMimeType(cR.getType(Uri.parse(activeLmk.getAudios().get(position))));
			
			if(type.equals("mp3")){
				
				Intent intent = new Intent();
				intent.setAction(android.content.Intent.ACTION_VIEW);
				File file = new File(activeLmk.getAudios().get(position));
				intent.setDataAndType(Uri.fromFile(file), "audio/*");
				startActivity(intent);
				
			}else{
				
				Intent i = new Intent(this, InWebView.class);
	      		i.putExtra("url", activeLmk.getAudios().get(position));          		
	            startActivityForResult(i, REQUEST_CODE);
	            
			}
			
		}else if(contentType.equals("Links")){
			
			Intent i = new Intent(this, InWebView.class);
      		i.putExtra("url", activeLmk.getLinks().get(position));
            startActivityForResult(i, REQUEST_CODE);
            
		}    
	}
	
	//LIST ADAPTER
	public class TheListAdapter extends BaseAdapter {
        
    	private Context mContext;    	
        private List<String> lmkARR;
        private LayoutInflater inflater = null;
        
        public TheListAdapter(Context c, List<String> msg){
            mContext = c;
            lmkARR = msg;            
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
            public TextView item_title;
            public TextView item_desc;            
        }
        
        // create a new ImageView for each item referenced by the Adapter
        public View getView(int position, View convertView, ViewGroup parent) {
        	View vi=convertView;
            ViewHolder holder;
            
            if(convertView==null){
                vi = inflater.inflate(R.layout.morecontentlistview_item_row, null);
                holder=new ViewHolder();
                
                holder.item_title = (TextView)vi.findViewById(R.id.item_title);
                holder.item_desc = (TextView)vi.findViewById(R.id.item_desc);
                
                vi.setTag(holder);
            }
            else{
                holder = (ViewHolder)vi.getTag();
            }
            int final_pos = position+1;
            holder.item_title.setText(listItemTile+" "+(final_pos));            
            holder.item_desc.setText(lmkARR.get(position));                       
            
            return vi;
        }        
    }
}
