# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

result = Employee::Create.(
  { employee: {
    name: 'Supervisor',
    email: 'supervisor@domain.com',
    password: '#password123',
    vacation_days: 30,
    supervisor: true
  }}
)
raise result['contract.default'].errors.messages unless result.success?

