#!/bin/bash


set -Eeuo pipefail

echo -e "add_au280_support.sh -- apply changes to support AU280"

cur_dir=$(pwd)
root_dir=$(dirname $cur_dir)
patch_dir=${root_dir}/patches/au280
lib_dir=${root_dir}/lib
shell_dir=${root_dir}/shell
nic_dir=${root_dir}/base_nics/open-nic-shell
nic_src_dir=${root_dir}/base_nics/open-nic-shell/src

cd ${nic_src_dir}
mkdir -p ${nic_src_dir}/mem_ctrl/au280/vivado_ip
cp ${patch_dir}/mem_ctrl/au280/* ${nic_src_dir}/mem_ctrl/au280/vivado_ip

cp ${patch_dir}/constr/* ${nic_dir}/constr/au280

cp ${patch_dir}/open_nic_shell.sv ${nic_src_dir}/open_nic_shell.sv

cp ${patch_dir}/plugin/p2p/p2p_250mhz.sv ${nic_dir}/plugin/p2p/p2p_250mhz.sv

cp ${patch_dir}/plugin/p2p/box_250mhz/user_plugin_250mhz_inst.vh ${nic_dir}/plugin/p2p/box_250mhz/user_plugin_250mhz_inst.vh

cp ${patch_dir}/qdma_subsystem/qdma_subsystem.sv ${nic_src_dir}/qdma_subsystem/qdma_subsystem.sv

cp ${patch_dir}/qdma_subsystem/qdma_subsystem_qdma_wrapper.v ${nic_src_dir}/qdma_subsystem/qdma_subsystem_qdma_wrapper.v

cp ${patch_dir}/qdma_subsystem/vivado_ip/qdma_no_sriov_au280.tcl ${nic_src_dir}/qdma_subsystem/vivado_ip/qdma_no_sriov_au280.tcl

cp -r ${patch_dir}/system_config/* ${nic_src_dir}/system_config

cp ${patch_dir}/utility/vivado_ip/axi_clock_converter_for_mem_au280.tcl ${nic_src_dir}/utility/vivado_ip/axi_clock_converter_for_mem_au280.tcl

# add comment test, and here we start to override some ERNIC 4 and QDMA 5 specific update

# lib is there not as a submodule, so we can directly override it
cp ${patch_dir}/design_patch_for_ernic_4/lib/* ${lib_dir}/

# update vitis_net component, qdma, rdma, and system_config
cp ${patch_dir}/ernic4/design_patch_for_ernic_4/src/cl_box.tcl ${shell_dir}/compute/lookside/
cp ${patch_dir}/ernic4/design_patch_for_ernic_4/src/compute_logic_wrapper.sv ${shell_dir}/compute/lookside/
cp ${patch_dir}/ernic4/design_patch_for_ernic_4/src/packet_classification.sv ${shell_dir}/packet_classification/
cp ${patch_dir}/ernic4/design_patch_for_ernic_4/src/packet_parser.tcl ${shell_dir}/plugs/rdma_onic_plugin/vivado_ip/
cp ${patch_dir}/ernic4/design_patch_for_ernic_4/src/rdma_core.tcl ${shell_dir}/plugs/rdma_onic_plugin/vivado_ip/

cp ${patch_dir}/ernic4/design_patch_for_ernic_4/src/qdma_no_sriov_au280.tcl ${nic_src_dir}/qdma_subsystem/vivado_ip/qdma_no_sriov_au280.tcl
cp ${patch_dir}/ernic4/design_patch_for_ernic_4/src/rdma_subsystem.sv ${nic_src_dir}/rdma_subsystem/
cp ${patch_dir}/ernic4/design_patch_for_ernic_4/src/rdma_subsystem_wrapper.sv ${nic_src_dir}/rdma_subsystem/

cp ${patch_dir}/ernic4/design_patch_for_ernic_4/src/system_config_address_map.sv ${nic_src_dir}/system_config/
cp ${patch_dir}/ernic4/design_patch_for_ernic_4/src/system_config_axi_crossbar.tcl ${nic_src_dir}/system_config/vivado_ip/

# update top level file
cp ${patch_dir}/ernic4/design_patch_for_ernic_4/src/open_nic_shell.sv ${nic_src_dir}/open_nic_shell.sv

# update application src files
cp ${patch_dir}/ernic4/design_patch_for_ernic_4/sw_src/* ${root_dir}/examples/rdma_test/

# update simulation files
cp ${patch_dir}/ernic4/sim_patch_for_ernic4/ernic_header.py ${root_dir}/sim/
cp ${patch_dir}/ernic4/sim_patch_for_ernic4/packet_gen.py ${root_dir}/sim/
cp ${patch_dir}/ernic4/sim_patch_for_ernic4/run_testcase.py ${root_dir}/sim/
cp ${patch_dir}/ernic4/sim_patch_for_ernic4/rdma_rn_wrapper.sv ${root_dir}/sim/src/
cp ${patch_dir}/ernic4/sim_patch_for_ernic4/rn_tb_2rdma_top.sv ${root_dir}/sim/src/
cp ${patch_dir}/ernic4/sim_patch_for_ernic4/gen_vivado_ip.tcl ${root_dir}/sim/scripts/
cp ${patch_dir}/ernic4/sim_patch_for_ernic4/kernel.f ${root_dir}/sim/scripts/
cp ${patch_dir}/ernic4/sim_patch_for_ernic4/simulate.sh ${root_dir}/sim/scripts/
cp ${patch_dir}/ernic4/sim_patch_for_ernic4/xsim_compile.do ${root_dir}/sim/scripts/

# update toolflow files and timing constraint files
cp ${patch_dir}/ernic4/Makefile ${root_dir}/scripts/
cp ${patch_dir}/ernic4/build.tcl ${nic_dir}/script/
cp ${patch_dir}/ernic4/timing.xdc ${nic_dir}/constr/au280/

echo -e "add_au280_support.sh done!"


cd ${cur_dir}

$SHELL
