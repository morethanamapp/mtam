package com.development.myutils;

import java.util.ArrayList;
import java.util.List;

import org.xml.sax.Attributes;

import com.development.mtam.Landmark;

import android.sax.Element;
import android.sax.EndElementListener;
import android.sax.EndTextElementListener;
import android.sax.RootElement;
import android.sax.StartElementListener;
import android.util.Xml;

public class AndroidSaxFeedParser extends BaseFeedParser {

	//static final String RSS = "rss";
	static final String FEED = "feed";
	private List<String> lmkgallery;
	private List<String> lmklinks;
	private List<String> lmkvideos;
	private List<String> lmkaudios;
	
	private Landmark currentMessage;
	private List<Landmark> landmarks = new ArrayList<Landmark>();
	
	public AndroidSaxFeedParser(String feedUrl) {
		super(feedUrl);
	}

	public List<Landmark> parse() {
		/*final Message currentMessage = new Message();
		RootElement root = new RootElement(RSS);
		final List<Message> messages = new ArrayList<Message>();
		Element channel = root.getChild(CHANNEL);
		Element item = channel.getChild(ITEM);*/
		
		//final Landmark currentMessage = new Landmark();
		
		//final List<Landmark> landmarks = new ArrayList<Landmark>();
		
		RootElement root = new RootElement(FEED);
		
		Element entry = root.getChild(ITEM);
		
		Element gallery = entry.getChild(GALLERY);
		Element links = entry.getChild(LINKS);
		Element videos = entry.getChild(VIDEOS);
		Element audios = entry.getChild(AUDIOS);	
		
		entry.setEndElementListener(new EndElementListener(){
			public void end() {
				landmarks.add(currentMessage.copy());
			}
		});
		entry.setStartElementListener(new StartElementListener(){			
			public void start(Attributes attributes) {
				currentMessage = new Landmark();
			}
		});
		
		gallery.setEndElementListener(new EndElementListener(){
			public void end() {
				currentMessage.setGallery(lmkgallery);
				
			}
		});
		gallery.setStartElementListener(new StartElementListener(){			
			public void start(Attributes attributes) {				
				
				lmkgallery = new ArrayList<String>();							
			}			
		});
		
		links.setEndElementListener(new EndElementListener(){
			public void end() {
				currentMessage.setLinks(lmklinks);				
			}
		});
		links.setStartElementListener(new StartElementListener(){			
			public void start(Attributes attributes) {
				
				lmklinks = new ArrayList<String>();
			}			
		});
		
		videos.setEndElementListener(new EndElementListener(){
			public void end() {
				currentMessage.setVideos(lmkvideos);				
			}
		});
		videos.setStartElementListener(new StartElementListener(){			
			public void start(Attributes attributes) {
				
				lmkvideos = new ArrayList<String>();
				
			}			
		});
		
		audios.setEndElementListener(new EndElementListener(){
			public void end() {
				currentMessage.setAudios(lmkaudios);
				
			}
		});
		audios.setStartElementListener(new StartElementListener(){			
			public void start(Attributes attributes) {
				
				lmkaudios = new ArrayList<String>();								
			}			
		});
		
		entry.getChild(TITLE).setEndTextElementListener(new EndTextElementListener(){
			public void end(String body) {
				currentMessage.setTitle(body);
			}
		});
		entry.getChild(DESCRIPTION).setEndTextElementListener(new EndTextElementListener(){
			public void end(String body) {
				currentMessage.setDescription(body);
			}
		});
		
		links.getChild(LINK).setEndTextElementListener(new EndTextElementListener(){
			public void end(String body) {
				lmklinks.add(body);
			}
		});
		
		gallery.getChild(IMAGE).setEndTextElementListener(new EndTextElementListener(){
			public void end(String body) {				
				lmkgallery.add(body);
			}
		});
		
		videos.getChild(VIDEO).setEndTextElementListener(new EndTextElementListener(){
			public void end(String body) {				
				lmkvideos.add(body);				
			}
		});
		
		audios.getChild(AUDIO).setEndTextElementListener(new EndTextElementListener(){
			public void end(String body) {				
				lmkaudios.add(body);
			}
		});
		
		entry.getChild(ID).setEndTextElementListener(new EndTextElementListener(){
			public void end(String body) {
				currentMessage.setLandmarkID(Integer.parseInt(body));
			}
		});
		entry.getChild(EXCERPT).setEndTextElementListener(new EndTextElementListener(){
			public void end(String body) {
				currentMessage.setExcerpt(body);
			}
		});
		entry.getChild(PHOTO).setEndTextElementListener(new EndTextElementListener(){
			public void end(String body) {
				currentMessage.setPhoto(body);
			}
		});
		entry.getChild(ADDRESS).setEndTextElementListener(new EndTextElementListener(){
			public void end(String body) {
				currentMessage.setAddress(body);
			}
		});	
		entry.getChild(DISTANCE).setEndTextElementListener(new EndTextElementListener(){
			public void end(String body) {
				currentMessage.setDistance(Float.parseFloat(body));
			}
		});
		entry.getChild(LONG).setEndTextElementListener(new EndTextElementListener(){
			public void end(String body) {
				currentMessage.setLongtitude(Float.parseFloat(body));
			}
		});
		entry.getChild(LAT).setEndTextElementListener(new EndTextElementListener(){
			public void end(String body) {
				currentMessage.setLatitude(Float.parseFloat(body));
			}
		});
		
		try {
			Xml.parse(this.getInputStream(), Xml.Encoding.UTF_8, root.getContentHandler());
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
		
		return landmarks;
	}
}
