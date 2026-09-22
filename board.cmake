# Copyright (c) 2024 Nordic Semiconductor ASA
# Copyright (c) 2025 Raytac Corporation.
# SPDX-License-Identifier: Apache-2.0

if(CONFIG_SOC_NRF54L15_CPUAPP)
  board_runner_args(jlink "--device=nRF54L15_M33" "--speed=4000")
  board_runner_args(pyocd "--target=nrf54l" "--frequency=4000000")
  board_runner_args(openocd "--cmd-load=nrf54l-load" -c "targets nrf54l.cpu")

elseif(CONFIG_SOC_NRF54L15_CPUFLPR)
  board_runner_args(jlink "--device=nRF54L15_RV32")
  board_runner_args(pyocd "--target=nrf54l" "--frequency=4000000")
  board_runner_args(openocd "--cmd-load=nrf54l-load" -c "targets nrf54l.aux")

endif()

if(CONFIG_TFM_FLASH_MERGED_BINARY)
  set_property(TARGET runners_yaml_props_target PROPERTY hex_file tfm_merged.hex)
endif()

include(${ZEPHYR_BASE}/boards/common/nrfutil.board.cmake)
include(${ZEPHYR_BASE}/boards/common/jlink.board.cmake)
include(${ZEPHYR_BASE}/boards/common/pyocd.board.cmake)
include(${ZEPHYR_BASE}/boards/common/openocd.board.cmake)
