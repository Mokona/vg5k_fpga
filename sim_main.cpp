#include "Vef9345_inout_wrapper.h"
#include "verilated.h"
//#include "verilated_vcd_c.h"
#include <iostream>
#include <deque>

class Step {
public:
	virtual bool step(Vef9345_inout_wrapper *chip) = 0;
	virtual ~Step() {}
};

class SetAddr : public Step {
public:
	SetAddr(int addr) : addr(addr), state(STATE_PRE) {}

	bool step(Vef9345_inout_wrapper *chip) override {
		switch (state) {
		case STATE_PRE:
			chip->as = 1;
			chip->rw = 1;
			chip->ds = 1;
			chip->data_bus_in = addr;
			chip->data_bus_in_en = 1;
			break;
		case STATE_WRITE:
			chip->as = 0;
			return false;
		}
		state = state + 1;
		return true;
	}
private:
	int addr;
	enum {
		STATE_PRE,
		STATE_WRITE,
	};
	int state;
};

class WriteData : public Step {
public:
	WriteData(int reg_val) : reg_val(reg_val), state(STATE_PRE) {}

	bool step(Vef9345_inout_wrapper *chip) override {
		switch (state) {
		case STATE_PRE:
			chip->as = 1;
			chip->rw = 1;
			chip->ds = 1;
			chip->data_bus_in = reg_val;
			chip->data_bus_in_en = 1;
			break;
		case STATE_WRITE:
			chip->rw = 0;
			return false;
		}
		state = state + 1;
		return true;
	}
private:
	int reg_val;
	enum {
		STATE_PRE,
		STATE_WRITE,
	};
	int state;
};

class ReadData : public Step {
public:
	ReadData() {}

	bool step(Vef9345_inout_wrapper *chip) override {
		switch (state) {
		case STATE_PRE:
			chip->as = 1;
			chip->rw = 1;
			chip->ds = 0;
			chip->data_bus_in_en = 0;
			break;
		case STATE_READ:
			std::cout << "ReadData: " << (int)chip->data_bus_out << std::endl;
			return false;
		}
		state = state + 1;
		return true;
	}
private:
	int reg_val;
	enum {
		STATE_PRE,
		STATE_READ,
	};
	int state;
};

int main(int argc, char** argv) {
	VerilatedContext* contextp = new VerilatedContext;
	contextp->commandArgs(argc, argv);
	Vef9345_inout_wrapper* top = new Vef9345_inout_wrapper{contextp};

	/*
	Verilated::traceEverOn(true);
	VerilatedVcdC* tfp = new VerilatedVcdC;
	top->trace(tfp, 99);  // Trace 99 levels of hierarchy (or see below)
	// tfp->dumpvars(1, "t");  // trace 1 level under "t"
	tfp->open("obj_dir/simx.vcd");
	*/

	std::deque<Step*> steps;

	steps.push_back(new SetAddr(0x20));
	steps.push_back(new WriteData(41));
	steps.push_back(new SetAddr(0x21));
	steps.push_back(new WriteData(42));
	steps.push_back(new SetAddr(0x22));
	steps.push_back(new WriteData(43));

	steps.push_back(new SetAddr(0x20));
	steps.push_back(new ReadData());
	steps.push_back(new SetAddr(0x21));
	steps.push_back(new ReadData());
	steps.push_back(new SetAddr(0x22));
	steps.push_back(new ReadData());

	auto step = steps.begin();

	top->cs_ = 0;
	top->as = 1;
	top->ds = 1;
	top->rw = 1;
	top->data_bus_in_en = 0;
	top->eval();

	while (!contextp->gotFinish() && step != steps.end()) {

		contextp->timeInc(1);
		top->clk_in = !top->clk_in;

		bool cont = (*step)->step(top);
		if (!cont) step++;

		top->eval();
	}
	delete top;
	delete contextp;
return 0;
}
