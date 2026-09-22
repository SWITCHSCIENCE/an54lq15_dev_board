# Repository Guidelines

## 構成

本リポジトリは Switch Science AN54LQ-15（nRF54L15）用の Zephyr /
nRF Connect SDK（NCS）外部ボード定義である。ルートの `board.yml` は対応
ターゲット、`board.cmake` は書込み・デバッグランナー、`Kconfig*` は SoC
選択を定義する。`ssci_an54lq15_dev_board_nrf54l15_*.dts` では CPU ごとの
記述を置き、共通ハードウェアは `*_common.dtsi`、ピンは
`ssci_an54lq15_dev_board-pinctrl.dtsi` に集約する。`.yaml` は Twister 用
メタデータ、`.defconfig` はターゲット既定値である。回路情報、BOM、ピン配置
は `doc/` を参照する。

## ビルドと開発

対象 SDK は NCS 3.4.0、ベースボードは `raytac/an54lq_db_15` である。NCS の
バージョン、ワークスペース、アプリケーション、およびビルドディレクトリは推測
しない。SDK のローカル検索もしない。NCS/Zephyr の手順やコマンドは必ず Nordic
MCP で確認してから案内する。外部ボードとしてビルドする際は、MCP のガイダンス
どおり `BOARD_ROOT` に `boards/` を含む親ディレクトリの絶対パスを渡す。

```powershell
west build -b ssci_an54lq15_dev_board/nrf54l15/cpuapp <app> -- -DBOARD_ROOT=<boardsディレクトリを含む親ディレクトリ>
```

エージェントはビルド、書込み、消去、リセット、実機テストを実行しない。これらは
ユーザーが実施する。書込みには外付け J-Link 等のデバッガが必要で、USB-C は
電源供給専用である。

## 実装規約

既存の SPDX 著作権ヘッダーを保持する。DTS と Kconfig はタブ、YAML と CMake
は 2 スペースでインデントする。ターゲット固有ファイルは
`ssci_an54lq15_dev_board_nrf54l15_<target>.<ext>` と命名する。DTS ノード
ラベルは小文字、pinctrl 状態は `<peripheral>_default` と
`<peripheral>_sleep` を対にする。CPU 間で重複する定義は `.dtsi` に移す。

## 検証とハードウェア注意事項

リポジトリ内に単体テストはない。変更後のビルド、Twister、実機確認はユーザーの
責任で行う。回路・DTS の変更時は `doc/` のネットリストと照合し、オンボード
スイッチ `P1.13`、LED `P2.09`、電圧選択 `SEL` を誤って再割り当てしない。
対象機能を変えた場合は対応する `.yaml` の `supported` も更新する。

## コミットと PR

履歴は初期インポートのみで慣例は未確立である。`board: add SPI pinctrl state`
のように短い命令形で、変更を 1 件に絞る。PR には対象ターゲット、回路上の影響、
ユーザーが実施した検証結果、関連 Issue を記載し、必要に応じてログや写真を添付する。
