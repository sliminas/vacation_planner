class Employee < ApplicationRecord

  devise :database_authenticatable, :rememberable

  has_many :vacation_requests

  include Sortable

  scope :supervisors, -> { where(supervisor: true) }

  def self.last_supervisor?
    self.supervisors.count <= 1
  end

  def remaining_vacation_days
    vacation_days - taken_vacation_days - pending_vacation_days
  end

  def pending_vacation_days
    vacation_requests.pending.pluck(:vacation_days).sum.to_f
  end

end
