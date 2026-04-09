# 🌡️ Temperature Sensor on Zynq-7000 Using I²C Protocol

A hardware-level temperature acquisition and display system implemented in **Verilog HDL** on the **Xilinx Zynq-7000 SoC FPGA**, developed as part of the course **CS G553 – Reconfigurable Computing** at BITS Pilani, K.K. Birla Goa Campus.

---

## 📌 Overview

This project implements a fully functional I²C-based digital temperature monitoring system on an FPGA. The system reads temperature data from the **ADT7420** high-precision sensor, processes it on-chip, and displays it in real-time on a **seven-segment display**. A switch allows toggling between **Celsius and Fahrenheit**, and onboard **LEDs** visually indicate temperature changes degree by degree.

---

## 🛠️ Hardware Components

| Component | Description |
|---|---|
| **Zynq-7000 ZedBoard** (xc7z020clg484-1) | Primary FPGA platform for implementing all digital logic |
| **Pmod TMP2** (ADT7420) | 16-bit I²C temperature sensor, ±0.25°C accuracy, −40°C to +150°C range |
| **Pmod SSD** | Two-digit seven-segment display for real-time temperature output |

---

## ⚙️ Software Tools

- **Xilinx Vivado 2025.1** — HDL design, synthesis, simulation, and FPGA programming

---

## 🔌 System Architecture

The FPGA acts as the **I²C master**, communicating with the ADT7420 sensor (I²C slave) to read 16-bit temperature data. The data is then:

1. Scaled and converted to Celsius (or Fahrenheit based on a switch input)
2. Displayed on the Pmod SSD via a multiplexed seven-segment driver
3. Reflected on onboard LEDs — lighting up per degree rise and dimming per degree fall

### Pin Mapping

| Pmod Header | Connected Module |
|---|---|
| JA1 | Pmod TMP2 (ADT7420) — SCL, SDA |
| JD1 + JC1 | Pmod SSD (Seven-Segment Display) |

---

## 🔄 I²C Communication Flow

The custom I²C master controller implements a **47-state FSM**:

- **S0** — Generate START condition
- **S1–S8** — Transmit 7-bit device address + Write bit
- **S9** — Receive ACK
- **S10–S17** — Send register pointer (`0x00` for Temperature MSB)
- **S18** — Receive ACK
- **S19** — Issue Repeated START
- **S20–S27** — Transmit device address + Read bit
- **S28** — Receive ACK
- **S29–S36** — Read MSB byte
- **S37** — Send ACK
- **S38–S45** — Read LSB byte
- **S46** — Send NACK and end transaction

---

## 📁 File Structure

```
├── top.v                  # Top-level module — integrates all submodules
├── i2c_master.v           # Custom I²C master FSM (47 states)
├── master_control.v       # Periodic reset controller (triggers I²C every ~1 second)
├── led_controller.v       # LED logic for temperature change indication
├── ssd.v                  # Seven-segment display multiplexer and decoder
└── i2c_master_tb.v        # Testbench for simulation
```

---

## 📊 Synthesis & Performance Summary

| Metric | Value |
|---|---|
| Slice LUTs Used | 127 / 53200 (0.24%) |
| Slice Registers | 109 / 106400 (0.10%) |
| Bonded IOBs | 20 / 200 (10%) |
| Total On-Chip Power | 0.111 W |
| Worst Negative Slack (Setup) | 5.992 ns ✅ |
| Timing Constraints | All met ✅ |

---

## ✅ Results

- I²C SDA/SCL waveforms verified via testbench simulation in Vivado
- System tested under real-world conditions — temperature changes confirmed with sunlight exposure and air conditioning
- Stable readings consistent with ADT7420 sensor specifications
- Celsius/Fahrenheit toggle functional via onboard switch

---

## 🚀 Potential Extensions

- Support for multiple I²C sensors (multi-master environment)
- BCD or floating-point display for decimal precision
- Integration with a soft-core processor (MicroBlaze) for hybrid control
- Edge IoT deployment as a low-power sensing node

---

<!-- ## 👥 Contributors

| Name | ID | GitHub |
|---|---|---|
| Pulkit Singla | [@]() |
| Paras Buva | [@]() |
| Soumyadeep Mandal | [@]() | -->

---

## 📚 References

- [FPGADude GitHub Repository](https://github.com/FPGADude)
- [I2C on FPGA Temperature Sensor — Nexys A7 / Basys 3 w/ Pmod TMP2 Verilog](https://www.youtube.com/watch?v=_kg8TDMkXUg)
- [ADT7420 Temperature Sensor Datasheet](https://www.analog.com/en/products/adt7420.html)
- [Digilent Pmod TMP2](https://digilent.com/reference/pmod/pmodtmp2/start)
- [Digilent Pmod SSD](https://digilent.com/reference/pmod/pmodssd/start)
- [Digilent ZedBoard Hardware Manual](https://digilent.com/reference/programmable-logic/zedboard/start)