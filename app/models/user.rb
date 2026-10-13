class User < ApplicationRecord
  before_validation :nullify_blank_email
  before_validation :nullify_blank_phone_number

  # has_secure_passwordでは、デフォルトでパスワードが必須になるため、validationsをfalseにして自作する
  # デフォルトのvalidationは必須、72バイト以下、パスワード確認用（_confirmation）と一致
  has_secure_password(validations: false) # 自動validationをキャンセル

  # 電話番号で登録したけど、メールアドレスだけ登録する人もいる
  # メールアドレスだけ登録しておく場合に、メールアドレスを持っている人がパスワード必須にしたら、実現できない
  # そのため、電話番号を持っていないくて、パスワードを持っていない人を対象にバリデーションをかける（private内でメソッドを定義）
  validate :required_password, on: :create

  # 電話番号だけの人はpassword_digestがnilになっている。nilは0文字と認識されるため、ユーザー編集などした際に、図らずもバリデーションに引っかかってしまう
  # そのため、このバリデーションはpassword入力欄に入力されて保存される時に発動させたい
  # 発動条件をpassword_digestにすると、すでに登録している人が、ユーザー編集をした時にバリデーションが発動してしまう。この時にはpasswordを入力するエリアはないのに(エラーになる)
  # そのため、実際に各入力欄で入力された値達の塊であるオブジェクトから、passwordを抜き出して、passwordが存在すればバリデーションを発動させる。
  # オブジェクトを取り出すのがProcで、オブジェクトをaとして、aからpasswordを取り出している
  validates :password, length: (6..24), confirmation: true, if: Proc.new{ |a| a.password.present? }

  # passwordを入力したら、確認用password(password_cofirmation)と照合して一致していたら通すバリデーション
  # user編集の際に確認用passwordを必須にすると使いづらいため、on: :createでuser作成時のみで、オブジェクトにpasswordがあるときだけに発動するバリデーションとする（passwordのバリデーションの説明と一緒）
  validates :password_confirmation, presence: true, on: :create, if: Proc.new{ |a| a.password.present? }
  validates :name, presence: true
  # phone_numberでのログインかemail+passwordでのログインを選択できるように改造
  # phone_numberがあるなら、ユニークで電話番号の正規表現に合うかバリデーション
  validates :phone_number, format: { with: /\A\+\d{12}\z/ }, uniqueness: true, if: :phone_number?
  # emailがあるなら、ユニークでメールの正規表現に合うかバリデーション
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true, if: :email?

  # 電話番号かメールアドレスを入力しないといけないという自作のバリデーションを実行
  # 参考(https://qiita.com/harashoo/items/6f5aaded7e0e00b02253)
  validate :required_either_email_or_phone

  has_many :user_shops, dependent: :destroy
  has_many :shops, through: :user_shops
  has_many :user_shop_likes, dependent: :destroy
  # 中間テーブルを介して、userがお気に入りにしたshopを参照するときのメソッドを定義。sourceは何を参照するかを明示
  has_many :favorite_shops, through: :user_shop_likes, source: :shop
  has_many :user_post_likes, dependent: :destroy
  # 中間テーブルを介して、userがお気に入りにしたpostを参照するときのメソッドを定義。sourceは何を参照するかを明示
  has_many :favorite_posts, through: :user_post_likes, source: :post

  private

  def required_password
    if phone_number.blank? && password.blank?
      errors.add(:base, "メールアドレスとパスワードで登録する必要があります")
    end
  end

  def required_either_email_or_phone
    return if email.present? || phone_number.present?
    errors.add(:base, "電話番号かメールアドレスを入力する必要があります")
  end

  # メールアドレスと電話番号はユニーク規制をしている
  # ただどちらかを登録すればいいため、null: falseにしていない
  # そうなると、からで登録した人たちは「””」空文字が登録される
  # 「””」が二人目になると、ユニーク規制に引っかかり、登録できなくなるため、空文字だったら、nilにするバリデーションの前でコールバックを行う
  # 最初は if email == "" にしていたが、これでは" "に対応できない
  # presentは""も" "もnilも感知してfalseにするため、unlessでfalseだったら、次に行くようにしている 
  def nullify_blank_email
    # モデルはどのインスタンスかがわかっているため、カラム名（email）だけで該当の値を取り出せる
    unless email.present?
      # ローカル変数ではなく、今扱っているインスタンスにメソッドを使っているんだと明示するために、self.が必要
      self.email = nil
    end
  end

  def nullify_blank_phone_number
    unless phone_number.present?
      self.phone_number = nil
    end
  end

end
