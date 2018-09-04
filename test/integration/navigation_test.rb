require 'test_helper'

class NavigationTest < ActionDispatch::IntegrationTest

  test "The public posts page can load" do
    get oak_posts_path
    assert_equal 200, status    
  end

end
