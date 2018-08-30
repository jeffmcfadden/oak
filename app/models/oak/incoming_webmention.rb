module Oak
  class IncomingWebmention < ApplicationRecord
    validates :source_url, presence: true
    validates :target_url, presence: true
  end
end
