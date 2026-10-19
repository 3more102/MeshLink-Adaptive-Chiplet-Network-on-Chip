# Phase 2: buffering foundation

Added a parameterized synchronous FIFO with ready/valid interfaces, circular pointers, occupancy and simultaneous enqueue/dequeue handling. A directed test covers filling, backpressure, draining, and order.

**Not yet integrated into the router datapath.** Integration requires registered per-port buffering and revised arbitration; the existing 2x2 fabric remains the Phase 1 baseline.

Next: integrate FIFOs, add randomized end-to-end scoreboard tests, measure throughput/latency and check contention fairness. No simulation pass is claimed until CI executes.
