package com.development.mtam;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ImageButton;
import android.widget.ListView;
import android.widget.AdapterView.OnItemClickListener;

public class StateSelectForSubmit extends Activity {
	
	private ListView state_list;	
	private ImageButton backButton;
	static final String[] STATELIST = new String[] {"Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","District Of Columbia","Florida","Georgia","Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Carolina","North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington","West Virginia","Wisconsin","Wyoming"};	
	 
	@Override
	public void onCreate(Bundle savedInstanceState) {
	        super.onCreate(savedInstanceState);
	        requestWindowFeature(Window.FEATURE_NO_TITLE);
	        setContentView(R.layout.state_list_view);
	        
	        state_list = (ListView) findViewById(R.id.statelistview);
	        state_list.setDividerHeight(2);
	        state_list.setAdapter(new ArrayAdapter<String>(this,R.layout.state_list_item_row, STATELIST));
	        
	        state_list.setOnItemClickListener(new OnItemClickListener() {
	            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
	                //When clicked, show a toast with the TextView text
	                //Toast.makeText(getApplicationContext(), ((TextView) view).getText(),Toast.LENGTH_SHORT).show();
	                //Toast.makeText(getApplicationContext(), "Selected "+position,Toast.LENGTH_SHORT).show();
	                	            	
	            	returnSelectedState(position);
	            }
	        });
	        
	        backButton = (ImageButton) findViewById(R.id.backButton);
		    backButton.setOnClickListener(new View.OnClickListener() {
	            public void onClick(View v) {
	            	finish();
	            }
	        });
	        
	 }
	 
	 void returnSelectedState(int index) {
		 
		 Intent i = new Intent();		
		 //i.putExtra("selectedstate", STATELIST[index]);
		 i.putExtra("selectedstate", index);
		 setResult(RESULT_OK, i);
		 finish();
	 }
	 
}
