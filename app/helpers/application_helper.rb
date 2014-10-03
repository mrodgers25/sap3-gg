module ApplicationHelper

  def location_options
    location_options = "<strong>CA-San Francisco (SF)</strong>​<br>
                        ​<strong>CA-Los Angeles (LA)</strong>​<br>
                        ​<strong>CA-San Diego (SD)</strong>​<br>
                        <strong>IL-Chicago (CHI)</strong><br>
                        ​<strong>LA-New Orleans (NOLA)</strong><br>
                        ​<strong>MA-Boston (BOS)</strong>​<br>
                        ​<strong>NY-New York City (NYC)</strong>​<br>
                        ​<strong>OR-Portland (PORT)</strong><br>
                        ​<strong>PA-Philadelphia (PHIL)</strong><br>
                        ​<strong>TX-Austin (AUST)</strong>​<br>"
  end

  def category_options
    category_options = "​<strong>(A) Attraction</strong>​<br>
                        ​<strong>(FD) Food & Drink</strong>​<br>
                        ​<strong>(L) Lodging</strong>​<br>
                        ​<strong>(SH) Shopping</strong>​<br>
                        ​<strong>(SR) Services</strong>​<br>
                        ​<strong>(SP) Sports & Activities</strong>​"
  end

  def story_category_options
    story_category_options = "<strong>(ED) Editor Picks</strong><br>
                        ​<strong>(UN) More Unique Than Usual</strong>​<br>
                        ​<strong>(TL) Top/Best/Coolest Lists</strong>​<br>
                        ​<strong>(SI) Suggested Itineraries</strong>​<br>
                        ​<strong>(FF) Family Friendly</strong>​<br>
                        ​<strong>(IA) Industry Awards</strong>​<br>
                        ​<strong>(P) Pet Friendly</strong>​"

  end

end