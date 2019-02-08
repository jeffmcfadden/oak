require 'aws-sdk-s3'

module Oak
  class PostAsset < ApplicationRecord
    has_one_attached :file
    
    after_commit :make_public
    
    def public_url
      return "" unless self.file.attached?
      
      region     = ENV["AWS_REGION"]
      access_key = ENV["AWS_ACCESS_KEY"]
      secret_key = ENV["AWS_SECRET_KEY"]
      bucket     = ENV["AWS_BUCKET"]
    
      s3 = Aws::S3::Client.new( { region: region, credentials: Aws::Credentials.new( access_key, secret_key ) } )
      bucket = Aws::S3::Bucket.new( name: bucket, client: s3 )
      
      bucket.object(self.file.blob.key).public_url
    end
    
    def make_public
      return unless self.file.attached?
      
      region     = ENV["AWS_REGION"]
      access_key = ENV["AWS_ACCESS_KEY"]
      secret_key = ENV["AWS_SECRET_KEY"]
      bucket     = ENV["AWS_BUCKET"]
    
      s3 = Aws::S3::Client.new( { region: region, credentials: Aws::Credentials.new( access_key, secret_key ) } )
      
      # Force the content type into AWS, because somehow ActiveStorage isn't doing that.
      # Thanks to this page for the info I needed to figure out how to even set the content type at all: https://github.com/aws/aws-sdk-js/issues/1092
      s3.copy_object( { bucket: ENV["AWS_BUCKET"], key: self.file.blob.key, copy_source: "#{ENV["AWS_BUCKET"]}/#{self.file.blob.key}", content_type: self.file.blob.content_type, metadata_directive: 'REPLACE' } )
      
      # And, make it actually public.
      s3.put_object_acl( { acl: "public-read", bucket: bucket, key: self.file.blob.key } )      
    end
    
  end
end
