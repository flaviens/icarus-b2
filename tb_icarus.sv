`define DO_TRACE

module testbench;

  bit [31:0] clkin_data_words [5]; // Maybe it will be unhappy in case 6==0
  bit [31:0] in_data_words    [96 / 32];
  bit [31:0] out_data_words   [96 / 32];

  int fd;
  int in_buf;

  int next_actor_id;
  int next_random_input;
  int num_32bit_inputs;
  int initial_num_32bit_inputs;
  int curr_actor_id_dbg;

  bit [63:0] cumulated_output;

  // Instantiate the design under test (DUT)
  bit [32*6-1:0]  clkin_data;
  bit [96-1:0]  in_data;
  bit [96-1:0] out_data;
  top dut(
    clkin_data,
    in_data, out_data);

  always_comb begin
    for (int clkin_word_id = 0; clkin_word_id < 6; clkin_word_id++) begin
      clkin_data[32*clkin_word_id +: 32] = clkin_data_words[clkin_word_id];
    end
    for (int in_word_id = 0; in_word_id < 96 / 32; in_word_id++) begin
      in_data[32*in_word_id +: 32] = in_data_words[in_word_id];
    end
    for (int out_word_id = 0; out_word_id < 96 / 32; out_word_id++) begin
      out_data_words[out_word_id] = out_data[32*out_word_id +: 32];
    end
  end

  // Stimulus generation
  initial begin
    cumulated_output = 0;

    fd = $fopen("inputs.txt", "r");
    if (fd == 0) begin
      $display("Error: could not open file `inputs.txt`.");
      $finish;
    end

`ifdef DO_TRACE
    $dumpfile("icarus_dump.vcd");
    $dumpvars(0,dut);
`endif

    $fscanf(fd, "%d", num_32bit_inputs);
    initial_num_32bit_inputs = num_32bit_inputs;

    while (num_32bit_inputs > 0) begin
      num_32bit_inputs--;
      $fscanf(fd, "%d", next_actor_id);
      $fscanf(fd, "%h", next_random_input);

      // If this is a subnet input (with more than a single 32-bit word)
      if (next_actor_id < 1) begin
        curr_actor_id_dbg = next_actor_id;

        in_data_words[(next_actor_id*96)/32] = next_random_input;
        for (int word_id = (next_actor_id*96)/32+1; word_id < ((next_actor_id+1)*96)/32; word_id++) begin
          $fscanf(fd, "%d", next_actor_id);
          if (next_actor_id != curr_actor_id_dbg) begin
            $display("Error: expected to read %d inputs for subnet %d, got %d.", 96 / 32, curr_actor_id_dbg, word_id - (next_actor_id*96)/32);
            $finish;
          end
          $fscanf(fd, "%h", next_random_input);
          in_data_words[word_id] = next_random_input;
          num_32bit_inputs--;
        end

      end else begin
        clkin_data_words[next_actor_id - 1] = next_random_input;
      end
      #1;

      // Cumulate the outputs
      for (int word_id = 0; word_id < 96 / 32; word_id++) begin
        cumulated_output += out_data_words[word_id];
      end
    end

    if (num_32bit_inputs != 0) begin
      $display("Error: expected 0 remaining inputs, got %d.", num_32bit_inputs);
      $finish;
    end

    $display("Output signature: %d.", cumulated_output);

  end
endmodule
