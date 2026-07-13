# Direct-Mapped Cache Controller with Write-Back and Write-Allocate

A **Verilog HDL implementation** of a **Direct-Mapped Cache Controller** that acts as an interface between the CPU and main memory. The controller reduces memory access latency by efficiently handling cache hits and misses while supporting **Write-Back** and **Write-Allocate** cache policies. The design incorporates hit/miss detection, address decoding, dirty and valid bit management, an FSM-based controller, and automatic cache updates. The complete design has been developed and functionally verified using **Xilinx Vivado**.

---

# Features

- Direct-Mapped Cache Architecture
- 4 Cache Lines
- 2-Byte Cache Block Size
- 8-Bit Addressing
- Address Decoder (Tag, Index & Offset)
- Cache Memory with Valid Bit and Dirty Bit
- Hit/Miss Detection
- FSM-Based Cache Controller
- Write-Back Cache Policy
- Write-Allocate Policy
- Automatic Cache Update on Cache Miss
- Dirty Block Replacement
- Main Memory Interface
- Functional Verification using Verilog Testbench
- RTL Simulation in Xilinx Vivado

---

# Cache Specifications

| Parameter | Value |
|-----------|-------|
| Cache Mapping | Direct Mapped |
| Address Width | 8 Bits |
| Data Width | 8 Bits |
| Cache Lines | 4 |
| Block Size | 2 Bytes |
| Total Cache Size | 8 Bytes |
| Write Policy | Write-Back |
| Allocation Policy | Write-Allocate |
| Valid Bit | Supported |
| Dirty Bit | Supported |
| Design Language | Verilog HDL |
| Simulation Tool | Xilinx Vivado |

---

# Working

## CPU Read Operation

1. The CPU issues a read request with an 8-bit address.
2. The address decoder divides the address into **Tag**, **Index**, and **Offset**.
3. The Hit/Miss Detector compares the incoming tag with the stored tag of the selected cache line.
4. If the tags match and the valid bit is set, a **Cache Hit** occurs and the requested byte is returned directly from the cache.
5. If the tags do not match or the valid bit is cleared, a **Cache Miss** occurs.
6. On a cache miss, the controller checks whether the selected cache line contains a dirty block.
7. If the cache line is dirty, the existing block is written back to the main memory.
8. The required block is fetched from the main memory.
9. The fetched block is simultaneously forwarded to the CPU and written into the cache.
10. The cache tag and valid bit are updated, and the dirty bit is cleared for the newly allocated block.

---

## CPU Write Operation

1. The CPU issues a write request with an address and data.
2. The address is decoded into **Tag**, **Index**, and **Offset**.
3. The Hit/Miss Detector determines whether the requested block is present in the cache.
4. On a **Write Hit**, only the cache is updated with the new data, and the dirty bit is set. The main memory is not updated immediately.
5. On a **Write Miss**, the controller checks whether the selected cache line contains a dirty block.
6. If the existing cache block is dirty, it is written back to the main memory before replacement.
7. The required memory block is fetched from the main memory and allocated into the cache (**Write-Allocate**).
8. The CPU's write data is written into the corresponding byte of the cache block.
9. The dirty bit is set, indicating that the modified cache block will be written back to the main memory only when it is replaced.

---

# Verification

The design has been verified through a comprehensive Verilog testbench covering the following scenarios:

- Reset Verification
- Read Miss
- Read Hit
- Write Hit
- Read Updated Data
- Write Miss
- Dirty Block Replacement
- Write-Back Operation
- Cache Block Update
- Main Memory Read Operation
- Main Memory Write-Back Operation
- FSM State Transitions

---

# Future Enhancements

- Write Buffer
- Victim Cache
- Non-Blocking Cache
- Set-Associative Cache
- LRU Replacement Policy
- Performance Statistics (Hit Rate & Miss Rate)
 

---

# Tools Used

- Verilog HDL
- Xilinx Vivado
- Vivado Simulator

---

# Author

**Pothuganti Divya Sree**

**Roll No.: 124EC0063**

**B.Tech – Electronics and Communication Engineering**

**National Institute of Technology Rourkela**
