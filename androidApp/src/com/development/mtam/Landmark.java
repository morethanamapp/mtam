package com.development.mtam;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

public class Landmark implements Comparable<Landmark>{
	static SimpleDateFormat FORMATTER = new SimpleDateFormat("EEE, dd MMM yyyy HH:mm:ss Z");
	
	private int landmarkid;
	private String title;
	private String description;
	private String excerpt;
	private String photo;
	private String address;
	private float longtitude;
	private float latitude;
	private float distance;
	private List<String> gallery;
	private List<String> videos;
	private List<String> audios;
	private List<String> links;
	
	private Date date;	
			
	public int getLandmarkID(){
		return landmarkid;
	}
	
	public void setLandmarkID(int value){
		
		this.landmarkid = value;
	}
	
	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title.trim();
	}	
	
	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description.trim();
	}
	
	public String getExcerpt(){
		return excerpt;
	}
	
	public void setExcerpt(String value){
		this.excerpt = value.trim();
	}
	
	public String getAddress(){
		return address;
	}
	
	public void setAddress(String value){
		this.address = value.trim();
	}
	
	public float getLongtitude(){
		return longtitude;
	}
	
	public void setLongtitude(float value){
		this.longtitude = value;
	}
	
	public float getLatitude(){
		return latitude;
	}
	
	public void setLatitude(float value){
		this.latitude = value;
	}
	
	public float getDistance(){
		return distance;
	}
	
	public void setDistance(float value){
		this.distance = value;
	}
	
	public void setPhoto(String path){
		this.photo = path.trim();
	}
	
	public String getPhoto(){
		return photo;
	}
	
	public List<String> getGallery() {
		return gallery;
	}
	
	public void setGallery(List<String> value){
		this.gallery = value;
	}	
	
	public List<String> getVideos() {
		return videos;
	}
	
	public void setVideos(List<String> value){
		this.videos = value;
	}	
	
	public List<String> getAudios() {
		return audios;
	}
	
	public void setAudios(List<String> value){
		this.audios = value;
	}		
	
	public List<String> getLinks() {
		return links;
	}
	
	public void setLinks(List<String> value){
		this.links = value;
	}		
	
	public String getDate() {
		return FORMATTER.format(this.date);
	}

	public void setDate(String date) {
		// pad the date if necessary
		while (!date.endsWith("00")){
			date += "0";
		}
		try {
			this.date = FORMATTER.parse(date.trim());
		} catch (ParseException e) {
			throw new RuntimeException(e);
		}
	}
	
	public Landmark copy(){
		Landmark copy = new Landmark();
		
		copy.landmarkid = this.landmarkid;
		copy.title = this.title;		
		copy.description = this.description;
		copy.date = this.date;		
		copy.address = this.address;
		copy.distance = this.distance;
		copy.excerpt = this.excerpt;		
		copy.latitude = this.latitude;
		copy.longtitude = this.longtitude;
		copy.photo = this.photo;
		
		copy.audios = this.audios;
		copy.gallery = this.gallery;
		copy.videos = this.videos;
		copy.links = this.links;
				
		return copy;
	}
	
	@Override
	public String toString() {
		StringBuilder sb = new StringBuilder();
		sb.append("Title: ");
		sb.append(title);
		sb.append('\n');
				
		sb.append("Description: ");
		sb.append(description);
		sb.append('\n');
		
		sb.append("Videos: ");
		sb.append(videos);
		sb.append('\n');
		
		return sb.toString();
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((date == null) ? 0 : date.hashCode());
		result = prime * result
				+ ((description == null) ? 0 : description.hashCode());		
		result = prime * result + ((title == null) ? 0 : title.hashCode());
		return result;
	}
	
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Landmark other = (Landmark) obj;
		if (date == null) {
			if (other.date != null)
				return false;
		} else if (!date.equals(other.date))
			return false;
		if (description == null) {
			if (other.description != null)
				return false;
		} else if (!description.equals(other.description))
			return false;		
		if (title == null) {
			if (other.title != null)
				return false;
		} else if (!title.equals(other.title))
			return false;
		return true;
	}

	public int compareTo(Landmark another) {
		if (another == null) return 1;
		// sort descending, most recent first
		return another.date.compareTo(date);
	}
}
