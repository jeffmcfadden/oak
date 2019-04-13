module Oak
  module WordpressMimicry
    extend ActiveSupport::Concern
  
    class_methods do
    end
  
    included do
    end
    
    # string   post_id
    # string   post_title1
    # datetime post_date1
    # datetime post_date_gmt1
    # datetime post_modified1
    # datetime post_modified_gmt1
    # string   post_status1
    # string   post_type1
    # string   post_format1
    # string   post_name1
    # string   post_author1 author id
    # string   post_password1
    # string   post_excerpt1
    # string   post_content1
    # string   post_parent1
    # string   post_mime_type1
    # string   link1
    # string   guid1
    # int      menu_order1
    # string   comment_status1
    # string   ping_status1
    # bool     sticky1
    # struct   post_thumbnail1: See wp.getMediaItem.
    # array    terms
    # struct:  See wp.getTerm
    # array    custom_fields
    # struct   enclosure
    def fields_for_wordpress
      {
        post_id: "#{id}"
        post_title: "#{title}"
        post_date: "#{published_at}"
        post_date_gmt: "#{published_at.utc}"
        post_modified: "#{updated_at}"
        post_modified_gmt: "#{updated_at.utc}"
        post_status: "#{live? ? : "publish" : "draft"}"
        post_type: "post"
        post_format: ""
        post_name: "#{slug}"
        post_author: "1"
        post_password: ""
        post_excerpt: ""
        post_content: "#{body_html}"
        post_parent: "0"
        post_mime_type: "text/html"
        link: ""
        guid: ""
        menu_order: ""
        comment_status: ""
        ping_status: ""
        sticky: ""
        post_thumbnail: {}
        terms: []
        custom_fields: []
        enclosure: {}
      }
    end
    
    def new_from_wordpress_fields(fields)
      post = Post.new({
        title: fields[:post_title],
        body: fields[:post_content],
        published_at: fields[:date],
        live: fields[:post_status] == "publish" ? true : false
      })
      
      post.tag_list = fields[:terms].join( "," )
      post
    end
    
  end
end