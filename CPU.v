module CPU (
input clock,
input [15:0] memoryData,
output reg memoryRead, memoryWrite,
output reg [10:0] PC, MAR,
output reg [15:0] IR, MBR, AC,
output reg Z, OF, C, N,
output reg mode,
output reg [3:0] state
);
reg [15:0] tempRegForMul, tempRegForDiv;
reg [10:0] tempRegForConstant;


parameter load = 4'b0001, store = 4'b0010, ADD = 4'b0011, Sub = 4'b0100, Mul = 4'b0101, Div = 4'b0110, Branch = 4'b0111, BRZ = 4'b1000;

initial begin 

PC = 0;
state = 0;
end


always @(posedge clock) begin 
	memoryRead <= 0;
	memoryWrite <= 0;
	case(state) 
		0: begin 
			MAR <= PC;
			memoryRead <= 1;
			state <= 1;
		end
	  
		1: begin
			memoryRead <= 0;
			state <= 2;
		end

		2: begin
			MBR <= memoryData;
			state <= 3;
		end
		
		3: begin
			IR <= MBR;
			state <= 4;
		end

		4: begin 
			mode <= IR[11];
			PC <= PC + 1;
			state <= 5;
		end

		5: begin
			if (mode == 1) begin
				 MAR <= IR[10:0];
				 memoryRead <= 1;
			end 
			else begin
				tempRegForConstant <= IR[10:0]; 
			end
			state <= 6;
		end 

		6: begin
			memoryRead <= 0;
			state <= 7;
		end
		
		7: begin
			MBR <= memoryData;
			state <= 8;
		end

		8: begin 
			if (IR[15:12] == load) begin
				if (mode == 1) begin 
					AC <= MBR;
				end
				if (mode == 0) begin 
					AC <=  tempRegForConstant;
				end
			end
			
			else if (IR[15:12] == store) begin
				memoryWrite <= 1;
				MBR <= AC;
			end
			
			else if (IR[15:12] == ADD) begin 
				if (mode == 1) begin
					{C,AC} <= AC + MBR;
				end
				if (mode == 0) begin
					{C,AC} <= AC +  tempRegForConstant;
				end
			end
			
			else if (IR[15:12] == Sub) begin 
				if (mode == 1) begin
					{C,AC} <= AC - MBR;
				end
				if (mode == 0) begin
					{C,AC} <= AC -  tempRegForConstant;
				end
			end
			
			else if (IR[15:12] == Mul) begin 
				if (mode == 1) begin
					{tempRegForMul,AC} <= AC * MBR;
				end
				if (mode == 0) begin
					{tempRegForMul,AC} <= AC * tempRegForConstant;
				end
			end

			else if (IR[15:12] == Div) begin
				if (mode == 1) begin
					if(MBR != 0) begin
						{tempRegForDiv,AC} <= AC / MBR;
					end
				end
				if (mode == 0) begin
					if(tempRegForConstant != 0) begin
						{tempRegForDiv,AC} <= AC / tempRegForConstant;
					end
				end
			end
			
			else if (IR[15:12] == Branch) begin
				PC <= IR[10:0];
			end
		 
			else if (IR[15:12] == BRZ) begin
				if(Z == 1) begin
					PC <= IR[10:0];
				end
			end
			
			state <= 9;
		end
			
		9: begin
			Z <= (AC == 0);
			N <= (AC[15] == 1);
			if(IR[15:12] == ADD || IR[15:12] == Sub) begin
				OF <= (C != AC[15]);
			end
			
			if(IR[15:12] == Mul) begin
				OF <= (tempRegForMul != 0 || AC == 16'hFFFF) && (tempRegForMul != 16'hFFFF || AC == 0);
			end
			
			state <=0;
		end
		
	endcase  
end
endmodule