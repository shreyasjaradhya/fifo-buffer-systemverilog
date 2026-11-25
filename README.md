# Parameterized FIFO Buffer Design & Constrained-Random OOP Verification using SystemVerilog

[![Language: SystemVerilog](https://img.shields.io/badge/Language-SystemVerilog-blue.svg?logo=microchip)]()
[![Design: RTL](https://img.shields.io/badge/Design-Synthesizable%20RTL-success.svg)]()
[![Verification: OOP Testbench](https://img.shields.io/badge/Verification-Constrained--Random%20OOP-purple.svg)]()
[![Simulators: ModelSim/Questa](https://img.shields.io/badge/Simulators-QuestaSim%20%7C%20ModelSim%20%7C%20GTKWave-orange.svg)]()

> Synthesizable, parameterized circular FIFO buffer RTL design with Byte-Enable masking and First-Word Fall-Through (FWFT) mode, verified via an object-oriented SystemVerilog testbench featuring BFMs, mailboxes, and self-checking scoreboards.

---

## 👥 Authors
* **J Anvidh**
* **Shreyas Aradhya** (`NNM24EC065`)
* **Jayanth Reddy**
* **Course**: SystemVerilog for Verification (SVL), NMAMIT

---

## 🏗 RTL Specifications & Architecture

| Parameter | Default Value | Description |
|---|---|---|
| `DATA_WIDTH` | `32` bits | Data bus width (supports 8, 16, 32, 64-bit configurations) |
| `DEPTH` | `16` words | Storage capacity of the circular buffer |
| `ALMOST_FULL_THRESH` | `14` | Programmable threshold asserting `almost_full` |
| `ALMOST_EMPTY_THRESH` | `2` | Programmable threshold asserting `almost_empty` |
| `FWFT_MODE` | `1` | First-Word Fall-Through (data available on read port without clock latency) |

### Key RTL Signals
* **Clock & Reset**: `clk` (100 MHz reference), `rst_n` (synchronous active-low reset).
* **Write Channel**: `wr_en`, `wr_data[31:0]`, `byte_en[3:0]`, `full`, `almost_full`, `wr_err` (overflow attempt).
* **Read Channel**: `rd_en`, `rd_data[31:0]`, `empty`, `almost_empty`, `rd_err` (underflow attempt).

---

## 🔍 Verification Architecture (OOP Testbench)

```
 +-----------------------------------------------------------------------------------------+
 |                                  TESTBENCH TOP (tb_top)                                 |
 |                                                                                         |
 |   +---------------------------------------------------------------------------------+   |
 |   |                                ENVIRONMENT (env)                                |   |
 |   |                                                                                 |   |
 |   |   +------------------+         +-----------------+         +----------------+   |   |
 |   |   |  GENERATOR (gen) |         |   DRIVER (drv)  |         | MONITOR (mon)  |   |   |
 |   |   |                  |         |                 |         |                |   |   |
 |   |   |  * Randomizes    | Mailbox |  * Drives       | Modport |  * Samples     |   |   |
 |   |   |    transactions  | ------> |    signals via  | ------> |    interface   |   |   |
 |   |   |  * Constrained   |         |    fifo_if      |         |    bus traffic |   |   |
 |   |   +------------------+         +-----------------+         +--------+-------+   |   |
 |   |                                                                     |           |   |
 |   |                                                                     | Mailbox   |   |
 |   |                                                                     v           |   |
 |   |                                                            +----------------+   |   |
 |   |                                                            | SCOREBOARD     |   |   |
 |   |                                                            |                |   |   |
 |   |                                                            | * Golden queue |   |   |
 |   |                                                            | * Compare data |   |   |
 |   |                                                            | * Error counts |   |   |
 |   |                                                            +----------------+   |   |
 |   +---------------------------------------------------------------------------------+   |
 |                                           |                                             |
 |                                           | Virtual Interface                           |
 |                                           v                                             |
 |                          +-----------------------------------+                          |
 |                          |   DUT: fifo_top (Parameterized)   |                          |
 |                          +-----------------------------------+                          |
 +-----------------------------------------------------------------------------------------+
```

---

## 📁 Repository Structure
```
├── docs/
│   └── SVL_REPORT.pdf             # Official SystemVerilog laboratory engineering report
├── rtl/
│   ├── fifo_top.sv                # Top-level synthesizable FIFO wrapper
│   ├── fifo_mem.sv                # Dual-port register array memory
│   └── fifo_ctrl.sv               # Read/write pointer management & flag logic
├── tb/
│   ├── fifo_if.sv                 # SystemVerilog interface with modports
│   ├── fifo_transaction.sv        # Constrained-random transaction class
│   ├── fifo_generator.sv          # Stimulus generator
│   ├── fifo_driver.sv             # BFM bus driver
│   ├── fifo_monitor.sv            # Bus protocol monitor
│   ├── fifo_scoreboard.sv         # Self-checking scoreboard
│   ├── fifo_environment.sv        # Interconnecting environment container
│   └── tb_top.sv                  # Testbench top with 100MHz clock & reset
├── sim/
│   └── run_modelsim.do            # Compile and run script for ModelSim / QuestaSim
├── .gitignore
├── LICENSE
└── README.md
```
