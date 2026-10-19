# MeshLink — Adaptive Chiplet Network-on-Chip

**Status: Phase 0 baseline (not yet adaptive or a complete mesh).**

A synthesizable single-flit, 5-port XY router with round-robin arbitration and ready/valid backpressure. This is the first building block toward an adaptive chiplet NoC.

## Run
Install Icarus Verilog, then run `make test`. Optional: `make lint` with Verilator.

## Interface
Ports are Local, North, East, South, West (0..4). Top eight data bits encode destination X and Y as four-bit unsigned values. All remaining bits are payload. One flit constitutes one packet. North means increasing Y.

## Scope and limitations
No ingress FIFOs, credits, virtual channels, mesh fabric, UCIe/AXI integration, adaptive routing, packet segmentation, or CDC yet. Input producers must keep valid and data stable until ready. XY routing requires topology-consistent connectivity and an appropriately provisioned network.

## Roadmap
1. Add registered input FIFOs and randomized self-checking tests.
2. Connect a parameterized 2x2 and 4x4 mesh; validate end-to-end traffic.
3. Add virtual channels and credit-based flow control.
4. Implement a deadlock-safe adaptive algorithm with escape virtual channel.
5. Build UVM tests, traffic benchmarks, synthesis reports, FPGA demonstrator.

## Research metrics
Throughput (flits/cycle), mean/p99 latency, fairness, router area, critical-path timing, and power estimates. Compare against fixed XY under identical traffic.
