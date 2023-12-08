#include "Vserial_loopback.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include <stdio.h>
#include <stdlib.h>

void tick(int tickcount, Vserial_loopback *tb, VerilatedVcdC *tfp) {
  tb->eval();
  if (tfp)
    tfp->dump(tickcount * 4 - 2);
  // tb->i_clk = 1;
  tb->eval();
  if (tfp)
    tfp->dump(tickcount * 4);
  // tb->i_clk = 0;
  tb->eval();
  if (tfp) {
    tfp->dump(tickcount * 4 + 2);
    tfp->flush();
  }
}

int main(int argc, char **argv) {
  unsigned tickcount = 0;

  Verilated::commandArgs(argc, argv);

  // Instantiate design
  Vserial_loopback *tb = new Vserial_loopback;

  Verilated::traceEverOn(true);
  VerilatedVcdC *tfp = new VerilatedVcdC;
  tb->trace(tfp, 00);
  tfp->open("bridgetrace.vcd");

  if (tfp) {
    tfp->dump(1);
  }

  // Run design through 20 timesteps
  for (int k = 0; k < 20; k++) {
    tick(++tickcount, tb, tfp);
    tb->uart_txd_in = k & 1;

    printf("k = %2d, ", k);
    printf("in = %2d, ", tb->uart_txd_in);
    printf("out = %2d\n", tb->uart_rxd_out);
  }
}
