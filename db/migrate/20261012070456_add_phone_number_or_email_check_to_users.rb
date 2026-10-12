class AddPhoneNumberOrEmailCheckToUsers < ActiveRecord::Migration[8.1]
  def change
    # add_check_constraintはデータベースの規制をSQL文を使って、自分で作成するメソッド
    # 第一引数->どのテーブルの  第二引数->どのカラムがどうなっていればOK かを書く　nameはこの規制につける名前。
    # データベースのエラーが発生したときに指定している名前で、このエラーが発生したと教えてくれる
    # 下の場合はusersテーブルのphone_numberまたはemailに値が存在すればOKという条件になっている
    # ただし、""も値が存在することになるため、下に２つの規制を設ける（バリデーション前のコールバックで""をnullに変換はしているが一応）
    # ちなみに" "、や"　 "などは通してしまううがここまでやると複雑になりすぎるから置いておく
    add_check_constraint :users, "phone_number IS NOT NULL OR email IS NOT NULL", name: "phone_number_email_check"
    add_check_constraint :users, "phone_number != '' ", name: "phone_number_check"
    add_check_constraint :users, "email != '' ", name: "email_check"
  end
end
