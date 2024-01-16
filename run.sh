mkdir -p icarus_obj_dir
rm -f icarus_obj_dir/Vtop && iverilog -g2012 -o icarus_obj_dir/Vtop top.sv tb_icarus.sv
vvp icarus_obj_dir/Vtop +vcd
