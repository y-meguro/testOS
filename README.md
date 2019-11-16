# testOS

## About this repository

[作って理解するOS x86系コンピュータを動かす理論と実装 | 林 高勲, 川合 秀実](https://amzn.to/36I8Ry7) を読んで作成した OS のコードをあげています

参考: [サポートページ：作って理解するOS x86系コンピュータを動かす理論と実装：｜技術評論社](https://gihyo.jp/book/2019/978-4-297-10847-2/support)

## 環境

- [Bochs](http://bochs.sourceforge.net/) の 2.6.9 で挙動確認した
- アセンブラは [NASM](https://www.nasm.us/) の 2.14.02 を使用
- Windows 環境ではなく、Mac 環境で作業（mac OS Catalina 10.15.1）
- 読んだ本は初版のもの（2019年10月9日初版、第1刷）

## 作成時のメモ

- 本と違う点など、作成時のメモを以下に記載します
- 全般に渡って挙動確認は Bochs のみ、実機での確認は行っていません

### 12章: 開発環境を構築する

- [Bochs](http://bochs.sourceforge.net/) を利用することにした
  - バージョンは 2.6.9
  - `brew install bochs`
  - Windows ではなく、本に書かれているようなメニュー画面がないので、config file を設定する必要がある
    - 参考: [The configuration file bochsrc](http://bochs.sourceforge.net/doc/docbook/user/bochsrc.html)
  - env 配下に .bochsrc ファイルを作成。12 章で設定されていそうな内容を記載した

```
ata0-master: type=disk, path=boot.img, mode=flat, cylinders=20, heads=2, spt=16, translation=auto
boot: disk
```

- 本に記載がある通り、`ata0-0: specified geometry doesn't fit on disk image` の警告は無視して、`Booting from Hard Disk...` のメッセージが出ることを確認した
- 起動オプションは本の指定通りとした
  - 参考: [Using Bochs](http://bochs.sourceforge.net/doc/docbook/user/using-bochs.html#COMMANDLINE)

```
bochs -q -f ../../env/.bochsrc -rc ../../env/cmd.init
```

- bat ファイルではなく sh ファイルとした
- env.bat と dev.bat は作らず、.zshrc で PATH を指定した。また Bochs を使う（QEMUを使わない）ため、boot.bat も作っていない
- 本と同様に、00_boot_only や 01_bpb などから box.sh 等を呼び出す想定で記載

### 13章: アセンブラによる制御構文と関数の記述例

- 記載の通り実装しただけ

### 14章: リアルモードでの基本動作を実装する

- 各ステップごとに実装し、挙動確認をした
- 14.9 で macro.s にある .cyln が .syln とタイポされてたので、.cyln にする。また、resw が reww とタイポされているので、resw にする
  - [サポートページ](https://gihyo.jp/book/2019/978-4-297-10847-2/support) に記載あり
- 14.12 で get_mem_info.s にメモリを確保する記述を追加する
  - [サポートページ](https://gihyo.jp/book/2019/978-4-297-10847-2/support) に記載あり
- 14.13 で kbc.s の KBC_Data_Read の loopnz を loopz に修正する
  - [サポートページ](https://gihyo.jp/book/2019/978-4-297-10847-2/support) に記載あり
- 14.16 で lba_chs は （read_lba.s ではなく）lba_chs.s という名前で保存する

### 15章: プロテクトモードへの移行を実現する

- 記載の通り実装しただけ

### 16章: プロテクトモードでの画面出力を実現する

- mac での画面拡大
  - システム環境設定で Accessibility から Zoom を選択して、キーボードからショートカットで拡大できるように設定する
- 16.10 で 23_draw_rect ではなく、24_draw_rect で作成する
  - [サポートページ](https://gihyo.jp/book/2019/978-4-297-10847-2/support) に記載あり

### 17章: 現在時刻を表示する

- 時刻の変化を確認する時、本に記載の通り、.bochsrc に cpu の設定を追加する
  - `cpu: ips=60000000` の記載を追加して、確認した
  - 参考: [Using Bochs](http://bochs.sourceforge.net/doc/docbook/user/using-bochs.html#COMMANDLINE)

### 18章: プロテクトモードでの割り込みを実現する

- 18.2 の VECT_BASE は define.s に登録する
- 18.3 の macro.s の set_vect に if 文を追加する
  - [サポートページ](https://gihyo.jp/book/2019/978-4-297-10847-2/support) に記載あり

### 19章: マルチタスクを実現する

- 記載の通り実装しただけ

### 20章: 特権状態を管理する

- 記載の通り実装しただけ

### 21章: 小数演算を行う

- draw_line.s に USE_SYSTEM_CALL が定義されている場合の処理を追加

### 22章: ページング機能を利用する

- task_3.s の rose.n を 5、rose.d を 2 にして挙動を確認した（提供されているコードと揃えた）
- real 配下の memcpy.s を protect 配下にコピー

### 23章: コードを共有する

- 記載の通り実装しただけ

### 24章: ファイルシステムを利用する

- define.s に FAT1_START / FAT2_START などの変数を定義する
- テキストファイルの確認はしていない（挙動確認は Bochs のみ）

### 25章: モード移行を実現する

- 記載の通り実装しただけ

### 26章: ファイルの読み出しを実現する

- 記載の通り実装しただけ

### 27章: PC の電源を切る

- CTRL+ALT+END キーの処理は、45_fat_bios/kernel.s ではなく、46_acpi/kernel.s に記載する
- power_off.s の最初に "Power off..." のメッセージを表示する処理を入れる
- Ctrl + Alt + End の確認は Ctrl + Option + Fn + → で確認する

## 読書メモ

- [作って理解するOS - y-meguro's reading record](https://y-meguro.gitbook.io/reading-record/computer-systems/create_and_understand_os) に記載
