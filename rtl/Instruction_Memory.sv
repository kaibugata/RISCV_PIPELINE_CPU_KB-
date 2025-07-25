module Instruction_Memory #(
    parameter int DataWidth = 32,
    parameter int NumEntries = 31,
    parameter string ReadmembFilename = "instruction_memory_init_file.memb" //cannot use with digitaljs
) (
    input  logic clk_i,
    input  logic reset_i,

    input  logic                          rd_valid_i,//maybe not needed
    input  logic [$clog2(NumEntries)-1:0] rd_addr_i,
    output logic [DataWidth-1:0]          rd_data_o
);

    logic [DataWidth-1:0] mem [NumEntries];//the mem comp


    initial begin
        // Display depth and width (You will need to match these in your init file)
        $display("%m: NumEntries is %d, DataWidth is %d", NumEntries, DataWidth);
        $readmemb("instruction_memory_init_file.memb", mem);
        // logic [bar:0] foo [baz];
        // In order to get the memory contents in icarus you need to run this for loop during initialization:
        for (int i = 0; i < NumEntries; i++) begin
            $dumpvars(0,mem[i]);
        end
   end



always_ff @(posedge clk_i) begin
    if(reset_i) begin
        rd_data_o <= 32'b00000000000000000000000000010011; //NOP
        //     for (int i = 0; i < NumEntries; i++) begin
        //     mem[i] <= '0;
        // end
    end else begin
        if(rd_valid_i) begin
            rd_data_o <= mem[rd_addr_i];
        end
    end
end


endmodule
