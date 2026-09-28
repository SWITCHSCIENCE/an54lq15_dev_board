# Switch Science AN54LQ-15 Dev Board

Switch Science AN54LQ-15 Dev Board 向けの、nRF Connect SDK（NCS）用
Zephyr 外部ボード定義です。Raytac AN54LQ-15 モジュールに搭載された
nRF54L15 を対象とします。

## 対応環境

- nRF Connect SDK 3.4.0
- 外付け SWD デバッガ（J-Link、nRF54L15 DK の Debug out など）

USB Type-C は電源供給専用です。書込みとデバッグには外付けデバッガを使用して
ください。

## ボードターゲット

| 用途 | ターゲット |
| --- | --- |
| Application core | `ssci_an54lq15_dev_board/nrf54l15/cpuapp` |
| Application core / Non-Secure | `ssci_an54lq15_dev_board/nrf54l15/cpuapp/ns` |
| Fast Lightweight Peripheral Processor | `ssci_an54lq15_dev_board/nrf54l15/cpuflpr` |
| FLPR / RRAM XIP | `ssci_an54lq15_dev_board/nrf54l15/cpuflpr/xip` |

## ビルド

NCS ワークスペースの環境を有効にして、アプリケーションを指定してビルドします。
このリポジトリは `C:\ncs\boards\ssci\an54lq15_dev_board` にあるため、
`BOARD_ROOT` には `C:\ncs` を指定します。

```powershell
west build -b ssci_an54lq15_dev_board/nrf54l15/cpuapp <アプリケーションのパス> -- -DBOARD_ROOT=C:\ncs
```

書込みは生成済みのビルドディレクトリで `west flash` を実行します。実機接続や
使用する runner はデバッガ構成に合わせて選んでください。

## ハードウェア

- オンボード LED: `P2.09`
- オンボードスイッチ: `P1.13`
- Qwiic/STEMMA QT: `P1.11`（SCL）、`P1.12`（SDA）

P2.09 は PWM20/21/22 の対象外です。LED は GPIO として使用してください。
回路、BOM、ネットリストは [doc](doc/) にあります。

## Qwiic / STEMMA QT

Qwiic 用 I2C は標準 DTS には含めず、任意オーバーレイとして提供しています。
アプリケーションで `CONFIG_I2C=y` を有効にし、次のファイルを
`EXTRA_DTC_OVERLAY_FILE` に指定してください。

`support/qwiic/ssci_an54lq15_dev_board_nrf54l15_cpuapp_qwiic.overlay`

このオーバーレイは CPUAPP の `i2c21` を 100 kHz で有効化します。センサー固有の
Devicetree ノードはアプリケーション側のオーバーレイへ追加します。

## SPI

SPI はオンボードデバイスを持たないため、標準 DTS には含めていません。CPUAPP で
SPI00 を使う場合は、アプリケーションで `CONFIG_SPI=y` を有効にし、次の任意
オーバーレイを `EXTRA_DTC_OVERLAY_FILE` に指定してください。

`support/spi/ssci_an54lq15_dev_board_nrf54l15_cpuapp_spi.overlay`

このオーバーレイは SCK=`P2.01`、MOSI=`P2.02`、MISO=`P2.04`、CS=`P2.05` を
割り当てます。接続する SPI デバイスの Devicetree ノードはアプリケーション側の
オーバーレイへ追加してください。

## ライセンス

各ソースファイルに記載された SPDX ライセンス識別子に従います。
