class User
end

Oak.configure do |config|
  config.author_class = "User"
  
  config.site_name = "Oak TEST"
  
  config.site_description = "Oak Test Site"
  
  config.posts_per_page = 4
  
  config.tags_to_exclude_from_home_page = ["micro"]
  
end