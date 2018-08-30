require 'aws-sdk-s3'

module Oak
  class PostAsset < ApplicationRecord
    has_one_attached :file
    
    after_commit :make_public
    
    def public_url
      region     = ENV["AWS_REGION"]
      access_key = ENV["AWS_ACCESS_KEY"]
      secret_key = ENV["AWS_SECRET_KEY"]
      bucket     = ENV["AWS_BUCKET"]
    
      s3 = Aws::S3::Client.new( { region: region, credentials: Aws::Credentials.new( access_key, secret_key ) } )
      bucket = Aws::S3::Bucket.new( name: bucket, client: s3 )
      
      bucket.object(self.file.blob.key).public_url
    end
    
    def make_public
      region     = ENV["AWS_REGION"]
      access_key = ENV["AWS_ACCESS_KEY"]
      secret_key = ENV["AWS_SECRET_KEY"]
      bucket     = ENV["AWS_BUCKET"]
    
      s3 = Aws::S3::Client.new( { region: region, credentials: Aws::Credentials.new( access_key, secret_key ) } )
      s3.put_object_acl( { acl: "public-read", bucket: bucket, key: self.file.blob.key } )
    end
    
  end
end
