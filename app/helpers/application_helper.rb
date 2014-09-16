module ApplicationHelper

  def location_options
    @location_options = "<strong>NYC</strong><br>
                        ​<strong>SD</strong>​<br>
                        ​<strong>LA</strong>​<br>
                        ​<strong>SF</strong>​<br>
                        ​<strong>CHI</strong><br>
                        ​<strong>BOS</strong>​<br>
                        ​<strong>DC</strong>​<br>
                        ​<strong>SEA</strong><br>
                        ​<strong>PHIL</strong><br>
                        ​<strong>PORT</strong>​<br>
                        ​<strong>AUST</strong>​<br>
                        ​<strong>NOLA</strong>​"
  end
  helper_method :location_options

end
