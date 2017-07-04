class CreateVacationRequests < ActiveRecord::Migration[5.1]

  def change
    create_table :vacation_requests do |t|
      t.string :state, null: false
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.float :vacation_days, null: false
      t.float :total_days, null: false
      t.references :employee

      t.timestamps
    end

    add_foreign_key :vacation_requests, :employees
  end

end
