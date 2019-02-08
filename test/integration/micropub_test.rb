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
    post micropub_post_path, params: "h=entry&content=Micropub+test+of+creating+a+basic+h-entry&category=tag1", headers: { "Authorization" => "Bearer #{@token.access_token}"}
    
    @post = Oak::Post.last
    
    assert_equal 201, status    
    assert @post.tag_list.include? "tag1"
    assert_equal post_url(@post), headers['Location']        
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
    data = {
      "type" => ["h-entry"],
      "properties" => {
        "content" => ["Micropub test of creating an h-entry with a JSON request containing multiple categories. This post should have two categories, test1 and test2."],
        "category" => [
          "tag1",
          "tag2"
        ]
      }
    }
    
    post micropub_post_path, params: data.to_json, headers: { "Authorization" => "Bearer #{@token.access_token}", "Content-type" => "application/json" }
    
    @post = Oak::Post.last
    
    assert_equal 201, status    
    assert @post.tag_list.include? "tag1"
    assert @post.tag_list.include? "tag2"
    assert_equal post_url(@post), headers['Location']    
  end
  
  test "Create an h-entry with HTML content (JSON)" do
    data = {
      "type" => ["h-entry"],
      "properties" => {
        "content" => [{
          "html" => "<p>This post has <b>bold</b> and <i>italic</i> text.</p>"
        }],
        "category" => [
          "tag1",
          "tag2"
        ]
      }
    }
    
    post micropub_post_path, params: data.to_json, headers: { "Authorization" => "Bearer #{@token.access_token}", "Content-type" => "application/json" }
    
    @post = Oak::Post.last
    
    assert_equal 201, status    
    assert @post.body.include? "<p>This post has <b>bold</b> and <i>italic</i> text.</p>"
    assert_equal post_url(@post), headers['Location']    
  end
  
  test "Create an h-entry with a photo referenced by URL (JSON)" do
    data = {
      "type" => ["h-entry"],
      "properties" => {
        "content" =>["Micropub test of creating a photo referenced by URL. This post should include a photo of a sunset."],
        "photo" => ["https://micropub.rocks/media/sunset.jpg"]
      }
    }
    
    post micropub_post_path, params: data.to_json, headers: { "Authorization" => "Bearer #{@token.access_token}", "Content-type" => "application/json" }
    
    @post = Oak::Post.last
    
    assert_equal 201, status    
    assert @post.body.include? "test of creating a photo"
    assert @post.body.include? "sunset.jpg"
    assert_equal post_url(@post), headers['Location']
  end
  
  test "Create an h-entry post with a nested object (JSON)" do
    data = {
        "type" => [
            "h-entry"
        ],
        "properties" => {
            "published": [
                "2017-05-31T12:03:36-07:00"
            ],
            "content" => [
                "Lunch meeting"
            ],
            "checkin" => [
                {
                    "type" => [
                        "h-card"
                    ],
                    "properties" => {
                        "name" => ["Los Gorditos"],
                        "url" => ["https://foursquare.com/v/502c4bbde4b06e61e06d1ebf"],
                        "latitude" => [45.524330801154],
                        "longitude" => [-122.68068808051],
                        "street-address" => ["922 NW Davis St"],
                        "locality" => ["Portland"],
                        "region" => ["OR"],
                        "country-name" => ["United States"],
                        "postal-code" => ["97209"]
                    }
                }
            ]
        }
    }
    
    post micropub_post_path, params: data.to_json, headers: { "Authorization" => "Bearer #{@token.access_token}", "Content-type" => "application/json" }
    
    @post = Oak::Post.last
    
    # assert_equal 201, status
    # assert @post.body.include? "test of creating a photo"
    # assert @post.body.include? "sunset.jpg"
    # assert_equal post_url(@post), headers['Location']

    skip( "Not yet implemented" )
    
  end
  
  test "Create an h-entry post with a photo with alt text (JSON)" do
    data = {
      "type" => ["h-entry"],
      "properties" => {
        "content" =>["Micropub test of creating a photo referenced by URL. This post should include a photo of a sunset."],
        "photo" => [
              {
                "value" => "https://micropub.rocks/media/sunset.jpg",
                "alt" => "Photo of a sunset"
              }
            ]
      }
    }
    
    post micropub_post_path, params: data.to_json, headers: { "Authorization" => "Bearer #{@token.access_token}", "Content-type" => "application/json" }
    
    @post = Oak::Post.last
    
    assert_equal 201, status    
    assert @post.body.include? "test of creating a photo"
    assert @post.body.include? "sunset.jpg"
    assert @post.body.include? "Photo of a sunset"
    assert_equal post_url(@post), headers['Location']
  end
  
  test "Create an h-entry with multiple photos referenced by URL (JSON)" do
    data = {
      "type" => ["h-entry"],
      "properties" => {
        "content" =>["Micropub test of creating a photo referenced by URL. This post should include a photo of a sunset."],
        "photo" => [
          "https://micropub.rocks/media/sunset.jpg",
          "https://micropub.rocks/media/city-at-night.jpg"
        ]
      }
    }
    
    post micropub_post_path, params: data.to_json, headers: { "Authorization" => "Bearer #{@token.access_token}", "Content-type" => "application/json" }
    
    @post = Oak::Post.last
    
    assert_equal 201, status    
    assert @post.body.include? "test of creating a photo"
    assert @post.body.include? "sunset.jpg"
    assert @post.body.include? "city-at-night.jpg"
    assert_equal post_url(@post), headers['Location']
  end
  
  test "Create an h-entry with a photo (multipart)" do
  end
  
  test "Create an h-entry with two photos (multipart)" do
  end
  
  test "Replace a property" do
    @post = Oak::Post.create title: "Test post for updating", body: "This is the original text."
    
    data = {
      "action" => "update",
      "url" => "#{URI.encode( post_url( @post ) )}",
      "replace" => {
        "content" => ["This is the updated text. If you can see this you passed the test!"]
      }
    }
        
    post micropub_post_path, params: data.to_json, headers: { "Authorization" => "Bearer #{@token.access_token}", "Content-type" => "application/json" }
    
    @post = @post.reload
    
    assert_equal 201, status    
    assert @post.body.include? "This is the updated text"
    assert_equal post_url(@post), headers['Location']    
  end
  
  test "Add a value to an existing property" do
    @post = Oak::Post.create title: "Test post for updating", body: "This is the original text."
    @post.tag_list = "test1"
    @post.save
    
    data = {
      "action" => "update",
      "url" => "#{URI.encode( post_url( @post ) )}",
      "add" => {
        "category" => ["test2"]
      }
    }
        
    post micropub_post_path, params: data.to_json, headers: { "Authorization" => "Bearer #{@token.access_token}", "Content-type" => "application/json" }
    
    @post = @post.reload
    
    assert_equal 201, status    
    assert @post.tag_list.include? "test1"
    assert @post.tag_list.include? "test2"
    assert_equal post_url(@post), headers['Location']    
  end
  
  test "Add a value to a non-existent property" do
    @post = Oak::Post.create title: "Test post for updating", body: "This is the original text."
    
    data = {
      "action" => "update",
      "url" => "#{URI.encode( post_url( @post ) )}",
      "add" => {
        "category" => ["test2"]
      }
    }
        
    post micropub_post_path, params: data.to_json, headers: { "Authorization" => "Bearer #{@token.access_token}", "Content-type" => "application/json" }
    
    @post = @post.reload
    
    assert_equal 201, status    
    assert_equal false, @post.tag_list.include?("test1")
    assert @post.tag_list.include? "test2"
    assert_equal post_url(@post), headers['Location']    
  end
  
  test "Remove a value from a property" do
    @post = Oak::Post.create title: "Test post for removing", body: "This is the original text."
    @post.tag_list = "test1, test2"
    @post.save
    
    data = {
      "action" => "update",
      "url" => "#{URI.encode( post_url( @post ) )}",
      "delete" => {
        "category" => ["test2"]
      }
    }
        
    post micropub_post_path, params: data.to_json, headers: { "Authorization" => "Bearer #{@token.access_token}", "Content-type" => "application/json" }
    
    @post = @post.reload
    
    assert_equal 201, status    
    assert_equal true,  @post.tag_list.include?("test1")
    assert_equal false, @post.tag_list.include?("test2")
    assert_equal post_url(@post), headers['Location']    
  end
  
  test "Remove a property" do
    @post = Oak::Post.create title: "Test post for removing", body: "This is the original text."
    @post.tag_list = "test1, test2"
    @post.save
    
    data = {
      "action" => "update",
      "url" => "#{URI.encode( post_url( @post ) )}",
      "delete" => ["category"]
    }
        
    post micropub_post_path, params: data.to_json, headers: { "Authorization" => "Bearer #{@token.access_token}", "Content-type" => "application/json" }
    
    @post = @post.reload
    
    assert_equal 201, status    
    assert_equal false,  @post.tag_list.include?("test1")
    assert_equal false, @post.tag_list.include?("test2")
    assert_equal post_url(@post), headers['Location']    
  end
  
  test "Reject the request if operation is not an array" do
  end  
  
  test "Delete a post (form-encoded)" do
    post micropub_post_path, params: "h=entry&content=Micropub+test+of+creating+a+basic+h-entry", headers: { "Authorization" => "Bearer #{@token.access_token}"}
    
    @post = Oak::Post.last
    
    assert_equal 201, status    
    assert_equal "Micropub test of creating a basic h-entry", @post.body
    assert_equal post_url(@post), headers['Location']    
    
    url = post_url( @post )

    post micropub_post_path, params: "action=delete&url=#{URI.encode( url )}", headers: { "Authorization" => "Bearer #{@token.access_token}"}
    assert_equal 200, status    
    assert_equal true, body.include?("Deleted")
    assert_raises ActiveRecord::RecordNotFound do
      @post.reload
    end
  end
  
  test "Delete a post (JSON)" do
    post micropub_post_path, params: "h=entry&content=Micropub+test+of+creating+a+basic+h-entry", headers: { "Authorization" => "Bearer #{@token.access_token}"}
    
    @post = Oak::Post.last
    
    assert_equal 201, status    
    assert_equal "Micropub test of creating a basic h-entry", @post.body
    assert_equal post_url(@post), headers['Location']    
    
    url = post_url( @post )

    data = {
      "action" => "delete",
      "url" => "#{URI.encode( post_url( @post ) )}",
    }
        
    post micropub_post_path, params: data.to_json, headers: { "Authorization" => "Bearer #{@token.access_token}", "Content-type" => "application/json" }
    assert_equal 200, status    
    assert_equal true, body.include?("Deleted")
    assert_raises ActiveRecord::RecordNotFound do
      @post.reload
    end    
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
    skip( "This works, but we need to figure out a good way to test." )
  end
  
  test "Upload a png to the Media Endpoint" do
    skip( "This works, but we need to figure out a good way to test." )
  end
  
  test "Upload a gif to the Media Endpoint" do
    skip( "This works, but we need to figure out a good way to test." )
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
