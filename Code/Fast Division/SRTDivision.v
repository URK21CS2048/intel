module SRTDivision(
    logic signed [31:0] dividend,
    logic signed [31:0] divisor,
    output logic signed [31:0] quotient,
    output logic signed [31:0] remainder,
    output logic ready
);

    parameter WIDTH = 32;

    wire signed [WIDTH-1:0] A;
    wire signed [WIDTH-1:0] M;
    wire signed [WIDTH-1:0] Q;
    wire signed [WIDTH-1:0] Q_neg;
    wire [2:0] state;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            A <= 0;
            M <= 0;
            Q <= 0;
            Q_neg <= 0;
            state <= 3'b0;
        end else if (start) begin
            // Initialize A, M, Q registers.
            A <= dividend;
            M <= divisor;
            Q <= 0;module SRTDivision(
    logic signed [31:0] dividend,
    logic signed [31:0] divisor,
    output wire [31:0] quotient,
    output wire [31:0] remainder,
    output wire ready
);

    parameter WIDTH = 32;

    wire signed [WIDTH-1:0] A;
    wire signed [WIDTH-1:0] M;
    wire signed [WIDTH-1:0] Q;
    wire signed [WIDTH-1:0] Q_neg;
    wire [2:0] state;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            A <= 0;
            M <= 0;
            Q <= 0;
            Q_neg <= 0;
            state <= 3'b0;
        end else if (start) begin
            // Initialize A, M, Q registers.
            A <= dividend;
            M <= divisor;
            Q <= 0;
            Q_neg <= 0;
            state <= 3'b100; // Starting state.
        end else if (state != 3'b000) begin
            case (state)
                3'b100: // Subtract and compare.
                    if (A[WIDTH-1] == Q[WIDTH-1])
                        A <= A - M;
                    else
                        A <= A + M;
                    state <= 3'b011;
                3'b011: // Shift right arithmetic.
                    A <= {A[WIDTH-2], A};
                    Q <= {Q[WIDTH-2], A[WIDTH-1]};
                    state <= 3'b010;
                3'b010: // Update quotient.
                    Q_neg <= Q_neg | A[WIDTH-1];
                    state <= 3'b100;
            endcase
        end
    end

    // Output ready signal when the division is complete.
    assign ready = (state == 3'b000);

    // Complement the quotient if needed to handle negative results.
    assign quotient = (Q_neg) ? ~Q + 1 : Q;
    assign remainder = A;

endmodule