# Narou.rb Docker Image

Narou.rbをDocker上で実行するためのDockerイメージです。  
これは現在更新が止まっている、Narou.rb作者様によるDockerイメージのフォークになります。  
現在Docker Hubにはイメージを用意していないため、各自ビルドしてお使いください。

**現在alpine版が正常に動作しないため、デフォルトをslim版としています**

# 使い方
docker-compose.ymlと同じディレクトリで以下を実行。
```sh
docker compose up -d --build
```
2回目以降の起動は```--build```を外して構いません。

# 本家からの変更点

## イメージサイズの減少
jlinkによるカスタムJREの作成により、イメージサイズが100MB程度減少しました。

## ユーザーの追加
非rootユーザーで実行するため、コンテナ内で作成されるファイルの所有権がrootでなくなりました。  
デフォルトのUID、GIDはどちらも1000に設定されています。これはdocker-compose.ymlのbuild.argsから変更可能です。

## libjpegの同梱
libjpegをライブラリとして同梱することで、挿絵のある小説のEPUB変換時のエラーが解消されました。

## kindlegen
kindlegenの配布が終了しているため、同梱していません。現在Send to KindleによりEPUBファイルをkindleデバイスに送信できるため、そちらをお使いください。