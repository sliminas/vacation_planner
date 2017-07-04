require 'reform/form/validation/unique_validator'

module Employee::Contract

  class Base < Reform::Form

    model :employee

    property :name
    property :email
    property :password
    property :vacation_days
    property :supervisor, default: false

    validates :name, length: { minimum: 3 }
    validates :email, format: { with: RFC822::EMAIL_REGEXP_WHOLE }, unique: true
    validates :password, length: { minimum: 10 }, allow_blank: true
    validates :vacation_days, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
    validates :supervisor,inclusion: { in: [true, false, 0, 1, '0', '1'] }

  end

end
