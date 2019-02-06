Oak.configure do |config|
  config.author_class = "User"
  
  config.site_name = "Oak TEST"
  
  config.site_description = "Oak Test Site"
  
  config.posts_per_page = 4
  
  config.tags_to_exclude_from_home_page = ["micro"]
  
end

ENV['AWS_ACCESS_KEY'] = "AKIAQWERRPIADFXGSJQ"
ENV['AWS_SECRET_KEY'] = "CjBLCfdxasdf35p08dua;"
ENV['AWS_BUCKET'] = "my.blog.assets"
ENV['AWS_REGION'] = "us-west-1"
