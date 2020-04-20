class AddIndexToUsersEmail < ActiveRecord::Migration[6.0]
  def change
    #自由にあなたが実行したいマイグレーションを書いてくださいね
    add_index :users, :email, unique: true # DBの方でもemailカラムは一意にしてね
  end
end
