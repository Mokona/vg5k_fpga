all:
	${VERILATOR_ROOT}verilator -CFLAGS "-g" --cc --exe --build -Wall sim_main.cpp ef9345_inout_wrapper.v
