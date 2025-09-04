
# RISC-V 5 Stage Pipelined Processor Prototype

This project demonstrates a 5 stage processor I made during the summer after taking my first Computer Architecture class.
The template for this project was provided by my professor Ethan Sifferman and therefore some things like the Makefile may not make sense in this context.

## Description

This is the RTL for a 5 stage processor that I made from scratch. It is currently in a complete state but can be worked on to improve and change later. This processor works by taking in a file `instruction_memory_init_file.memb` which is located in `"rtl"`.

## Drawbacks/Things to improve on

* Since i've only taken an intro class, I don't actually make a SoC where the processor gets the instructions from elsewhere. So I suppose I could use a fifo to push binary instructions into the instruction memory instead of using intiialization files.
* One thing I really want to do is run static timing analysis on this. I was working on this using Xilinx Vivado and had trouble using their timing settings(I just dont know how to use it). My goal is to potentially run timing analysis so I can actually see what clock period this processor can run on and so I can make ome bottlenecks in the RTL faster.
* I made the memory blocks using packed arrays ex: `logic [31:0] mem [44:0]` as such, for instructions with offsets like `"sw x1, 5(x2)"` or `"lw x3, 2(x7)"` they do not offset by bytes and instead offset by blocks. So the first instruction will store x1 at x2+5 -> x7 or it will load x7+2-> x9 at x3. This of course is not what I intended to do. In the future I might do research into figuring out how I can fix it.

## Notable File Explanations

### [`".rtl/RISC_CPU.sv"`](./rtl/RISC_CPU.sv)

The file RISC_CPU.sv is our TOP for the project and contains the main CPU

### [`"dv/FullPipelineTB1.sv"`](./dv/FullPipelineTB1.sv)

The file FullPipelineTB1.sv is our main testbench that we used to test the entire pipeline


## Pipeline Diagram(pipeline.png)

This image below is the main diagram that I used to create the pipeline.
The only difference is that I opted to remove ALU_control and instead merge it with Control, to take care of all ALU ctrl stuff in `Control.sv`
I also added something unique to my processor called `Branch.sv`. Which takes in the result of the ALU and compares with the the instruction to see if the branch was taken or not.

Outside of that, everything else is similar to the diagram.


![image link](pipeline.png)
