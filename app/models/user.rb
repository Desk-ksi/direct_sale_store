class User < ApplicationRecord
  # メールアドレスに全角英数や空白、大文字が入っていたら、自動で半角・小文字に直す
  # 最初は private内でメソッドを作って before_validation で変換しようと思った
  # ただ before_validation は保存（save）や検証(valid?)のときにしか動かない
  # ログインでメールアドレスを入力して find_by で検索するときは、保存しないのでコールバックが動かず、
  # 入力された大文字や全角のまま検索してしまい、保存してある値と合わなくて見つからない
  # normalizes は代入、保存、更新に加えて、find_by などの検索に渡した値にも同じ変換をかけてくれる
  # なのでログインの検索でもコントローラー側に変換を書かなくていい
  normalizes :email, with: -> email {email.unicode_normalize(:nfkc).gsub(" ", "").downcase}
  before_validation :nullify_blank_email
  before_validation :nullify_blank_phone_number
  # has_secure_passwordでは、デフォルトでパスワードが必須になるため、validationsをfalseにして自作する
  # デフォルトのvalidationは必須、72バイト以下、パスワード確認用（_confirmation）と一致
  has_secure_password(validations: false) # 自動validationをキャンセル

  # 電話番号で登録したけど、メールアドレスだけ登録する人もいる
  # メールアドレスだけ登録しておく場合に、メールアドレスを持っている人がパスワード必須にしたら、実現できない
  # そのため、電話番号を持っていないくて、パスワードを持っていない人を対象にバリデーションをかける（private内でメソッドを定義）
  # on: :createにしているのは、user更新のときにパスワードは入力することはない。新規登録だけに絞っておかないと、入力らんはないのに、パスワードを入力してくれとエラーが出る
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

  # 電話番号がないということはemail＋passwordで登録しないといけない
  # 電話番号がない＝電話番号でのログインではない。電話番号を持っていてemailを持つことも許容したい
  # 電話番号でもemail+passwordでもない人を絞るためには、電話番号とpasswordを持っていない人を新規登録の時だけ弾かないといけない
  def required_password
    if phone_number.blank? && password.blank?
      errors.add(:base, "メールアドレスとパスワードで登録する必要があります")
    end
  end

  # emailもphone_numberもなかったらエラーを発生
  def required_either_email_or_phone
    if email.blank? && phone_number.blank?
      errors.add(:base, "電話番号かメールアドレスを入力する必要があります")
    end
  end

  # メールアドレスと電話番号はユニーク規制をしている
  # ただどちらかを登録すればいいため、null: falseにしていない
  # そうなると、からで登録した人たちは「””」空文字が登録される
  # 「””」が二人目になると、ユニーク規制に引っかかり、登録できなくなるため、空文字だったら、nilにするバリデーションの前でコールバックを行う
  # 最初は if email == "" にしていたが、これでは" "に対応できない
  # blnkは""も" "もnilも感知してtrueにするため、ifでtrueだったら、次に行くようにしている 
  def nullify_blank_email
    # モデルはどのインスタンスかがわかっているため、カラム名（email）だけで該当の値を取り出せる
    if email.blank?
      # ローカル変数ではなく、今扱っているインスタンスにメソッドを使っているんだと明示するために、self.が必要
      self.email = nil
    end
  end

  def nullify_blank_phone_number
    if phone_number.blank?
      self.phone_number = nil
    end
  end

end
