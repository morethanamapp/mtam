package com.development.mtam;

import java.util.List;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.graphics.Matrix;
import android.os.Bundle;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.View.OnTouchListener;
import android.view.WindowManager;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.Gallery;
import android.widget.ImageView;
import android.widget.AdapterView.OnItemClickListener;

public class PhotoViewer extends Activity {
	
	private int imgSelected;
	private Gallery g;
	private int currentIndex;
	public ImageLoader imageLoader;
	
	private AppFrame appDelegate;
	private Landmark activeLmk;
	
	private Button backButton;
	private Button fwdButton;
	
	private ProgressDialog MyDialog;
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.photos_gallery_view);
        
        imgSelected = 0;
        appDelegate = ((AppFrame)this.getApplicationContext());
	    activeLmk = appDelegate.getCurrentLandmark();
        
        g = (CustomGallery) findViewById(R.id.photos_gallery);
        g.setOnItemClickListener(new OnItemClickListener() {
            public void onItemClick(AdapterView<?> parent, View v, int position, long id) {
                //Toast.makeText(Mainmenu.this, "" + position, Toast.LENGTH_SHORT).show();
 					            	
            }
 	   });
      
 	   g.setOnTouchListener(new OnTouchListener (){
 		   public boolean onTouch(View v, MotionEvent event) {
 			
 			   currentIndex = g.getSelectedItemPosition();
 			   //Toast.makeText(Mainmenu.this, " VIEWING "+currentIndex, Toast.LENGTH_SHORT).show();
 			   return false;
 		   }
    	  
 	   });
 	   
 	   g.setAdapter(new ImageAdapter(this,activeLmk.getGallery()));
	   g.setSelection(imgSelected, true);
	   currentIndex = imgSelected;
 	   
 	   backButton = (Button) findViewById(R.id.backbutton);
 	   backButton.setOnClickListener(new View.OnClickListener() {
 		   public void onClick(View v) {
 			   currentIndex--;
 			   if(currentIndex < 0){currentIndex = (g.getCount() - 1);}
 			   g.setSelection(currentIndex, true);
          }
 	   });
      
 	   fwdButton = (Button) findViewById(R.id.fwdbutton);
 	   fwdButton.setOnClickListener(new View.OnClickListener() {
 		   public void onClick(View v) {
       	   
 			   int gCount = g.getCount();        	   
 			   currentIndex++;
 			   if(currentIndex > gCount-1){currentIndex = 0;}		       		       					       
 			   g.setSelection(currentIndex, true);
 		   }
 	   }); 	    	  
 	   
       MyDialog = new ProgressDialog(this);
       MyDialog.setTitle("");
       MyDialog.setMessage(" Loading. Please wait ... ");
       MyDialog.setIndeterminate(true);
       MyDialog.setCancelable(true);
	}
	
	public class ImageAdapter extends BaseAdapter {
        
    	private Context mContext;    	
        private List<String> imgARR;
        
        public ImageAdapter(Context c, List<String> thumbs){
            mContext = c;
            imgARR = thumbs;
            imageLoader = new ImageLoader(c.getApplicationContext());
        }

        public int getCount() {
            return imgARR.size();
        }

        public Object getItem(int position) {
            return null;
        }

        public long getItemId(int position) {
            return 0;
        }

        // create a new ImageView for each item referenced by the Adapter
        public View getView(int position, View convertView, ViewGroup parent) {
            ImageView imageView;
            if (convertView == null) {  // if it's not recycled, initialize some attributes
            	
            	/*Display display = getWindowManager().getDefaultDisplay();*/
            	
            	/*int widthParam = 680;
            	int heightParam = 510;
            	float coordx = 0;
            	float coordy = 0;*/
            	/*double scalex = widthParam/420;
            	double scaley = heightParam/315;*/
            	
                imageView = new ImageView(mContext);                 
                //imageView.setLayoutParams(new Gallery.LayoutParams(widthParam, heightParam));
                
                /*Matrix imgMatrix = new Matrix();
            	imgMatrix.setScale(new Float(2.80), new Float(2.80),coordx, coordy);
                imageView.setImageMatrix(imgMatrix);
                imageView.setScaleType(ImageView.ScaleType.MATRIX);*/
                imageView.setScaleType(ImageView.ScaleType.FIT_CENTER);
                imageView.setPadding(0, 0, 0, 0);
                imageView.setLayoutParams( new Gallery.LayoutParams(WindowManager.LayoutParams.MATCH_PARENT, WindowManager.LayoutParams.MATCH_PARENT));
                
                /*ViewGroup.LayoutParams lparams = imageView.getLayoutParams();                
                Display display = getWindowManager().getDefaultDisplay();                                
                int screenWidth = display.getWidth();
                
                lparams.width = screenWidth; //LayoutParams.FILL_PARENT;
                lparams.height = LayoutParams.WRAP_CONTENT;               
                imageView.setLayoutParams(lparams);*/                
                
            } else {
                imageView = (ImageView) convertView;
            }
            
            imageView.setTag(imgARR.get(position));
            imageLoader.DisplayImage(imgARR.get(position), ((Activity) mContext), imageView);            
            
            return imageView;
        }        
    }
}
