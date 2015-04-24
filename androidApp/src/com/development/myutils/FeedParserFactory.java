package com.development.myutils;
public abstract class FeedParserFactory {
	
	private static String feedUrl;
	
	public static FeedParser getParser(String url){
		return getParser(url,ParserType.ANDROID_SAX);
	}
	
	public static FeedParser getParser(String url,ParserType type){
		setFeedUrl(url);
		switch (type){
			case SAX:
				return new SaxFeedParser(feedUrl);
			case DOM:
				return new DomFeedParser(feedUrl);
			case ANDROID_SAX:
				return new AndroidSaxFeedParser(feedUrl);
			case XML_PULL:
				return new XmlPullFeedParser(feedUrl);
			default: return null;
		}
	}
	
	public static void setFeedUrl(String url){
		feedUrl = url;
	}
}
