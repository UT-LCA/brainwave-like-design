`include "includes.v"


`timescale 1ps/1ps

module test ();
    reg clk, rst, vec_we, start, done;

    reg [9:0] counter;

    // reg [`MRF_DWIDTH*`NUM_LDPES-1:0] mat_mem [(1<<`MRF_AWIDTH)-1:0];
    reg [`VRF_DWIDTH-1:0] vec_mem [(1<<`VRF_AWIDTH)-1:0];

    reg [`VRF_AWIDTH-1:0] addr;

    wire [`ORF_DWIDTH-1:0] result;

    initial begin
        clk <= 0;
        forever begin
            # 1 clk <= ~clk;
        end
    end

    always @(posedge clk) begin
        if (rst) begin
            counter <= 0;
            done <= 0;
        end
        else begin
            if (counter == 10) begin
                done <= 1;
                counter <= 0;
            end
            else begin
                counter <= counter + 1;
                if (done) begin
                    done <= 0;
                end
            end
        end
    end


    initial begin
        // $readmemh("mat.txt", mat_mem, 0);
        $readmemh("vec.txt", vec_mem, 0);
    end

    initial begin
        #0 rst=1'b1; vec_we=1'b0; start=1'b0;
        #2 rst=1'b0; vec_we=1'b1;
        #1 start=1'b1;
        #200 $finish;
    end

    always @(posedge clk) begin
        if (rst) begin
            addr <= {`VRF_AWIDTH{1'b0}};
        end
        else begin
            addr <= addr + 1;
        end
    end

    baseline dut (
        .clk(clk),
        .start(start),
        .rst(rst),
        .done(done),
        .vec_we(vec_we),
        .vrf_wr_addr(addr),
        .vec(vec_mem[addr]),
        .result(result)
    );

endmodule