module mem_Register #(
    parameter int DataWidth = 32,
    parameter int NumEntries = 31,
    //parameter string ReadmembFilename = "memory_init_file.memb" //cannot use with digitaljs
) (
    input  logic clk_i,
    input  logic reset_i,

    //wr_vlaid is a control signal depending on if the rd was valid(depoends on inst type) S and SB instructions dont use rd

    input  logic                          wr_valid_i,
    input  logic [DataWidth-1:0]          wr_data_i,
    input  logic [$clog2(NumEntries)-1:0] wr_addr_i,

    // input  logic                          rd_valid_i,
    // input  logic [$clog2(NumEntries)-1:0] rd_addr_i,
    // output logic [DataWidth-1:0]          rd_data_o,



    //rs1 valid and rs2 valid are ctrl signals which should depend on the Instruction Type


    input  logic                          rs1_valid_i,
    input  logic [$clog2(NumEntries)-1:0] rs1_addr_i,
    output logic [DataWidth-1:0]          rs1_data_o,


    input  logic                          rs2_valid_i,
    input  logic [$clog2(NumEntries)-1:0] rs2_addr_i,
    output logic [DataWidth-1:0]          rs2_data_o
);

    logic [DataWidth-1:0] mem [NumEntries];//the mem comp


    initial begin
        // Display depth and width (You will need to match these in your init file)
        $display("%m: NumEntries is %d, DataWidth is %d", NumEntries, DataWidth);
        // logic [bar:0] foo [baz];
        // In order to get the memory contents in icarus you need to run this for loop during initialization:
        for (int i = 0; i < NumEntries; i++) begin
            $dumpvars(0,mem[i]);
        end
   end



always_ff @(posedge clk_i) begin
    if(reset_i) begin

    end else begin
        // if(rd_valid_i) begin
        //     rd_data_o <= mem[rd_addr_i];
        // end

        if(rs1_valid_i) begin
            rs1_data_o <= mem[rs1_addr_i];
        end

        if(rs2_valid_i) begin
            rs2_data_o <= mem[rs2_addr_i];
        end

        if(wr_valid_i) begin
            mem[wr_addr_i] <= wr_data_i;
        end
    end
end


endmodule
