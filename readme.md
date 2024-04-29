## アプリケーションの構成

![nippou drawio (5)](https://github.com/tryuuu/ecs-laravel-example/assets/113238295/84b515a4-0c80-47c9-82cc-603c0a92f18d)

https://qiita.com/tryuuu/items/ac42e465917d9a3945ec

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