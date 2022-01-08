# ConsultationReservationService
エキスパートへの相談希望日時を予約登録できるWebアプリケーション

## 環境構築

### 初期構築
```bash
make init
docker compose run web rake db:create
```

### 起動
```shell
make up
```
