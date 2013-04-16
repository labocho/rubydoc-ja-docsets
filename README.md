# 概要

Ruby リファレンスマニュアル (http://doc.ruby-lang.org/ja/) を Dash (http://kapeli.com/) で閲覧できる形式 (Docsets) にするツールです。

# 使い方

http://labocho.github.io/rubydoc-ja-docsets/ からリンクをクリックするか、下記の dash-feed:// から始まる URL を Safari などで開くと Dash が起動し、Downloads に追加されます。あとは他の docsets などと同様、Download をクリックすれば利用可能になります。

    # Ruby 2.0.0 リファレンスマニュアル
    dash-feed://https%3A%2F%2Fraw.github.com%2Flabocho%2Frubydoc-ja-docsets%2Fmaster%2Ftarball%2FRuby-2.0.0-ja.xml

    # Ruby 1.9.3 リファレンスマニュアル
    dash-feed://https%3A%2F%2Fraw.github.com%2Flabocho%2Frubydoc-ja-docsets%2Fmaster%2Ftarball%2FRuby-1.9.3-ja.xml

    # Ruby 1.8.7 リファレンスマニュアル
    dash-feed://https%3A%2F%2Fraw.github.com%2Flabocho%2Frubydoc-ja-docsets%2Fmaster%2Ftarball%2FRuby-1.8.7-ja.xml

# 自分でビルド

Ruby (>= 1.9.2), bundler, svn が必要です。

    git clone git://github.com/labocho/rubydoc-ja-docsets.git
    cd rubydoc-ja-docsets
    bundle install

    # Ruby 2.0.0 リファレンスマニュアルをインストール
    bundle exec rake install VERSION=2.0.0
    # Ruby 1.9.3 リファレンスマニュアルをインストール
    bundle exec rake install VERSION=1.9.3
    # Ruby 1.8.7 リファレンスマニュアルをインストール
    bundle exec rake install VERSION=1.8.7

Dash を再起動すればインストールしたドキュメントが追加されます。

# ライセンス

- Ruby リファレンスマニュアルは CC-BY (http://creativecommons.org/licenses/by/3.0/) で配布されています。
- リファレンスマニュアルの生成、メタデータの収集に関するコードは、宮前竜也さんの rubydoc-ja (https://github.com/miyamae/rubydoc-ja) を参考にさせていただきました。
- 本ソフトウェアは MIT License (http://www.opensource.org/licenses/mit-license.php) で提供します。
