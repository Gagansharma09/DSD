`timescale 1ns / 1ps

/**
* @file counter_tb.sv
* @brief Test bench for the updown_counter module.
*/

module counter_tb();

    logic clk;
    logic rst_n;
    logic load;
    logic up_down;
    logic enable;
    logic [3:0] d_in;
    logic [3:0] count;
    logic test_passed;

    // =====================================================
    // Clock generation
    // 10ns clock period
    // =====================================================

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // =====================================================
    // DUT Instantiation
    // =====================================================

    updown_counter dut(
        .clk(clk),
        .rst_n(rst_n),
        .load(load),
        .up_down(up_down),
        .enable(enable),
        .d_in(d_in),
        .count(count)
    );

    // =====================================================
    // Test Sequence
    // =====================================================

    initial begin

        test_passed = 1'b1;

        // Initial Reset
        rst_n    = 0;
        load     = 0;
        up_down  = 1;
        enable   = 0;
        d_in     = 4'h0;

        #20;
        rst_n = 1;

        // =================================================
        // Test Case 1 : Load value
        // =================================================

        d_in = 4'h7;
        load = 1;

        #10;

        load = 0;

        if (count !== 4'h7) begin
            $display("Test 1 Failed : Load operation");
            test_passed = 1'b0;
        end
        else
            $display("Test 1 Passed");

        // =================================================
        // Test Case 2 : Count Up
        // =================================================

        enable  = 1;
        up_down = 1;

        #40;

        if (count !== 4'hB) begin
            $display("Test 2 Failed : Count Up");
            test_passed = 1'b0;
        end
        else
            $display("Test 2 Passed");

        // =================================================
        // Test Case 3 : Count Down
        // =================================================

        up_down = 0;

        #30;

        if (count !== 4'h8) begin
            $display("Test 3 Failed : Count Down");
            test_passed = 1'b0;
        end
        else
            $display("Test 3 Passed");

        // =================================================
        // Test Case 4 : Disable Counter
        // =================================================

        enable = 0;

        #20;

        if (count !== 4'h8) begin
            $display("Test 4 Failed : Counter changed while disabled");
            test_passed = 1'b0;
        end
        else
            $display("Test 4 Passed");

        // =================================================
        // Test Case 5 : Reset During Operation
        // =================================================

        enable  = 1;
        up_down = 1;

        #20;

        rst_n = 0;

        #5;

        if (count !== 4'h0) begin
            $display("Test 5 Failed : Reset during operation");
            test_passed = 1'b0;
        end
        else
            $display("Test 5 Passed");

        rst_n = 1;

        // =================================================
        // Test Case 6 : Load While Counting
        // =================================================

        enable = 1;

        d_in = 4'hD;
        load = 1;

        #10;

        load = 0;

        if (count !== 4'hD) begin
            $display("Test 6 Failed : Load while counting");
            test_passed = 1'b0;
        end
        else
            $display("Test 6 Passed");

        // =================================================
        // Test Case 7 : Disable While Counting
        // =================================================

        enable  = 1;
        up_down = 1;

        #20;

        enable = 0;

        #20;

        if (count !== 4'hF) begin
            $display("Test 7 Failed : Disable while counting");
            test_passed = 1'b0;
        end
        else
            $display("Test 7 Passed");

        // =================================================
        // Final Result
        // =================================================

        if (test_passed)
            $display("All tests passed!");
        else
            $display("Some tests failed.");

        $finish(0);

    end

endmodule
