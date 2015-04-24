package com.development.myutils;
import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;

public abstract class BaseFeedParser implements FeedParser {

	// names of the XML tags
	static final String CHANNEL = "channel";
	static final String PUB_DATE = "pubDate";
	static final  String DESCRIPTION = "details";
	
	//GENERAL XML Tags
	static final  String ITEM = "landmark";
	static final  String TITLE = "title";		
	
	//MTAM XML Tags
	static final String ID = "landmarkid";
	static final String EXCERPT = "excerpt";
	static final String PHOTO = "photo";
	static final String ADDRESS = "address";
	static final String LONG = "longtitude";
	static final String LAT = "latitude";
	static final String DISTANCE = "distance";
	
	static final String GALLERY = "gallery";
	static final String IMAGE = "image";
	
	static final String VIDEOS = "videos";
	static final String VIDEO = "video";
	
	static final String LINKS = "links";
	static final String LINK = "link";
	
	static final String AUDIOS = "audios";
	static final String AUDIO = "audio";
	
	static final String EVENTDATE = "eventdate";
	
	private final URL feedUrl;

	protected BaseFeedParser(String feedUrl){
		try {
			this.feedUrl = new URL(feedUrl);
		} catch (MalformedURLException e) {
			throw new RuntimeException(e);
		}
	}

	protected InputStream getInputStream() {
		try {
			return feedUrl.openConnection().getInputStream();
		} catch (IOException e) {
			throw new RuntimeException(e);
		}
	}
}