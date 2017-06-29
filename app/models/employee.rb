class Employee < ApplicationRecord

  devise :database_authenticatable, :rememberable

  has_many :vacation_requests

end
