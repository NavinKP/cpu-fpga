# Single cycle CPU - running on FPGA
Implement all instructions for RISC-V including Branch instructions. This repository will provide the automation flow for running the design into hardware.

## Changes to make in cpu.v file:
There is a change in the interface of the cpu.v file in order for the evaluation backend to be able to check the registers via the ```registers``` port as shown below:

```
module cpu (
    input clk, 
    input reset,
    output [31:0] iaddr,
    input [31:0] idata,
    output [31:0] daddr,
    input [31:0] drdata,
    output [31:0] dwdata,
    output [3:0] dwe,
    output [32*32-1:0] registers  // EXTRA PORT

);
```

IMPORTANT: make sure the ```registers``` port is defined in the exact way shown above. Connect this port to the bit vector formed by concatenating all the registers. For example:

```assign registers = {r[31], r[30], r[29], r[28], r[27], r[26], r[25], r[24], r[23], r[22], r[21], r[20], r[19], r[18], r[17], r[16], r[15], r[14], r[13], r[12], r[11], r[10], r[9], r[8], r[7], r[6], r[5], r[4], r[3], r[2], r[1], r[0]};```

You may need to modify your register file module accordingly.

This change just enables the evaluation script to directly access the registers at the top level.


## Steps to run:
1. Clone this repository:
```
git clone https://gitlab.com/BalaDhinesh/cpu_fpga
cd cpu_fpga
git checkout ee2003-server
```

2. Update ```cpu.v``` and add all additional verilog module files you created (like regfile, alu etc). IMP: Do NOT add your versions of imem, dmem or any other file which was given with the problem statement. Only add cpu.v and other associated modules.

Update the list inside ```program_file.txt```.

3. Run the python file. This will take care of creating a block design on Vivado and generate bitstream.
```
python harness.py
```
Check the entire set of printed messages for any "ERROR" lines. If you see "ERROR" anywhere, that means the implementation failed.

4. Once the bitstream has been generated successfully, following outputs are generated.

- ```harness_axi_ip```   - IP generation. Leave this for now.

- ```harness_axi_proj``` - Vivado project file. 

- ```PYNQ_cpu.tar```       - PYNQ Overlay(bitstream related) files.

5. Open the FPGA Remote Jupyter server. 
- Upload the ```PYNQ_cpu.tar``` tar file 
- Open terminal in server and untar using 
```
cd /home/xilinx/jupyter_notebooks
tar -xvf PYNQ_cpu.tar
```
- Now run the ```cpu.ipynb``` file.

```WARNING: [Vivado 12-8222] Failed run(s) : 'design_1_harness_axi_ip_v1_0_0_0_synth_1'```
If you get this error from the script, there is some problem in the cpu design. Look into this ```/harness_axi_proj/harness_axi_proj.runs/design_1_harness_axi_ip_v1_0_0_0_synth_1/runme.log``` file to debug the issue.
