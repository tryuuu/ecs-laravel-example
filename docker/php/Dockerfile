# マルチステージビルドの最初のステージ
# ビルドステージとして後のステージから参照
FROM php:8.2-fpm-buster as builder

ENV TZ=UTC \
  LANG=en_US.UTF-8 \
  LANGUAGE=en_US:en \
  LC_ALL=en_US.UTF-8

# ComposerとNode.jsのインストール
COPY --from=composer:2.4 /usr/bin/composer /usr/bin/composer

# &&によりレイヤーをまとめ、イメージサイズを抑える
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - \
  && apt-get update \
  && apt-get install -y nodejs \
  && apt-get -y install --no-install-recommends locales git unzip libzip-dev libicu-dev libonig-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && locale-gen en_US.UTF-8 \
  && localedef -f UTF-8 -i en_US en_US.UTF-8 \
  && docker-php-ext-install intl pdo_mysql zip bcmath

# アプリケーションコードのコピー
COPY ./src /var/www/html/app

# ソースコード配下でビルド
WORKDIR /var/www/html/app
RUN composer install -q -n --no-ansi --no-progress --prefer-dist \
  && composer require league/flysystem-aws-s3-v3 \
  && npm install \
  && npm run build 

# ランタイムステージ
FROM php:8.2-fpm-buster

# 環境変数の設定
ENV TZ=UTC \
  LANG=en_US.UTF-8 \
  LANGUAGE=en_US:en \
  LC_ALL=en_US.UTF-8 \
  COMPOSER_ALLOW_SUPERUSER=1 \
  COMPOSER_HOME=/composer

# 必要なパッケージのインストール
RUN apt-get update \
  && apt-get -y install --no-install-recommends libzip-dev libicu-dev libonig-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && docker-php-ext-install intl pdo_mysql zip bcmath

# ビルドステージから成果物をコピー
COPY --from=builder /var/www/html/app /var/www/html/app

# 設定ファイルのコピー
COPY ./docker/php/php.ini /usr/local/etc/php/php.ini
COPY ./docker/php/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# コンテナ起動時に実行
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
WORKDIR /var/www/html/app

# マウントするボリュームソースの設定
VOLUME ["var/www/html/app/public"]
