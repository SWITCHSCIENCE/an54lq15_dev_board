# Repository Guidelines

## 構成

本リポジトリは Switch Science AN54LQ-15（nRF54L15）用の Zephyr /
nRF Connect SDK（NCS）外部ボード定義である。ルートの `board.yml` は対応
ターゲット、`board.cmake` は書込み・デバッグランナー、`Kconfig*` は SoC
選択を定義する。`ssci_an54lq15_dev_board_nrf54l15_*.dts` では CPU ごとの
記述を置き、共通ハードウェアは `*_common.dtsi`、ピンは
`ssci_an54lq15_dev_board-pinctrl.dtsi` に集約する。`.yaml` は Twister 用
メタデータ、`.defconfig` はターゲット既定値である。回路情報、BOM、ピン配置
は `doc/` を参照する。正式なターゲットは次の 4 つである。

- `ssci_an54lq15_dev_board/nrf54l15/cpuapp`
- `ssci_an54lq15_dev_board/nrf54l15/cpuapp/ns`
- `ssci_an54lq15_dev_board/nrf54l15/cpuflpr`
- `ssci_an54lq15_dev_board/nrf54l15/cpuflpr/xip`

`support/qwiic/` には CPUAPP 用の任意の Qwiic/STEMMA QT オーバーレイを置く。
標準 DTS の一部ではないため、利用時はアプリケーションで `CONFIG_I2C=y` を
有効にし、`EXTRA_DTC_OVERLAY_FILE` で明示的に指定する。

## ビルドと開発

対象 SDK は NCS 3.4.0 である。NCS のバージョン、ワークスペース、
アプリケーション、およびビルドディレクトリは推測しない。NCS/Zephyr の手順や
コマンドは最初に Nordic MCP で確認する。その後、必要に応じて、ユーザーが示した
パスや既知のローカルプロジェクト、既存ビルドの provenance を読み取り専用で
確認する。外部ボードとしてビルドする際は、`BOARD_ROOT` に `boards/` を含む
親ディレクトリの絶対パスを渡す。現在の配置
`C:\ncs\boards\ssci\an54lq15_dev_board` に対する `BOARD_ROOT` は `C:\ncs` である。

```powershell
west build -b ssci_an54lq15_dev_board/nrf54l15/cpuapp <app> -- -DBOARD_ROOT=<boardsディレクトリを含む親ディレクトリ>
```

書込みには外付け J-Link 等のデバッガが必要で、USB-C は電源供給専用である。

## 実装規約

既存の SPDX 著作権ヘッダーを保持する。DTS と Kconfig はタブ、YAML と CMake
は 2 スペースでインデントする。ターゲット固有ファイルは
`ssci_an54lq15_dev_board_nrf54l15_<target>.<ext>` と命名する。DTS ノード
ラベルは小文字、pinctrl 状態は `<peripheral>_default` と
`<peripheral>_sleep` を対にする。CPU 間で重複する定義は `.dtsi` に移す。

標準 DTS には基板に実装され、回路資料で確認できるハードウェアだけを定義する。
任意のピン割り当てやコネクタ用途は、標準 DTS でピンを占有せず、用途別
オーバーレイに分離する。回路上の根拠や必要な binding なしに、外部 SPI Flash、
PWM LED、またはボード独自のルート `compatible` を追加しない。

## 検証とハードウェア注意事項

リポジトリ内に単体テストはない。エージェントはビルド、Twister、書込み、消去、
リセット、実機テストを実行せず、ユーザーが実施する。変更後の報告では、静的に
確認した内容と、実行していない検証を明記する。回路・DTS の変更時は `doc/` の
ネットリストと照合し、オンボードスイッチ `P1.13`、LED `P2.09`、電圧選択
`SEL` を誤って再割り当てしない。対象機能を変えた場合は対応する `.yaml` の
`supported` も更新する。

## コミットと PR

コミットメッセージは既存履歴に合わせ、変更内容を短く具体的に表す。変更を 1 件に
絞り、必要に応じて `board: add SPI pinctrl state` のような短い命令形を用いる。
PR には対象ターゲット、回路上の影響、ユーザーが実施した検証結果、関連 Issue を
記載し、必要に応じてログや写真を添付する。
