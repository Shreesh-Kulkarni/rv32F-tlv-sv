\m5_TLV_version 1d: tl-x.org
\m5
   
   // =================================================
   // Welcome!  New to Makerchip? Try the "Learn" menu.
   // =================================================
   
   use(m5-1.0)   /// uncomment to use M5 macro library.
\SV
   // Macro providing required top-level module definition, random
   // stimulus support, and Verilator config.
   m5_makerchip_module   // (Expanded in Nav-TLV pane.)
\TLV f_ext_instr()
   |pipe
      @1
         $instr[31:0] = $rand[31:0];
         $is_load = {$instr[14:12],$instr[6:3]} ==? 7'b0100000;
         $is_store = {$instr[14:12],$instr[6:3]} ==? 7'b0100100;
         $is_computational = $instr[6:2] ==? 5'b10100;
         $is_fused = $instr[6:2] ==? 5'b1000x ||
                     $instr[6:2] ==? 5'b1001x;
         $rs1_valid = $is_load || $is_computational || $is_fused;
         ?$rs1_valid
            $rs1[4:0] = $instr[19:15];
         $rs2_valid = $is_store || $is_computational || $is_fused;
         ?$rs2_valid
            $rs2[4:0] = $instr[24:20];
\TLV
   $reset = *reset;
   m5+f_ext_instr()
   
   //...
   
   // Assert these to end simulation (before Makerchip cycle limit).
   *passed = *cyc_cnt > 40;
   *failed = 1'b0;
\SV
   endmodule
