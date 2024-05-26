module SHA_256 #(
    parameter WIDTH = 32,
    parameter Message_Array_Size = 64
)
(
    input [511:0] input_message,
    output reg [255:0] output_message
);
  
  reg [WIDTH-1:0] K [Message_Array_Size-1:0]; 
  reg [WIDTH-1:0] W [Message_Array_Size-1:0]; 
  
  
  reg [WIDTH-1:0] H [7:0];
  reg [WIDTH-1:0] H_initial [7:0];
  
  reg [WIDTH-1:0] T1;
  reg [WIDTH-1:0] T2;
  
  integer i;
  integer k;
  
  
  initial begin
    T1 = 32'b0;
    T2 = 32'b0;
    
    for (i = 0; i < 64; i = i+1) begin
      W[i] = 32'b0;
    end
    
    K[ 0] = 32'h428a2f98; K[ 1] = 32'h71374491; K[ 2] = 32'hb5c0fbcf; K[ 3] = 32'he9b5dba5;
    K[ 4] = 32'h3956c25b; K[ 5] = 32'h59f111f1; K[ 6] = 32'h923f82a4; K[ 7] = 32'hab1c5ed5;
    K[ 8] = 32'hd807aa98; K[ 9] = 32'h12835b01; K[10] = 32'h243185be; K[11] = 32'h550c7dc3;
    K[12] = 32'h72be5d74; K[13] = 32'h80deb1fe; K[14] = 32'h9bdc06a7; K[15] = 32'hc19bf174;
    K[16] = 32'he49b69c1; K[17] = 32'hefbe4786; K[18] = 32'h0fc19dc6; K[19] = 32'h240ca1cc;
    K[20] = 32'h2de92c6f; K[21] = 32'h4a7484aa; K[22] = 32'h5cb0a9dc; K[23] = 32'h76f988da;
    K[24] = 32'h983e5152; K[25] = 32'ha831c66d; K[26] = 32'hb00327c8; K[27] = 32'hbf597fc7;
    K[28] = 32'hc6e00bf3; K[29] = 32'hd5a79147; K[30] = 32'h06ca6351; K[31] = 32'h14292967;
    K[32] = 32'h27b70a85; K[33] = 32'h2e1b2138; K[34] = 32'h4d2c6dfc; K[35] = 32'h53380d13;
    K[36] = 32'h650a7354; K[37] = 32'h766a0abb; K[38] = 32'h81c2c92e; K[39] = 32'h92722c85;
    K[40] = 32'ha2bfe8a1; K[41] = 32'ha81a664b; K[42] = 32'hc24b8b70; K[43] = 32'hc76c51a3;
    K[44] = 32'hd192e819; K[45] = 32'hd6990624; K[46] = 32'hf40e3585; K[47] = 32'h106aa070;
    K[48] = 32'h19a4c116; K[49] = 32'h1e376c08; K[50] = 32'h2748774c; K[51] = 32'h34b0bcb5;
    K[52] = 32'h391c0cb3; K[53] = 32'h4ed8aa4a; K[54] = 32'h5b9cca4f; K[55] = 32'h682e6ff3;
    K[56] = 32'h748f82ee; K[57] = 32'h78a5636f; K[58] = 32'h84c87814; K[59] = 32'h8cc70208;
    K[60] = 32'h90befffa; K[61] = 32'ha4506ceb; K[62] = 32'hbef9a3f7; K[63] = 32'hc67178f2;

    H[0] = 32'h6a09e667; H[1] = 32'hbb67ae85; H[2] = 32'h3c6ef372; H[3] = 32'ha54ff53a;
    H[4] = 32'h510e527f; H[5] = 32'h9b05688c; H[6] = 32'h1f83d9ab; H[7] = 32'h5be0cd19;
    
    H_initial[0] = H[0]; H_initial[1] = H[1]; H_initial[2] = H[2]; H_initial[3] = H[3];
    H_initial[4] = H[4]; H_initial[5] = H[5]; H_initial[6] = H[6]; H_initial[7] = H[7];
    
  end
  
  always @(input_message) begin
    W[15]  = input_message[31:0];
    W[14]  = input_message[63:32];
    W[13]  = input_message[95:64];
    W[12]  = input_message[127:96];
    W[11]  = input_message[159:128];
    W[10]  = input_message[191:160];
    W[9]  = input_message[223:192];
    W[8]  = input_message[255:224];
    W[7]  = input_message[287:256];
    W[6]  = input_message[319:288];
    W[5] = input_message[351:320];
    W[4] = input_message[383:352];
    W[3] = input_message[415:384];
    W[2] = input_message[447:416];
    W[1] = input_message[479:448];
    W[0] = input_message[511:480];
    
    for (i=16;i<64;i=i+1) begin
      W[i] = sigma1(W[i-2])+W[i-7]+sigma0(W[i-15])+W[i-16];
    end
    
    for (i=0;i<64;i=i+1) begin
      T1 = sum1(H[4])+ choice(H[4], H[5], H[6]) + H[7] + K[i] + W[i];
      T2 = sum0(H[0]) + majority(H[0],H[1],H[2]);
      H[7] = H[6];
      H[6] = H[5];
      H[5] = H[4];
      H[4] = H[3] + T1;
      H[3] = H[2];
      H[2] = H[1];
      H[1] = H[0];
      H[0] = T1 + T2;
    end
    
    H[0] = H[0] + H_initial[0]; 
    H[1] = H[1] + H_initial[1]; 
    H[2] = H[2] + H_initial[2]; 
    H[3] = H[3] + H_initial[3];
    H[4] = H[4] + H_initial[4]; 
    H[5] = H[5] + H_initial[5]; 
    H[6] = H[6] + H_initial[6]; 
    H[7] = H[7] + H_initial[7];

    output_message = {H[0],H[1],H[2],H[3],H[4],H[5],H[6],H[7]};
  end
  
  
  function [WIDTH:0] choice;
      input [WIDTH:0] select;
      input [WIDTH:0] reg2;
      input [WIDTH:0] reg3;
      begin
        choice = (select & reg2) | (~select & reg3);
      end
  endfunction
  
  function [WIDTH:0] majority;
    input [WIDTH:0] reg1;
    input [WIDTH:0] reg2;
    input [WIDTH:0] reg3;
    begin
      majority = (reg1 & reg2) | (reg1 & reg3) | (reg2 & reg3);
    end
  endfunction
  
  
  function [WIDTH:0] rotate_right;
    input [WIDTH:0] reg1;
    input [32:0] num_rotate;
    begin
    rotate_right = (reg1 >> num_rotate) | (reg1 << WIDTH-num_rotate);
    end
  endfunction
  
  function [WIDTH:0] shift_right;
    input [WIDTH:0] reg1;
    input [32:0] num_shift;
    begin
    shift_right = (reg1 >> num_shift);
    end
  endfunction
  
  function [WIDTH:0] sigma1;
    input [WIDTH:0] reg1;
    begin
      sigma1 = rotate_right(reg1,17) ^ rotate_right(reg1,19) ^ shift_right(reg1,10);
    end
	endfunction
  
	function [WIDTH:0] sigma0;
    input [WIDTH:0] reg1;
    begin
      sigma0 = rotate_right(reg1,7) ^ rotate_right(reg1,18) ^ shift_right(reg1,3);
    end
  endfunction
	
	function [WIDTH:0] sum1;
    input [WIDTH:0] reg1;
    begin
      sum1 = rotate_right(reg1,6) ^ rotate_right(reg1,11) ^ rotate_right(reg1,25);
    end
  endfunction
	
  function [WIDTH:0] sum0;
    input [WIDTH:0] reg1;
    begin
      sum0 = rotate_right(reg1,2) ^ rotate_right(reg1,13) ^ rotate_right(reg1,22);
    end
  endfunction
  
endmodule