# 概要

Ruby リファレンスマニュアル (http://doc.ruby-lang.org/ja/) を Dash (http://kapeli.com/) で閲覧できる形式 (Docsets) にするツールです。

# 使い方

http://labocho.github.io/rubydoc-ja-docsets/ からリンクをクリックすると Dash が起動し、Downloads に追加されます。あとは他の docsets などと同様、Download をクリックすれば利用可能になります。

# 自分でビルド

Ruby (>= 2.2.3), bundler, git が必要です。

    git clone git://github.com/labocho/rubydoc-ja-docsets.git
    cd rubydoc-ja-docsets
    bundle install

    bundle exec rake install VERSION=2.3.0 # or version you want

Dash を再起動すればインストールしたドキュメントが追加されます。

# ライセンス

- Ruby リファレンスマニュアルは CC-BY (http://creativecommons.org/licenses/by/3.0/) で配布されています。
- リファレンスマニュアルの生成、メタデータの収集に関するコードは、宮前竜也さんの rubydoc-ja (https://github.com/miyamae/rubydoc-ja) を参考にさせていただきました。
- 本ソフトウェアは MIT License (http://www.opensource.org/licenses/mit-license.php) で提供します。
