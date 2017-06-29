class CreateVacationRequests < ActiveRecord::Migration[5.1]

  def change
    create_table :vacation_requests do |t|
      t.string :state, null: false
      t.date :start, null: false
      t.date :end, null: false
      t.float :vacation_days, null: false
      t.float :total_days, null: false
      t.references :employee

      t.timestamps
    end

    add_foreign_key :vacation_requests, :employees
  end

end
