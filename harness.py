import os
import argparse
import sys
import re

def main():
    parser = argparse.ArgumentParser(description='FPGA Remote Lab Setup Automation Script - CPU Assignment')
    parser.add_argument('--part_no', type=str, default="xc7z020clg400-1", help='FPGA board part number')
    args = parser.parse_args()
    print("FPGA Remote Lab Automation Script - CPU Assignment")
    
    print("\n**************Starting AXI Lite IP Packaging******************\n")
    output_dir = "./src/axi_lite"
    os.system("mkdir -p cached_results")
    os.system("mkdir -p cached_results/harness_axi_proj.cache")
    
    try:
        os.system("vivado -mode batch -source "+output_dir+"/ip_create.tcl -nolog -nojournal")
    except:
        print("Error - IP Generation")
        exit()
    print("\n**************Starting Block design and bitstream generation******************\n")
    try:
        os.system("vivado -mode batch -source "+output_dir+"/bd_bitstream.tcl -nolog -nojournal")
    except:
        print("Error - Block design and bitstream Generation")
        exit()
    if(os.path.exists("./harness_axi_proj/harness_axi_proj.runs/impl_1/design_1_wrapper.bit")):
        os.system("mkdir -p PYNQ_cpu/overlay")
        os.system("cp ./harness_axi_proj/harness_axi_proj.runs/impl_1/design_1_wrapper.bit  ./PYNQ_cpu/overlay/harness_axi.bit")
        os.system("cp ./harness_axi_proj/harness_axi_proj.srcs/sources_1/bd/design_1/hw_handoff/design_1_bd.tcl ./PYNQ_cpu/overlay/harness_axi.tcl")
        os.system("cp ./harness_axi_proj/harness_axi_proj.srcs/sources_1/bd/design_1/hw_handoff/design_1.hwh ./PYNQ_cpu/overlay/harness_axi.hwh")
        os.system("rm -r NA")
        os.system("tar -zcvf PYNQ_cpu.tar PYNQ_cpu/")
        os.system("cp -r ./harness_axi_proj/harness_axi_proj.cache/ ./cached_results/harness_axi_proj.cache")
        print("Done!!")
    else:
        sys.exit("Error: Bitstream not generated. Look for errors above.")

if __name__ == "__main__":
    main()
