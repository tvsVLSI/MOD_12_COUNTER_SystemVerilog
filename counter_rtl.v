module counter_rtl(clock,
                   reset,
                   load,
                   data_in,
                   upd,
                   count);

           input clock;
           input reset;
           input load;
           input [3:0]data_in;
           input upd;
           output reg [3:0] count;

           always @(posedge clock)
           begin
                   if(reset)
                           count <= 4'b0;

                   else if(load)
                           count <= data_in;

                   else if(upd)
                   begin
                           if(count == 4'd11)
                                  count <= 4'b0;
                          else
                                  count <= count + 1'b1;
                   end

                   else
                   begin
                           if(count == 4'b0)
                                   count <= 4'd11;
                           else
                                   count <= count - 1'b1;
                   end
            end
endmodule: counter_rtl

