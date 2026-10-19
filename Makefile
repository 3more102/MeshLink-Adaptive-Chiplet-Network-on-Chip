.PHONY: test lint
test:
	mkdir -p build
	iverilog -g2012 -s tb_router -o build/router.vvp rtl/mesh_router.sv tb/tb_router.sv
	vvp build/router.vvp
lint:
	verilator --lint-only -Wno-fatal --top-module mesh_router rtl/mesh_router.sv
