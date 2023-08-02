module SRTDivision(
    input logic signed [31:0] dividend,
    input logic signed [31:0] divisor,
    output logic signed [31:0] quotient,
    output logic signed [31:0] remainder,
    output logic ready
);

    // Number of bits for the dividend and divisor.
    parameter WIDTH = 32;

    logic signed [WIDTH-1:0] A;
    logic signed [WIDTH-1:0] M;
    logic signed [WIDTH-1:0] Q;
    logic signed [WIDTH-1:0] Q_neg;
    logic [2:0] state;

    always_comb begin
        if (state == 3'b0) begin
            A = 0;
            M = 0;
            Q = 0;
            Q_neg = 0;
            ready = 0;
        end else if (state == 3'b1) begin
            // Initialize A, M, Q registers.
            A = dividend;
            M = divisor;
            Q = 0;
            Q_neg = 0;
            ready = 0;
        end else if (state == 3'b100) begin
            // Subtract and compare.
            if (A[WIDTH-1] == Q[WIDTH-1])
                A = A - M;
            else
                A = A + M;
            state = 3'b011;
        end else if (state == 3'b011) begin
            // Shift right arithmetic.
            A = {A[WIDTH-2], A};
            Q = {Q[WIDTH-2], A[WIDTH-1]};
            state = 3'b010;
        end else if (state == 3'b010) begin
            // Update quotient.
            Q_neg = Q_neg | A[WIDTH-1];
            state = 3'b100;
        end
    end

    // Output ready signal when the division is complete.
    assign ready = (state == 3'b000);

    // Complement the quotient if needed to handle negative results.
    assign quotient = (Q_neg) ? ~Q + 1 : Q;
    assign remainder = A;

endmodule
