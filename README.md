# ConsultationReservationService
エキスパートへの相談希望日時を予約登録できるWebアプリケーション

## 環境構築

### 初期構築
```bash
make init
make up
make setup
```

### 起動
```shell
make up
```

#### ユーザーログイン画面
http://0.0.0.0:3000/users/sign_in

#### エキスパートログイン画面
http://0.0.0.0:3000/expert/sign_in

### テスト
```shell
make rspec
```

### メール設定

```/backend/.env```にメール設定を追記してください。
```
SEND_MAIL_SERVER = << your smtp server >>
SEND_MAIL_ADDRESS = << your mail address >>
SEND_MAIL_PASSWORD = << your mail password >>
```
