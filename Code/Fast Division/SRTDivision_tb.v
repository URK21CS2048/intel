module SRTDivision_tb;
    parameter WIDTH = 32;
    
    logic clk;
    logic reset;
    logic start;
    logic signed [WIDTH-1:0] dividend;
    logic signed [WIDTH-1:0] divisor;
    logic signed [WIDTH-1:0] quotient;
    logic signed [WIDTH-1:0] remainder;
    logic ready;

    SRTDivision dut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .dividend(dividend),
        .divisor(divisor),
        .quotient(quotient),
        .remainder(remainder),
        .ready(ready)
    );

    initial begin
        clk = 0;
        reset = 1;
        start = 0;
        dividend = 0;
        divisor = 0;
        #5 reset = 0;
        #5 start = 1;
        #5 dividend = 40; // Set dividend value
        #5 divisor = 5;   // Set divisor value
        #100;
        $display("Quotient: %d, Remainder: %d", quotient, remainder);
        $finish;
    end

    always #5 clk = ~clk;

endmodule