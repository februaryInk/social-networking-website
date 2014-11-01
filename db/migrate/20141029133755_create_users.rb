class CreateUsers < ActiveRecord::Migration
    def change
        create_table :users do |t|
            t.string :email
            t.string :simple_name
            t.string :username

            t.timestamps
        end
        
        add_index :users, :email, { :unique => true }
        add_index :users, :simple_name, { :unique => true }
    end
end
