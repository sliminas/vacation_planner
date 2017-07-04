module Employee::Contract

  class Create < Base

    validates :name, :email, :password, :vacation_days, presence: true

  end

end
