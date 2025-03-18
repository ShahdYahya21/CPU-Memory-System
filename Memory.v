module Memory (
  input wire clock,
  input wire [10:0] address,
  input wire [15:0] dataIn,
  input wire read,
  input wire write,
  output reg [15:0] dataOut
  
);
  reg [15:0] memoryArray[0:63];

  initial begin 
    memoryArray[0] = 16'h180A;//0001 1000 0000 1010
    memoryArray[1] = 16'h580B;//0101 1000 0000 1011
    memoryArray[2] = 16'h3005;//0011 0000 0000 0101
    memoryArray[3] = 16'h280C;//0010 1000 0000 1100
	memoryArray[4] = 16'h180C;

	
    memoryArray[10] = 16'b0000000000001001;
    memoryArray[11] = 16'b1111111111110100;
    memoryArray[12] = 16'b0000000000000000;
    memoryArray[13] = 16'b0111111111111111;
  end

  always @(posedge clock) begin
    if (read)
      dataOut <= memoryArray[address];
    else if (write)
      memoryArray[address] <= dataIn;
  end
endmodule
