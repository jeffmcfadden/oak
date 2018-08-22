module Oak
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    
    before_action :set_time_zone
    
    def set_time_zone
      Time.zone = 'America/Phoenix'
    end
    
  end
end
