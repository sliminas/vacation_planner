class DeviseCreateEmployees < ActiveRecord::Migration[5.1]

  def change
    create_table :employees do |t|
      t.string :name, null: false
      ## Database authenticatable
      t.string :email,              null: false, default: '', unique: true
      t.string :encrypted_password, null: false, default: ''
      ## Rememberable
      t.datetime :remember_created_at

      t.float :vacation_days, null: false, default: 0.0
      t.float :taken_vacation_days, null: false, default: 0.0
      t.boolean :supervisor, default: false

      t.timestamps null: false
    end

    add_index :employees, :email,                unique: true
  end

end
