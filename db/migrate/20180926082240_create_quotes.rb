class CreateQuotes < ActiveRecord::Migration[5.0]
  def change
    create_table :quotes do |t|
    	t.string :title
    	t.text :content
    	t.string :link

    	t.timestamps null: false
    end
  end
end
