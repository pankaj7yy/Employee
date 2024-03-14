class Employee < ApplicationRecord

  validates :first_name, :last_name, :email, :doj, :salary, :phone_number, presence: true
  serialize :phone_number, Array
end

