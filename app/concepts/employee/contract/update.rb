module Employee::Contract

  class Update < Base

    validates :name, :email, :vacation_days, presence: true

    validate do
      errors.add(:supervisor, :last_supervisor) if model.supervisor == true &&
        ['0', 0, false].include?(self.supervisor) &&
        Employee.last_supervisor?
    end

    def save
      attributes = self.to_nested_hash
      # don't override the existing password if no new one is given
      attributes.select { |_, value| value.present? }
      model.update_attributes(attributes)
    end

  end

end
