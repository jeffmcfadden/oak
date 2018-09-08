require 'test_helper'

class NavigationTest < ActionDispatch::IntegrationTest

  test "The public posts page can load" do
    puts "I'm here!"
    
    get '/posts'
    assert_equal 200, status    
  end

end
