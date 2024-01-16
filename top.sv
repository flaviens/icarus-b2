module top(clkin_data, in_data, out_data, probe_data);
  bit _0_;
  bit [8:0] _1_;
  bit [26:0] _2_;
  bit [26:0] _3_;
  bit [10:0] _4_;
  bit [8:0] celloutsig_0z;
  bit [10:0] celloutsig_1z;
  bit [26:0] celloutsig_2z;
  input [159:0] clkin_data;
  bit [159:0] clkin_data;
  input [95:0] in_data;
  bit [95:0] in_data;
  output [95:0] out_data;
  bit [95:0] out_data;
  output [31:0] probe_data;
  bit [31:0] probe_data;
  assign celloutsig_0z = _0_ ? in_data[37:29] : { in_data[95:89], _1_[1:0] };
  assign celloutsig_2z = { celloutsig_0z[8:4], _3_[21:0] } - { celloutsig_1z[5:1], _2_[21:0] };

logic my_new_signal_0;
assign my_new_signal_0 = clkin_data[0];

always_ff @ ( posedge my_new_signal_0 )
    celloutsig_1z <= { _4_[10:9], celloutsig_0z };
  assign _1_[8:2] = in_data[95:89];
  assign _2_[26:22] = celloutsig_1z[5:1];
  assign _3_[26:22] = celloutsig_0z[8:4];
  assign _4_[8:0] = celloutsig_0z;
  assign out_data[58:32] = celloutsig_2z;
endmodule
