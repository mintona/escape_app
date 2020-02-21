class User < ApplicationRecord
  validates_presence_of :first_name,
                        :last_name,
                        # :uid,
                        :google_token,
                        :email

  validates_uniqueness_of :email
end
