class AddBalanceToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :course_income, :int, null: false, default: 0
    add_column :users, :expense, :int, null: false, default: 0
    add_column :users, :balance, :int, null: false, default: 0
  end
end
