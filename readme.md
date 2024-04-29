## ローカルでの実行

コンテナのビルド
```
docker-compose build
```

サービスを起動
```
docker-compose up -d
```

起動中のサービスを停止
```
docker-compose stop
```

サービスを再起動
```
docker-compose restart
```

サービス停止・コンテナ削除
```
docker-compose down
```

## AWSの設定

terraform配下に移動
```
cd terraform
```

terraformを初期化
```
terraform init
```

操作の詳細を表示
```
terraform plan
```

問題がなければ、実行し環境を構築
```
terraform apply
```

リソースの削除
```
terraform destroy
```