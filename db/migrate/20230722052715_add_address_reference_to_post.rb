class AddAddressReferenceToPost < ActiveRecord::Migration[7.0]
  def change
    add_reference :posts, :address_region
    add_reference :posts, :address_province
    add_reference :posts, :address_city
    add_reference :posts, :address_barangay
  end
end
