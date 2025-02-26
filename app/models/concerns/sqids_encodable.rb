module SqidsEncodable
  extend ActiveSupport::Concern

  # How to Use Sqids in Rails to Obfuscate IDs
  # https://dev.to/thierrychau/how-to-use-sqids-in-rails-to-obfuscate-ids-30md

  # arguments here are optional ; you can change the alphabet to change the encoding sequence
  SQIDS = Sqids.new(alphabet: "aQs52qPmVFSJx3ybMvrcOpeYK7EHz6g1lLwDuCjXRo08kUBdZGTnAht4fiI9NW", min_length: 12)

  def to_param
    sqid
  end

  def sqid
    SQIDS.encode([ id ])
  end

private

  class_methods do
    def find_by_sqid(sqid)
      decoded_id = SQIDS.decode(sqid).first
      find(decoded_id) if decoded_id
    end
  end
end
