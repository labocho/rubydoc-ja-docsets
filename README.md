# 概要

Ruby リファレンスマニュアル (http://doc.ruby-lang.org/ja/) を Dash (http://kapeli.com/) で閲覧できる形式 (Docsets) にするツールです。

# 使い方

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
