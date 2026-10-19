.PHONY: test lint clean
test:
	mkdir -p build
	iverilog -g2012 -s tb_router -o build/router.vvp rtl/mesh_router.sv tb/tb_router.sv
	vvp build/router.vvp
	iverilog -g2012 -s tb_mesh_2x2 -o build/mesh.vvp rtl/mesh_router.sv rtl/mesh_2x2.sv tb/tb_mesh_2x2.sv
	vvp build/mesh.vvp
	iverilog -g2012 -s tb_fifo -o build/fifo.vvp rtl/mesh_fifo.sv tb/tb_fifo.sv
	vvp build/fifo.vvp
lint:
	verilator --lint-only -Wno-fatal --top-module mesh_2x2 rtl/mesh_router.sv rtl/mesh_2x2.sv
clean:
	rm -rf build
