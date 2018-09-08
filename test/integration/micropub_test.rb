require 'test_helper'

class MicropubTest < ActionDispatch::IntegrationTest

  include Oak::Engine.routes.url_helpers

  setup do
    @routes = Oak::Engine.routes
    
    @user = User.find_or_create_by email: "test@example.com"
    
    @token  = Oak::IndieauthAuthorizationRequest.find_or_create_by access_token: "TESTTOKEN", approved: true, user_id: @user.id
    
  end

  test "Discovering the Micropub endpoint given the profile URL of a user" do
    skip( "Pending" )
  end

  test "Authenticating requests by including the access token in the HTTP Authorization header" do
    skip( "Pending" )
  end

  test "Authenticating requests by including the access token in the post body for x-www-form-urlencodedrequests" do
    skip( "Pending" )
  end
  
  test "Limiting the ability to create posts given an access token by requiring that the access token contain at least one OAuth 2.0 scope value" do
    skip( "Pending" )
  end
  
  test "Creating a post using x-www-form-urlencoded syntax with one or more properties" do
    post micropub_post_path, params: "h=entry&content=Micropub+test+of+creating+a+basic+h-entry", headers: { "Authorization" => "Bearer #{@token.access_token}"}
    
    @post = Oak::Post.last
    
    assert_equal 201, status    
    assert_equal "Micropub test of creating a basic h-entry", @post.body
    assert_equal post_url(@post), headers['Location']    
  end
  
  test "Create an h-entry post with multiple categories (form-encoded)" do
    post micropub_post_path, params: "h=entry&content=Micropub+test+of+creating+a+basic+h-entry&category[]=tag1&category[]=tag2", headers: { "Authorization" => "Bearer #{@token.access_token}"}
    
    @post = Oak::Post.last
    
    assert_equal 201, status    
    assert_equal "Micropub test of creating a basic h-entry", @post.body
    assert @post.tag_list.include? "tag1"
    assert @post.tag_list.include? "tag2"
    assert_equal post_url(@post), headers['Location']    
  end
  
  test "Create an h-entry with a photo referenced by URL (form-encoded)" do
    post micropub_post_path, params: "h=entry&content=Micropub+test+of+creating+a+basic+h-entry&category[]=tag1&category[]=tag2&photo=https%3A%2F%2Fmicropub.rocks%2Fmedia%2Fsunset.jpg", headers: { "Authorization" => "Bearer #{@token.access_token}"}
    
    @post = Oak::Post.last
    
    assert_equal 201, status    
    assert @post.body.include? "sunset.jpg"
    assert_equal post_url(@post), headers['Location']        
  end
  
  test "Create an h-entry post with one category (form-encoded)" do
    skip( "Pending" )
  end
  
  

  test "Create an h-entry post (JSON)" do
    
    data = {
      "type" => ["h-entry"],
      "properties" => {
        "content" => ["Micropub test of creating an h-entry with a JSON request"]
      }
    }
    
    post micropub_post_path, params: data.to_json, headers: { "Authorization" => "Bearer #{@token.access_token}", "Content-type" => "application/json" }
    
    @post = Oak::Post.last
    
    assert_equal 201, status    
    assert_equal "Micropub test of creating an h-entry with a JSON request", @post.body
    assert_equal post_url(@post), headers['Location']    
  end

  test "Create an h-entry post with multiple categories (JSON)" do
  end
  
  test "Create an h-entry with HTML content (JSON)" do
  end
  
  test "Create an h-entry with a photo referenced by URL (JSON)" do
  end
  
  test "Create an h-entry post with a nested object (JSON)" do
  end
  
  test "Create an h-entry post with a photo with alt text (JSON)" do
  end
  
  test "Create an h-entry with multiple photos referenced by URL (JSON)" do
  end
  
  
  
  
  test "Create an h-entry with a photo (multipart)" do
  end
  
  test "Create an h-entry with two photos (multipart)" do
  end
  
  
  
  
  test "Replace a property" do
  end
  
  test "Add a value to an existing property" do
  end
  
  test "Add a value to a non-existent property" do
  end
  
  test "Remove a value from a property" do
  end
  
  test "Remove a property" do
  end
  
  test "Reject the request if operation is not an array" do
  end
  
  
  
  
  
  test "Delete a post (form-encoded)" do
  end
  
  test "Delete a post (JSON)" do
  end
  
  test "Undelete a post (form-encoded)" do
  end
  
  test "Undelete a post (JSON)" do
  end
  
  
  
  test "Configuration Query" do
  end
  
  test "Syndication Endpoint Query" do
  end
  
  test "Source Query (All Properties)" do
  end
  
  test "Source Query (Specific Properties)" do
  end
  
  
  
  
  
  test "Upload a jpg to the Media Endpoint" do
  end
  
  test "Upload a png to the Media Endpoint" do
  end
  
  test "Upload a gif to the Media Endpoint" do
  end
  
  
  
  
  test "Accept access token in HTTP header" do
  end
  
  test "Accept access token in POST body" do
  end
  
  test "Does not store access token property" do
  end
  
  test "Rejects unauthenticated requests" do
  end
  
  test "Rejects unauthorized access tokens" do
  end



end
