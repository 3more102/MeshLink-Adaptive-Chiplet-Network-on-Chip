# Phase 1 — Four-node XY mesh

## Implemented
- 2x2 combinationally linked five-port routers.
- Local injection/ejection and four cardinal directions.
- Directed tests: diagonal traffic in both directions and two-hop backpressure.
- Continuous integration runs both unit and integration testbenches.

## Critical limitations
- There are no ingress buffers; this is a combinational multi-hop network and timing will degrade with topology size.
- This is NOT congestion-adaptive routing and does NOT implement credit-based flow control or virtual channels.
- All traffic is single-flit and destination coordinates are carried in the high eight bits.
- Tests are directed only; exhaustive contention, fairness, reset-in-flight, and random stress tests are future work.
- No FPGA, synthesis, or silicon timing measurements are claimed.

## Next
Introduce per-input FIFOs and registered inter-router links; test packet conservation under randomized backpressure; then introduce deadlock-safe adaptive routing.
