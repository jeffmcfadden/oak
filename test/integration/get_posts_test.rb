require 'test_helper'

class GetPostsTest < ActionDispatch::IntegrationTest

  include Oak::Engine.routes.url_helpers

  setup do
    @routes = Oak::Engine.routes
  end

  test "The public posts page can load" do
    get posts_path
    assert_equal 200, status    
  end

end
