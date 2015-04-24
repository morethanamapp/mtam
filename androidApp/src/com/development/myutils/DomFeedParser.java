package com.development.myutils;
import java.util.ArrayList;
import java.util.List;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;


import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.development.mtam.Landmark;

public class DomFeedParser extends BaseFeedParser {

	protected DomFeedParser(String feedUrl) {
		super(feedUrl);
	}

	public List<Landmark> parse() {
		DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
		List<Landmark> landmarks = new ArrayList<Landmark>();
		try {
			DocumentBuilder builder = factory.newDocumentBuilder();
			Document dom = builder.parse(this.getInputStream());
			Element root = dom.getDocumentElement();
			NodeList items = root.getElementsByTagName(ITEM);
			for (int i=0;i<items.getLength();i++){
				Landmark landmark = new Landmark();
				Node item = items.item(i);
				NodeList properties = item.getChildNodes();
				for (int j=0;j<properties.getLength();j++){
					Node property = properties.item(j);
					String name = property.getNodeName();
					if (name.equalsIgnoreCase(TITLE)){
						landmark.setTitle(property.getFirstChild().getNodeValue());
					}  else if (name.equalsIgnoreCase(DESCRIPTION)){
						StringBuilder text = new StringBuilder();
						NodeList chars = property.getChildNodes();
						for (int k=0;k<chars.getLength();k++){
							text.append(chars.item(k).getNodeValue());
						}
						landmark.setDescription(text.toString());
					} else if (name.equalsIgnoreCase(PUB_DATE)){
						landmark.setDate(property.getFirstChild().getNodeValue());
					}
				}
				landmarks.add(landmark);
			}
		} catch (Exception e) {
			throw new RuntimeException(e);
		} 
		return landmarks;
	}
}
