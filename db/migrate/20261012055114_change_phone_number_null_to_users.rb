class ChangePhoneNumberNullToUsers < ActiveRecord::Migration[8.1]
  def change
    # メールアドレス＋パスワードでも登録できるようにするために、phone_numberのnull規制を外す
    change_column_null :users, :phone_number, true
  end
end
