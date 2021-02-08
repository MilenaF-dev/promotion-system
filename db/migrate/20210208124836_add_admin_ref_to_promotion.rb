class AddAdminRefToPromotion < ActiveRecord::Migration[6.1]
  def change
    add_reference :promotions, :admin, null: false, foreign_key: true
  end
end
