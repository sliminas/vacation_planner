class Employee::Contract::Create < Reform::Form

  property :name
  property :email
  property :password
  property :vacation_days
  property :taken_vacation_days
  property :supervisor, default: 0

  validation do
    required(:name) { filled? & min_size?(3) }
    required(:email) { filled? & format?(RFC822::EMAIL_REGEXP_WHOLE) }
    required(:password)  { filled? & min_size?(10) }
    required(:vacation_days) { filled? & type?(Integer) }
    required(:taken_vacation_days) { filled? > type?(Integer) }
    required(:supervisor).bool?
  end

end
