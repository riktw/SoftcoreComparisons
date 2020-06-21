// Generator : SpinalHDL v1.4.0    git head : ecb5a80b713566f417ea3ea061f9969e73770a7f
// Date      : 10/06/2020, 22:19:55
// Component : MyTopLevel


`define UartStopType_defaultEncoding_type [0:0]
`define UartStopType_defaultEncoding_ONE 1'b0
`define UartStopType_defaultEncoding_TWO 1'b1

`define UartParityType_defaultEncoding_type [1:0]
`define UartParityType_defaultEncoding_NONE 2'b00
`define UartParityType_defaultEncoding_EVEN 2'b01
`define UartParityType_defaultEncoding_ODD 2'b10

`define UartCtrlTxState_defaultEncoding_type [2:0]
`define UartCtrlTxState_defaultEncoding_IDLE 3'b000
`define UartCtrlTxState_defaultEncoding_START 3'b001
`define UartCtrlTxState_defaultEncoding_DATA 3'b010
`define UartCtrlTxState_defaultEncoding_PARITY 3'b011
`define UartCtrlTxState_defaultEncoding_STOP 3'b100

`define UartCtrlRxState_defaultEncoding_type [2:0]
`define UartCtrlRxState_defaultEncoding_IDLE 3'b000
`define UartCtrlRxState_defaultEncoding_START 3'b001
`define UartCtrlRxState_defaultEncoding_DATA 3'b010
`define UartCtrlRxState_defaultEncoding_PARITY 3'b011
`define UartCtrlRxState_defaultEncoding_STOP 3'b100


module BufferCC (
  input               io_initial,
  input               io_dataIn,
  output              io_dataOut,
  input               clk,
  input               reset 
);
  reg                 buffers_0;
  reg                 buffers_1;

  assign io_dataOut = buffers_1;
  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      buffers_0 <= io_initial;
      buffers_1 <= io_initial;
    end else begin
      buffers_0 <= io_dataIn;
      buffers_1 <= buffers_0;
    end
  end


endmodule

module UartCtrlTx (
  input      [2:0]    io_configFrame_dataLength,
  input      `UartStopType_defaultEncoding_type io_configFrame_stop,
  input      `UartParityType_defaultEncoding_type io_configFrame_parity,
  input               io_samplingTick,
  input               io_write_valid,
  output reg          io_write_ready,
  input      [7:0]    io_write_payload,
  input               io_cts,
  output              io_txd,
  input               io_break,
  input               clk,
  input               reset 
);
  wire                _zz_2_;
  wire       [0:0]    _zz_3_;
  wire       [2:0]    _zz_4_;
  wire       [0:0]    _zz_5_;
  wire       [2:0]    _zz_6_;
  reg                 clockDivider_counter_willIncrement;
  wire                clockDivider_counter_willClear;
  reg        [2:0]    clockDivider_counter_valueNext;
  reg        [2:0]    clockDivider_counter_value;
  wire                clockDivider_counter_willOverflowIfInc;
  wire                clockDivider_counter_willOverflow;
  reg        [2:0]    tickCounter_value;
  reg        `UartCtrlTxState_defaultEncoding_type stateMachine_state;
  reg                 stateMachine_parity;
  reg                 stateMachine_txd;
  reg                 _zz_1_;
  `ifndef SYNTHESIS
  reg [23:0] io_configFrame_stop_string;
  reg [31:0] io_configFrame_parity_string;
  reg [47:0] stateMachine_state_string;
  `endif


  assign _zz_2_ = (tickCounter_value == io_configFrame_dataLength);
  assign _zz_3_ = clockDivider_counter_willIncrement;
  assign _zz_4_ = {2'd0, _zz_3_};
  assign _zz_5_ = ((io_configFrame_stop == `UartStopType_defaultEncoding_ONE) ? (1'b0) : (1'b1));
  assign _zz_6_ = {2'd0, _zz_5_};
  `ifndef SYNTHESIS
  always @(*) begin
    case(io_configFrame_stop)
      `UartStopType_defaultEncoding_ONE : io_configFrame_stop_string = "ONE";
      `UartStopType_defaultEncoding_TWO : io_configFrame_stop_string = "TWO";
      default : io_configFrame_stop_string = "???";
    endcase
  end
  always @(*) begin
    case(io_configFrame_parity)
      `UartParityType_defaultEncoding_NONE : io_configFrame_parity_string = "NONE";
      `UartParityType_defaultEncoding_EVEN : io_configFrame_parity_string = "EVEN";
      `UartParityType_defaultEncoding_ODD : io_configFrame_parity_string = "ODD ";
      default : io_configFrame_parity_string = "????";
    endcase
  end
  always @(*) begin
    case(stateMachine_state)
      `UartCtrlTxState_defaultEncoding_IDLE : stateMachine_state_string = "IDLE  ";
      `UartCtrlTxState_defaultEncoding_START : stateMachine_state_string = "START ";
      `UartCtrlTxState_defaultEncoding_DATA : stateMachine_state_string = "DATA  ";
      `UartCtrlTxState_defaultEncoding_PARITY : stateMachine_state_string = "PARITY";
      `UartCtrlTxState_defaultEncoding_STOP : stateMachine_state_string = "STOP  ";
      default : stateMachine_state_string = "??????";
    endcase
  end
  `endif

  always @ (*) begin
    clockDivider_counter_willIncrement = 1'b0;
    if(io_samplingTick)begin
      clockDivider_counter_willIncrement = 1'b1;
    end
  end

  assign clockDivider_counter_willClear = 1'b0;
  assign clockDivider_counter_willOverflowIfInc = (clockDivider_counter_value == (3'b111));
  assign clockDivider_counter_willOverflow = (clockDivider_counter_willOverflowIfInc && clockDivider_counter_willIncrement);
  always @ (*) begin
    clockDivider_counter_valueNext = (clockDivider_counter_value + _zz_4_);
    if(clockDivider_counter_willClear)begin
      clockDivider_counter_valueNext = (3'b000);
    end
  end

  always @ (*) begin
    stateMachine_txd = 1'b1;
    case(stateMachine_state)
      `UartCtrlTxState_defaultEncoding_IDLE : begin
      end
      `UartCtrlTxState_defaultEncoding_START : begin
        stateMachine_txd = 1'b0;
      end
      `UartCtrlTxState_defaultEncoding_DATA : begin
        stateMachine_txd = io_write_payload[tickCounter_value];
      end
      `UartCtrlTxState_defaultEncoding_PARITY : begin
        stateMachine_txd = stateMachine_parity;
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    io_write_ready = io_break;
    case(stateMachine_state)
      `UartCtrlTxState_defaultEncoding_IDLE : begin
      end
      `UartCtrlTxState_defaultEncoding_START : begin
      end
      `UartCtrlTxState_defaultEncoding_DATA : begin
        if(clockDivider_counter_willOverflow)begin
          if(_zz_2_)begin
            io_write_ready = 1'b1;
          end
        end
      end
      `UartCtrlTxState_defaultEncoding_PARITY : begin
      end
      default : begin
      end
    endcase
  end

  assign io_txd = _zz_1_;
  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      clockDivider_counter_value <= (3'b000);
      stateMachine_state <= `UartCtrlTxState_defaultEncoding_IDLE;
      _zz_1_ <= 1'b1;
    end else begin
      clockDivider_counter_value <= clockDivider_counter_valueNext;
      case(stateMachine_state)
        `UartCtrlTxState_defaultEncoding_IDLE : begin
          if(((io_write_valid && (! io_cts)) && clockDivider_counter_willOverflow))begin
            stateMachine_state <= `UartCtrlTxState_defaultEncoding_START;
          end
        end
        `UartCtrlTxState_defaultEncoding_START : begin
          if(clockDivider_counter_willOverflow)begin
            stateMachine_state <= `UartCtrlTxState_defaultEncoding_DATA;
          end
        end
        `UartCtrlTxState_defaultEncoding_DATA : begin
          if(clockDivider_counter_willOverflow)begin
            if(_zz_2_)begin
              if((io_configFrame_parity == `UartParityType_defaultEncoding_NONE))begin
                stateMachine_state <= `UartCtrlTxState_defaultEncoding_STOP;
              end else begin
                stateMachine_state <= `UartCtrlTxState_defaultEncoding_PARITY;
              end
            end
          end
        end
        `UartCtrlTxState_defaultEncoding_PARITY : begin
          if(clockDivider_counter_willOverflow)begin
            stateMachine_state <= `UartCtrlTxState_defaultEncoding_STOP;
          end
        end
        default : begin
          if(clockDivider_counter_willOverflow)begin
            if((tickCounter_value == _zz_6_))begin
              stateMachine_state <= (io_write_valid ? `UartCtrlTxState_defaultEncoding_START : `UartCtrlTxState_defaultEncoding_IDLE);
            end
          end
        end
      endcase
      _zz_1_ <= (stateMachine_txd && (! io_break));
    end
  end

  always @ (posedge clk) begin
    if(clockDivider_counter_willOverflow)begin
      tickCounter_value <= (tickCounter_value + (3'b001));
    end
    if(clockDivider_counter_willOverflow)begin
      stateMachine_parity <= (stateMachine_parity ^ stateMachine_txd);
    end
    case(stateMachine_state)
      `UartCtrlTxState_defaultEncoding_IDLE : begin
      end
      `UartCtrlTxState_defaultEncoding_START : begin
        if(clockDivider_counter_willOverflow)begin
          stateMachine_parity <= (io_configFrame_parity == `UartParityType_defaultEncoding_ODD);
          tickCounter_value <= (3'b000);
        end
      end
      `UartCtrlTxState_defaultEncoding_DATA : begin
        if(clockDivider_counter_willOverflow)begin
          if(_zz_2_)begin
            tickCounter_value <= (3'b000);
          end
        end
      end
      `UartCtrlTxState_defaultEncoding_PARITY : begin
        if(clockDivider_counter_willOverflow)begin
          tickCounter_value <= (3'b000);
        end
      end
      default : begin
      end
    endcase
  end


endmodule

module UartCtrlRx (
  input      [2:0]    io_configFrame_dataLength,
  input      `UartStopType_defaultEncoding_type io_configFrame_stop,
  input      `UartParityType_defaultEncoding_type io_configFrame_parity,
  input               io_samplingTick,
  output              io_read_valid,
  input               io_read_ready,
  output     [7:0]    io_read_payload,
  input               io_rxd,
  output              io_rts,
  output reg          io_error,
  output              io_break,
  input               clk,
  input               reset 
);
  wire                _zz_2_;
  wire                io_rxd_buffercc_io_dataOut;
  wire                _zz_3_;
  wire                _zz_4_;
  wire                _zz_5_;
  wire                _zz_6_;
  wire       [0:0]    _zz_7_;
  wire       [2:0]    _zz_8_;
  wire                _zz_9_;
  wire                _zz_10_;
  wire                _zz_11_;
  wire                _zz_12_;
  wire                _zz_13_;
  wire                _zz_14_;
  wire                _zz_15_;
  reg                 _zz_1_;
  wire                sampler_synchroniser;
  wire                sampler_samples_0;
  reg                 sampler_samples_1;
  reg                 sampler_samples_2;
  reg                 sampler_samples_3;
  reg                 sampler_samples_4;
  reg                 sampler_value;
  reg                 sampler_tick;
  reg        [2:0]    bitTimer_counter;
  reg                 bitTimer_tick;
  reg        [2:0]    bitCounter_value;
  reg        [6:0]    break_counter;
  wire                break_valid;
  reg        `UartCtrlRxState_defaultEncoding_type stateMachine_state;
  reg                 stateMachine_parity;
  reg        [7:0]    stateMachine_shifter;
  reg                 stateMachine_validReg;
  `ifndef SYNTHESIS
  reg [23:0] io_configFrame_stop_string;
  reg [31:0] io_configFrame_parity_string;
  reg [47:0] stateMachine_state_string;
  `endif


  assign _zz_3_ = (stateMachine_parity == sampler_value);
  assign _zz_4_ = (! sampler_value);
  assign _zz_5_ = ((sampler_tick && (! sampler_value)) && (! break_valid));
  assign _zz_6_ = (bitCounter_value == io_configFrame_dataLength);
  assign _zz_7_ = ((io_configFrame_stop == `UartStopType_defaultEncoding_ONE) ? (1'b0) : (1'b1));
  assign _zz_8_ = {2'd0, _zz_7_};
  assign _zz_9_ = ((((1'b0 || ((_zz_14_ && sampler_samples_1) && sampler_samples_2)) || (((_zz_15_ && sampler_samples_0) && sampler_samples_1) && sampler_samples_3)) || (((1'b1 && sampler_samples_0) && sampler_samples_2) && sampler_samples_3)) || (((1'b1 && sampler_samples_1) && sampler_samples_2) && sampler_samples_3));
  assign _zz_10_ = (((1'b1 && sampler_samples_0) && sampler_samples_1) && sampler_samples_4);
  assign _zz_11_ = ((1'b1 && sampler_samples_0) && sampler_samples_2);
  assign _zz_12_ = (1'b1 && sampler_samples_1);
  assign _zz_13_ = 1'b1;
  assign _zz_14_ = (1'b1 && sampler_samples_0);
  assign _zz_15_ = 1'b1;
  BufferCC io_rxd_buffercc ( 
    .io_initial    (_zz_2_                      ), //i
    .io_dataIn     (io_rxd                      ), //i
    .io_dataOut    (io_rxd_buffercc_io_dataOut  ), //o
    .clk           (clk                         ), //i
    .reset         (reset                       )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(io_configFrame_stop)
      `UartStopType_defaultEncoding_ONE : io_configFrame_stop_string = "ONE";
      `UartStopType_defaultEncoding_TWO : io_configFrame_stop_string = "TWO";
      default : io_configFrame_stop_string = "???";
    endcase
  end
  always @(*) begin
    case(io_configFrame_parity)
      `UartParityType_defaultEncoding_NONE : io_configFrame_parity_string = "NONE";
      `UartParityType_defaultEncoding_EVEN : io_configFrame_parity_string = "EVEN";
      `UartParityType_defaultEncoding_ODD : io_configFrame_parity_string = "ODD ";
      default : io_configFrame_parity_string = "????";
    endcase
  end
  always @(*) begin
    case(stateMachine_state)
      `UartCtrlRxState_defaultEncoding_IDLE : stateMachine_state_string = "IDLE  ";
      `UartCtrlRxState_defaultEncoding_START : stateMachine_state_string = "START ";
      `UartCtrlRxState_defaultEncoding_DATA : stateMachine_state_string = "DATA  ";
      `UartCtrlRxState_defaultEncoding_PARITY : stateMachine_state_string = "PARITY";
      `UartCtrlRxState_defaultEncoding_STOP : stateMachine_state_string = "STOP  ";
      default : stateMachine_state_string = "??????";
    endcase
  end
  `endif

  always @ (*) begin
    io_error = 1'b0;
    case(stateMachine_state)
      `UartCtrlRxState_defaultEncoding_IDLE : begin
      end
      `UartCtrlRxState_defaultEncoding_START : begin
      end
      `UartCtrlRxState_defaultEncoding_DATA : begin
      end
      `UartCtrlRxState_defaultEncoding_PARITY : begin
        if(bitTimer_tick)begin
          if(! _zz_3_) begin
            io_error = 1'b1;
          end
        end
      end
      default : begin
        if(bitTimer_tick)begin
          if(_zz_4_)begin
            io_error = 1'b1;
          end
        end
      end
    endcase
  end

  assign io_rts = _zz_1_;
  assign _zz_2_ = 1'b0;
  assign sampler_synchroniser = io_rxd_buffercc_io_dataOut;
  assign sampler_samples_0 = sampler_synchroniser;
  always @ (*) begin
    bitTimer_tick = 1'b0;
    if(sampler_tick)begin
      if((bitTimer_counter == (3'b000)))begin
        bitTimer_tick = 1'b1;
      end
    end
  end

  assign break_valid = (break_counter == 7'h68);
  assign io_break = break_valid;
  assign io_read_valid = stateMachine_validReg;
  assign io_read_payload = stateMachine_shifter;
  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      _zz_1_ <= 1'b0;
      sampler_samples_1 <= 1'b1;
      sampler_samples_2 <= 1'b1;
      sampler_samples_3 <= 1'b1;
      sampler_samples_4 <= 1'b1;
      sampler_value <= 1'b1;
      sampler_tick <= 1'b0;
      break_counter <= 7'h0;
      stateMachine_state <= `UartCtrlRxState_defaultEncoding_IDLE;
      stateMachine_validReg <= 1'b0;
    end else begin
      _zz_1_ <= (! io_read_ready);
      if(io_samplingTick)begin
        sampler_samples_1 <= sampler_samples_0;
      end
      if(io_samplingTick)begin
        sampler_samples_2 <= sampler_samples_1;
      end
      if(io_samplingTick)begin
        sampler_samples_3 <= sampler_samples_2;
      end
      if(io_samplingTick)begin
        sampler_samples_4 <= sampler_samples_3;
      end
      sampler_value <= ((((((_zz_9_ || _zz_10_) || (_zz_11_ && sampler_samples_4)) || ((_zz_12_ && sampler_samples_2) && sampler_samples_4)) || (((_zz_13_ && sampler_samples_0) && sampler_samples_3) && sampler_samples_4)) || (((1'b1 && sampler_samples_1) && sampler_samples_3) && sampler_samples_4)) || (((1'b1 && sampler_samples_2) && sampler_samples_3) && sampler_samples_4));
      sampler_tick <= io_samplingTick;
      if(sampler_value)begin
        break_counter <= 7'h0;
      end else begin
        if((io_samplingTick && (! break_valid)))begin
          break_counter <= (break_counter + 7'h01);
        end
      end
      stateMachine_validReg <= 1'b0;
      case(stateMachine_state)
        `UartCtrlRxState_defaultEncoding_IDLE : begin
          if(_zz_5_)begin
            stateMachine_state <= `UartCtrlRxState_defaultEncoding_START;
          end
        end
        `UartCtrlRxState_defaultEncoding_START : begin
          if(bitTimer_tick)begin
            stateMachine_state <= `UartCtrlRxState_defaultEncoding_DATA;
            if((sampler_value == 1'b1))begin
              stateMachine_state <= `UartCtrlRxState_defaultEncoding_IDLE;
            end
          end
        end
        `UartCtrlRxState_defaultEncoding_DATA : begin
          if(bitTimer_tick)begin
            if(_zz_6_)begin
              if((io_configFrame_parity == `UartParityType_defaultEncoding_NONE))begin
                stateMachine_state <= `UartCtrlRxState_defaultEncoding_STOP;
                stateMachine_validReg <= 1'b1;
              end else begin
                stateMachine_state <= `UartCtrlRxState_defaultEncoding_PARITY;
              end
            end
          end
        end
        `UartCtrlRxState_defaultEncoding_PARITY : begin
          if(bitTimer_tick)begin
            if(_zz_3_)begin
              stateMachine_state <= `UartCtrlRxState_defaultEncoding_STOP;
              stateMachine_validReg <= 1'b1;
            end else begin
              stateMachine_state <= `UartCtrlRxState_defaultEncoding_IDLE;
            end
          end
        end
        default : begin
          if(bitTimer_tick)begin
            if(_zz_4_)begin
              stateMachine_state <= `UartCtrlRxState_defaultEncoding_IDLE;
            end else begin
              if((bitCounter_value == _zz_8_))begin
                stateMachine_state <= `UartCtrlRxState_defaultEncoding_IDLE;
              end
            end
          end
        end
      endcase
    end
  end

  always @ (posedge clk) begin
    if(sampler_tick)begin
      bitTimer_counter <= (bitTimer_counter - (3'b001));
    end
    if(bitTimer_tick)begin
      bitCounter_value <= (bitCounter_value + (3'b001));
    end
    if(bitTimer_tick)begin
      stateMachine_parity <= (stateMachine_parity ^ sampler_value);
    end
    case(stateMachine_state)
      `UartCtrlRxState_defaultEncoding_IDLE : begin
        if(_zz_5_)begin
          bitTimer_counter <= (3'b010);
        end
      end
      `UartCtrlRxState_defaultEncoding_START : begin
        if(bitTimer_tick)begin
          bitCounter_value <= (3'b000);
          stateMachine_parity <= (io_configFrame_parity == `UartParityType_defaultEncoding_ODD);
        end
      end
      `UartCtrlRxState_defaultEncoding_DATA : begin
        if(bitTimer_tick)begin
          stateMachine_shifter[bitCounter_value] <= sampler_value;
          if(_zz_6_)begin
            bitCounter_value <= (3'b000);
          end
        end
      end
      `UartCtrlRxState_defaultEncoding_PARITY : begin
        if(bitTimer_tick)begin
          bitCounter_value <= (3'b000);
        end
      end
      default : begin
      end
    endcase
  end


endmodule

module Timer (
  input               io_tick,
  input               io_clear,
  input      [15:0]   io_limit,
  input      [15:0]   io_divider,
  output              io_full,
  output     [15:0]   io_value,
  input               clk,
  input               reset 
);
  reg        [15:0]   counter;
  reg        [15:0]   divider;

  assign io_full = ((counter == io_limit) && io_tick);
  assign io_value = counter;
  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      counter <= 16'h0;
      divider <= 16'h0;
    end else begin
      if((io_tick && (! io_full)))begin
        divider <= (divider + 16'h0001);
        if((io_divider <= divider))begin
          counter <= (counter + 16'h0001);
          divider <= 16'h0;
        end
      end
      if(io_clear)begin
        counter <= 16'h0;
        divider <= 16'h0;
      end
    end
  end


endmodule

module UartCtrl (
  input      [2:0]    io_config_frame_dataLength,
  input      `UartStopType_defaultEncoding_type io_config_frame_stop,
  input      `UartParityType_defaultEncoding_type io_config_frame_parity,
  input      [15:0]   io_config_clockDivider,
  input               io_write_valid,
  output reg          io_write_ready,
  input      [7:0]    io_write_payload,
  output              io_read_valid,
  input               io_read_ready,
  output     [7:0]    io_read_payload,
  output              io_uart_txd,
  input               io_uart_rxd,
  output              io_readError,
  input               io_writeBreak,
  output              io_readBreak,
  input               clk,
  input               reset 
);
  wire                _zz_1_;
  wire                tx_io_write_ready;
  wire                tx_io_txd;
  wire                rx_io_read_valid;
  wire       [7:0]    rx_io_read_payload;
  wire                rx_io_rts;
  wire                rx_io_error;
  wire                rx_io_break;
  reg        [15:0]   clockDivider_counter;
  wire                clockDivider_tick;
  reg                 io_write_thrown_valid;
  wire                io_write_thrown_ready;
  wire       [7:0]    io_write_thrown_payload;
  `ifndef SYNTHESIS
  reg [23:0] io_config_frame_stop_string;
  reg [31:0] io_config_frame_parity_string;
  `endif


  UartCtrlTx tx ( 
    .io_configFrame_dataLength    (io_config_frame_dataLength[2:0]  ), //i
    .io_configFrame_stop          (io_config_frame_stop             ), //i
    .io_configFrame_parity        (io_config_frame_parity[1:0]      ), //i
    .io_samplingTick              (clockDivider_tick                ), //i
    .io_write_valid               (io_write_thrown_valid            ), //i
    .io_write_ready               (tx_io_write_ready                ), //o
    .io_write_payload             (io_write_thrown_payload[7:0]     ), //i
    .io_cts                       (_zz_1_                           ), //i
    .io_txd                       (tx_io_txd                        ), //o
    .io_break                     (io_writeBreak                    ), //i
    .clk                          (clk                              ), //i
    .reset                        (reset                            )  //i
  );
  UartCtrlRx rx ( 
    .io_configFrame_dataLength    (io_config_frame_dataLength[2:0]  ), //i
    .io_configFrame_stop          (io_config_frame_stop             ), //i
    .io_configFrame_parity        (io_config_frame_parity[1:0]      ), //i
    .io_samplingTick              (clockDivider_tick                ), //i
    .io_read_valid                (rx_io_read_valid                 ), //o
    .io_read_ready                (io_read_ready                    ), //i
    .io_read_payload              (rx_io_read_payload[7:0]          ), //o
    .io_rxd                       (io_uart_rxd                      ), //i
    .io_rts                       (rx_io_rts                        ), //o
    .io_error                     (rx_io_error                      ), //o
    .io_break                     (rx_io_break                      ), //o
    .clk                          (clk                              ), //i
    .reset                        (reset                            )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(io_config_frame_stop)
      `UartStopType_defaultEncoding_ONE : io_config_frame_stop_string = "ONE";
      `UartStopType_defaultEncoding_TWO : io_config_frame_stop_string = "TWO";
      default : io_config_frame_stop_string = "???";
    endcase
  end
  always @(*) begin
    case(io_config_frame_parity)
      `UartParityType_defaultEncoding_NONE : io_config_frame_parity_string = "NONE";
      `UartParityType_defaultEncoding_EVEN : io_config_frame_parity_string = "EVEN";
      `UartParityType_defaultEncoding_ODD : io_config_frame_parity_string = "ODD ";
      default : io_config_frame_parity_string = "????";
    endcase
  end
  `endif

  assign clockDivider_tick = (clockDivider_counter == 16'h0);
  always @ (*) begin
    io_write_thrown_valid = io_write_valid;
    if(rx_io_break)begin
      io_write_thrown_valid = 1'b0;
    end
  end

  always @ (*) begin
    io_write_ready = io_write_thrown_ready;
    if(rx_io_break)begin
      io_write_ready = 1'b1;
    end
  end

  assign io_write_thrown_payload = io_write_payload;
  assign io_write_thrown_ready = tx_io_write_ready;
  assign io_read_valid = rx_io_read_valid;
  assign io_read_payload = rx_io_read_payload;
  assign io_uart_txd = tx_io_txd;
  assign io_readError = rx_io_error;
  assign _zz_1_ = 1'b0;
  assign io_readBreak = rx_io_break;
  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      clockDivider_counter <= 16'h0;
    end else begin
      clockDivider_counter <= (clockDivider_counter - 16'h0001);
      if(clockDivider_tick)begin
        clockDivider_counter <= io_config_clockDivider;
      end
    end
  end


endmodule

module WishboneDecoder (
  input               io_input_CYC,
  input               io_input_STB,
  output              io_input_ACK,
  input               io_input_WE,
  input      [31:0]   io_input_ADR,
  output     [31:0]   io_input_DAT_MISO,
  input      [31:0]   io_input_DAT_MOSI,
  input      [3:0]    io_input_SEL,
  output              io_outputs_0_CYC,
  output              io_outputs_0_STB,
  input               io_outputs_0_ACK,
  output              io_outputs_0_WE,
  output     [31:0]   io_outputs_0_ADR,
  input      [31:0]   io_outputs_0_DAT_MISO,
  output     [31:0]   io_outputs_0_DAT_MOSI,
  output     [3:0]    io_outputs_0_SEL,
  output              io_outputs_1_CYC,
  output              io_outputs_1_STB,
  input               io_outputs_1_ACK,
  output              io_outputs_1_WE,
  output     [31:0]   io_outputs_1_ADR,
  input      [31:0]   io_outputs_1_DAT_MISO,
  output     [31:0]   io_outputs_1_DAT_MOSI,
  output     [3:0]    io_outputs_1_SEL,
  output              io_outputs_2_CYC,
  output              io_outputs_2_STB,
  input               io_outputs_2_ACK,
  output              io_outputs_2_WE,
  output     [31:0]   io_outputs_2_ADR,
  input      [31:0]   io_outputs_2_DAT_MISO,
  output     [31:0]   io_outputs_2_DAT_MOSI,
  output     [3:0]    io_outputs_2_SEL,
  output              io_outputs_3_CYC,
  output              io_outputs_3_STB,
  input               io_outputs_3_ACK,
  output              io_outputs_3_WE,
  output     [31:0]   io_outputs_3_ADR,
  input      [31:0]   io_outputs_3_DAT_MISO,
  output     [31:0]   io_outputs_3_DAT_MOSI,
  output     [3:0]    io_outputs_3_SEL,
  output              io_outputs_4_CYC,
  output              io_outputs_4_STB,
  input               io_outputs_4_ACK,
  output              io_outputs_4_WE,
  output     [31:0]   io_outputs_4_ADR,
  input      [31:0]   io_outputs_4_DAT_MISO,
  output     [31:0]   io_outputs_4_DAT_MOSI,
  output     [3:0]    io_outputs_4_SEL 
);
  reg                 _zz_5_;
  reg        [31:0]   _zz_6_;
  wire       [2:0]    _zz_7_;
  wire       [2:0]    _zz_8_;
  wire                selector_0;
  wire                selector_1;
  wire                selector_2;
  wire                selector_3;
  wire                selector_4;
  wire                _zz_1_;
  wire                _zz_2_;
  wire                _zz_3_;
  wire                _zz_4_;

  assign _zz_7_ = {selector_4,{_zz_2_,_zz_1_}};
  assign _zz_8_ = {selector_4,{_zz_4_,_zz_3_}};
  always @(*) begin
    case(_zz_7_)
      3'b000 : begin
        _zz_5_ = io_outputs_0_ACK;
      end
      3'b001 : begin
        _zz_5_ = io_outputs_1_ACK;
      end
      3'b010 : begin
        _zz_5_ = io_outputs_2_ACK;
      end
      3'b011 : begin
        _zz_5_ = io_outputs_3_ACK;
      end
      default : begin
        _zz_5_ = io_outputs_4_ACK;
      end
    endcase
  end

  always @(*) begin
    case(_zz_8_)
      3'b000 : begin
        _zz_6_ = io_outputs_0_DAT_MISO;
      end
      3'b001 : begin
        _zz_6_ = io_outputs_1_DAT_MISO;
      end
      3'b010 : begin
        _zz_6_ = io_outputs_2_DAT_MISO;
      end
      3'b011 : begin
        _zz_6_ = io_outputs_3_DAT_MISO;
      end
      default : begin
        _zz_6_ = io_outputs_4_DAT_MISO;
      end
    endcase
  end

  assign io_outputs_0_STB = io_input_STB;
  assign io_outputs_0_DAT_MOSI = io_input_DAT_MOSI;
  assign io_outputs_0_WE = io_input_WE;
  assign io_outputs_0_ADR = io_input_ADR;
  assign io_outputs_0_SEL = io_input_SEL;
  assign io_outputs_1_STB = io_input_STB;
  assign io_outputs_1_DAT_MOSI = io_input_DAT_MOSI;
  assign io_outputs_1_WE = io_input_WE;
  assign io_outputs_1_ADR = io_input_ADR;
  assign io_outputs_1_SEL = io_input_SEL;
  assign io_outputs_2_STB = io_input_STB;
  assign io_outputs_2_DAT_MOSI = io_input_DAT_MOSI;
  assign io_outputs_2_WE = io_input_WE;
  assign io_outputs_2_ADR = io_input_ADR;
  assign io_outputs_2_SEL = io_input_SEL;
  assign io_outputs_3_STB = io_input_STB;
  assign io_outputs_3_DAT_MOSI = io_input_DAT_MOSI;
  assign io_outputs_3_WE = io_input_WE;
  assign io_outputs_3_ADR = io_input_ADR;
  assign io_outputs_3_SEL = io_input_SEL;
  assign io_outputs_4_STB = io_input_STB;
  assign io_outputs_4_DAT_MOSI = io_input_DAT_MOSI;
  assign io_outputs_4_WE = io_input_WE;
  assign io_outputs_4_ADR = io_input_ADR;
  assign io_outputs_4_SEL = io_input_SEL;
  assign selector_0 = ((io_input_ADR < 32'h0003fffc) && io_input_CYC);
  assign selector_1 = (((io_input_ADR & (~ 32'h00000003)) == 32'h10000000) && io_input_CYC);
  assign selector_2 = (((io_input_ADR & (~ 32'h0000007f)) == 32'h20000000) && io_input_CYC);
  assign selector_3 = (((io_input_ADR & (~ 32'h0000007f)) == 32'h12000000) && io_input_CYC);
  assign selector_4 = (((io_input_ADR & (~ 32'h0000007f)) == 32'h11000000) && io_input_CYC);
  assign io_outputs_0_CYC = selector_0;
  assign io_outputs_1_CYC = selector_1;
  assign io_outputs_2_CYC = selector_2;
  assign io_outputs_3_CYC = selector_3;
  assign io_outputs_4_CYC = selector_4;
  assign _zz_1_ = (selector_1 || selector_3);
  assign _zz_2_ = (selector_2 || selector_3);
  assign io_input_ACK = _zz_5_;
  assign _zz_3_ = (selector_1 || selector_3);
  assign _zz_4_ = (selector_2 || selector_3);
  assign io_input_DAT_MISO = _zz_6_;

endmodule

module WishboneArbiter (
  input               io_inputs_0_CYC,
  input               io_inputs_0_STB,
  output              io_inputs_0_ACK,
  input               io_inputs_0_WE,
  input      [31:0]   io_inputs_0_ADR,
  output     [31:0]   io_inputs_0_DAT_MISO,
  input      [31:0]   io_inputs_0_DAT_MOSI,
  input      [3:0]    io_inputs_0_SEL,
  output              io_output_CYC,
  output              io_output_STB,
  input               io_output_ACK,
  output              io_output_WE,
  output     [31:0]   io_output_ADR,
  input      [31:0]   io_output_DAT_MISO,
  output     [31:0]   io_output_DAT_MOSI,
  output     [3:0]    io_output_SEL,
  input               clk,
  input               reset 
);
  wire       [0:0]    _zz_4_;
  wire       [1:0]    _zz_5_;
  wire       [0:0]    _zz_6_;
  wire       [1:0]    _zz_7_;
  wire       [0:0]    _zz_8_;
  wire       [0:0]    _zz_9_;
  reg                 maskLock_0;
  wire       [0:0]    _zz_1_;
  wire       [1:0]    _zz_2_;
  wire       [1:0]    _zz_3_;
  wire                roundRobin_0;
  reg                 selector_0;

  assign _zz_4_ = (1'b1);
  assign _zz_5_ = (_zz_2_ - _zz_7_);
  assign _zz_6_ = maskLock_0;
  assign _zz_7_ = {1'd0, _zz_6_};
  assign _zz_8_ = _zz_9_[0 : 0];
  assign _zz_9_ = (_zz_3_[1 : 1] | _zz_3_[0 : 0]);
  assign io_inputs_0_DAT_MISO = io_output_DAT_MISO;
  assign _zz_1_ = io_inputs_0_CYC;
  assign _zz_2_ = {_zz_1_,_zz_1_};
  assign _zz_3_ = (_zz_2_ & (~ _zz_5_));
  assign roundRobin_0 = _zz_8_[0];
  assign io_inputs_0_ACK = (selector_0 && io_output_ACK);
  assign io_output_CYC = io_inputs_0_CYC;
  assign io_output_STB = io_inputs_0_STB;
  assign io_output_WE = io_inputs_0_WE;
  assign io_output_ADR = io_inputs_0_ADR;
  assign io_output_DAT_MOSI = io_inputs_0_DAT_MOSI;
  assign io_output_SEL = io_inputs_0_SEL;
  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      maskLock_0 <= _zz_4_[0];
      selector_0 <= 1'b0;
    end else begin
      selector_0 <= roundRobin_0;
      if((io_output_CYC && (selector_0 != (1'b0))))begin
        maskLock_0 <= selector_0;
      end
    end
  end


endmodule
//WishboneArbiter_1_ replaced by WishboneArbiter
//WishboneArbiter_2_ replaced by WishboneArbiter
//WishboneArbiter_3_ replaced by WishboneArbiter
//WishboneArbiter_4_ replaced by WishboneArbiter

module picorv32_wb_mapped (
  output              io_wbm_CYC,
  output              io_wbm_STB,
  input               io_wbm_ACK,
  output              io_wbm_WE,
  output     [31:0]   io_wbm_ADR,
  input      [31:0]   io_wbm_DAT_MISO,
  output     [31:0]   io_wbm_DAT_MOSI,
  output     [3:0]    io_wbm_SEL,
  output              io_mem_instr,
  input      [31:0]   io_irq,
  output     [31:0]   io_eoi,
  input               clk,
  input               reset 
);
  wire                _zz_1_;
  wire       [31:0]   _zz_2_;
  wire                _zz_3_;
  wire                _zz_4_;
  wire       [31:0]   _zz_5_;
  wire                picorv_trap;
  wire       [31:0]   picorv_wbm_adr_o;
  wire       [31:0]   picorv_wbm_dat_o;
  wire                picorv_wbm_we_o;
  wire       [3:0]    picorv_wbm_sel_o;
  wire                picorv_wbm_stb_o;
  wire                picorv_wbm_cyc_o;
  wire                picorv_pcpi_valid;
  wire       [31:0]   picorv_pcpi_insn;
  wire       [31:0]   picorv_pcpi_rs1;
  wire       [31:0]   picorv_pcpi_rs2;
  wire       [31:0]   picorv_eoi;
  wire                picorv_trace_valid;
  wire       [35:0]   picorv_trace_data;
  wire                picorv_mem_instr;
  wire       [0:0]    _zz_6_;
  wire       [2:0]    _zz_7_;
  reg                 rstn;
  reg                 rstCounter_willIncrement;
  wire                rstCounter_willClear;
  reg        [2:0]    rstCounter_valueNext;
  reg        [2:0]    rstCounter_value;
  wire                rstCounter_willOverflowIfInc;
  wire                rstCounter_willOverflow;
  function  zz_rstCounter_willIncrement(input dummy);
    begin
      zz_rstCounter_willIncrement = 1'b0;
      zz_rstCounter_willIncrement = 1'b1;
    end
  endfunction
  wire  _zz_8_;

  assign _zz_6_ = rstCounter_willIncrement;
  assign _zz_7_ = {2'd0, _zz_6_};
  picorv32_wb #( 
    .ENABLE_COUNTERS(1'b1),
    .ENABLE_COUNTERS64(1'b1),
    .ENABLE_REGS_16_31(1'b1),
    .ENABLE_REGS_DUALPORT(1'b1),
    .TWO_STAGE_SHIFT(1'b1),
    .BARREL_SHIFTER(1'b0),
    .TWO_CYCLE_COMPARE(1'b0),
    .TWO_CYCLE_ALU(1'b0),
    .COMPRESSED_ISA(1'b0),
    .CATCH_MISALIGN(1'b1),
    .CATCH_ILLINSN(1'b1),
    .ENABLE_PCPI(1'b0),
    .ENABLE_MUL(1'b0),
    .ENABLE_FAST_MUL(1'b0),
    .ENABLE_DIV(1'b0),
    .ENABLE_IRQ(1'b0),
    .ENABLE_IRQ_QREGS(1'b1),
    .ENABLE_IRQ_TIMER(1'b1),
    .ENABLE_TRACE(1'b0),
    .REGS_INIT_ZERO(1'b0),
    .MASKED_IRQ(0),
    .LATCHED_IRQ(-1),
    .PROGADDR_RESET(0),
    .PROGADDR_IRQ(16),
    .STACKADDR(-1) 
  ) picorv ( 
    .trap           (picorv_trap              ), //o
    .wb_rst_i       (rstn                     ), //i
    .wb_clk_i       (clk                      ), //i
    .wbm_adr_o      (picorv_wbm_adr_o[31:0]   ), //o
    .wbm_dat_o      (picorv_wbm_dat_o[31:0]   ), //o
    .wbm_dat_i      (io_wbm_DAT_MISO[31:0]    ), //i
    .wbm_we_o       (picorv_wbm_we_o          ), //o
    .wbm_sel_o      (picorv_wbm_sel_o[3:0]    ), //o
    .wbm_stb_o      (picorv_wbm_stb_o         ), //o
    .wbm_ack_i      (io_wbm_ACK               ), //i
    .wbm_cyc_o      (picorv_wbm_cyc_o         ), //o
    .pcpi_valid     (picorv_pcpi_valid        ), //o
    .pcpi_insn      (picorv_pcpi_insn[31:0]   ), //o
    .pcpi_rs1       (picorv_pcpi_rs1[31:0]    ), //o
    .pcpi_rs2       (picorv_pcpi_rs2[31:0]    ), //o
    .pcpi_wr        (_zz_1_                   ), //i
    .pcpi_rd        (_zz_2_[31:0]             ), //i
    .pcpi_wait      (_zz_3_                   ), //i
    .pcpi_ready     (_zz_4_                   ), //i
    .irq            (_zz_5_[31:0]             ), //i
    .eoi            (picorv_eoi[31:0]         ), //o
    .trace_valid    (picorv_trace_valid       ), //o
    .trace_data     (picorv_trace_data[35:0]  ), //o
    .mem_instr      (picorv_mem_instr         )  //o
  );
  assign _zz_1_ = 1'b0;
  assign _zz_2_ = 32'h0;
  assign _zz_3_ = 1'b0;
  assign _zz_4_ = 1'b0;
  assign _zz_5_ = 32'hffffffff;
  assign _zz_8_ = zz_rstCounter_willIncrement(1'b0);
  always @ (*) rstCounter_willIncrement = _zz_8_;
  assign rstCounter_willClear = 1'b0;
  assign rstCounter_willOverflowIfInc = (rstCounter_value == (3'b111));
  assign rstCounter_willOverflow = (rstCounter_willOverflowIfInc && rstCounter_willIncrement);
  always @ (*) begin
    rstCounter_valueNext = (rstCounter_value + _zz_7_);
    if(rstCounter_willClear)begin
      rstCounter_valueNext = (3'b000);
    end
  end

  assign io_wbm_ADR = picorv_wbm_adr_o;
  assign io_wbm_DAT_MOSI = picorv_wbm_dat_o;
  assign io_wbm_WE = picorv_wbm_we_o;
  assign io_wbm_SEL = picorv_wbm_sel_o;
  assign io_wbm_STB = picorv_wbm_stb_o;
  assign io_wbm_CYC = picorv_wbm_cyc_o;
  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      rstn <= 1'b1;
      rstCounter_value <= (3'b000);
    end else begin
      rstCounter_value <= rstCounter_valueNext;
      if((rstCounter_value == (3'b110)))begin
        rstn <= 1'b0;
      end
    end
  end


endmodule

module WishboneROM (
  input               io_wb_CYC,
  input               io_wb_STB,
  output              io_wb_ACK,
  input               io_wb_WE,
  input      [31:0]   io_wb_ADR,
  output     [31:0]   io_wb_DAT_MISO,
  input      [31:0]   io_wb_DAT_MOSI,
  input      [3:0]    io_wb_SEL,
  input               clk,
  input               reset 
);
  reg        [31:0]   _zz_3_;
  wire       [31:0]   _zz_4_;
  wire       [14:0]   _zz_5_;
  wire                _zz_6_;
  wire       [29:0]   addrNoOffset;
  reg                 ackReg;
  wire                _zz_1_;
  wire       [14:0]   _zz_2_;
  reg [31:0] mem [0:32767];

  assign _zz_4_ = (io_wb_ADR - 32'h0);
  assign _zz_5_ = addrNoOffset[14 : 0];
  assign _zz_6_ = ((io_wb_CYC && io_wb_STB) && io_wb_WE);
  initial begin
    $readmemb("MyTopLevel.v_toplevel_WBrom_mem.bin",mem);
  end
  always @ (posedge clk) begin
    if(_zz_6_) begin
      mem[_zz_5_] <= io_wb_DAT_MOSI;
    end
  end

  always @ (posedge clk) begin
    if(_zz_1_) begin
      _zz_3_ <= mem[_zz_2_];
    end
  end

  assign addrNoOffset = (_zz_4_ >>> 2);
  assign io_wb_ACK = ackReg;
  assign _zz_1_ = ((io_wb_CYC && io_wb_STB) && (! io_wb_WE));
  assign _zz_2_ = addrNoOffset[14 : 0];
  assign io_wb_DAT_MISO = _zz_3_;
  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      ackReg <= 1'b0;
    end else begin
      if((io_wb_CYC && io_wb_STB))begin
        ackReg <= 1'b1;
      end else begin
        if((ackReg == 1'b1))begin
          ackReg <= 1'b0;
        end
      end
    end
  end


endmodule

module WishboneGpio (
  input               io_wb_CYC,
  input               io_wb_STB,
  output              io_wb_ACK,
  input               io_wb_WE,
  input      [31:0]   io_wb_ADR,
  output reg [31:0]   io_wb_DAT_MISO,
  input      [31:0]   io_wb_DAT_MOSI,
  input      [3:0]    io_wb_SEL,
  input      [1:0]    io_gpio_read,
  output     [1:0]    io_gpio_write,
  output     [1:0]    io_gpio_writeEnable,
  input               clk,
  input               reset 
);
  wire                ctrl_askWrite;
  wire                ctrl_askRead;
  wire                ctrl_doWrite;
  wire                ctrl_doRead;
  reg                 _zz_1_;
  reg        [1:0]    io_gpio_write_driver;
  reg        [1:0]    io_gpio_writeEnable_driver;

  always @ (*) begin
    io_wb_DAT_MISO = 32'h0;
    case(io_wb_ADR)
      32'b00010001000000000000000000000000 : begin
        io_wb_DAT_MISO[1 : 0] = io_gpio_read;
      end
      32'b00010001000000000000000000000100 : begin
        io_wb_DAT_MISO[1 : 0] = io_gpio_write_driver;
      end
      32'b00010001000000000000000000001000 : begin
        io_wb_DAT_MISO[1 : 0] = io_gpio_writeEnable_driver;
      end
      default : begin
      end
    endcase
  end

  assign ctrl_askWrite = ((io_wb_CYC && io_wb_STB) && io_wb_WE);
  assign ctrl_askRead = ((io_wb_CYC && io_wb_STB) && (! io_wb_WE));
  assign ctrl_doWrite = (((io_wb_CYC && io_wb_STB) && ((io_wb_CYC && io_wb_ACK) && io_wb_STB)) && io_wb_WE);
  assign ctrl_doRead = (((io_wb_CYC && io_wb_STB) && ((io_wb_CYC && io_wb_ACK) && io_wb_STB)) && (! io_wb_WE));
  assign io_wb_ACK = (_zz_1_ && io_wb_STB);
  assign io_gpio_write = io_gpio_write_driver;
  assign io_gpio_writeEnable = io_gpio_writeEnable_driver;
  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      _zz_1_ <= 1'b0;
      io_gpio_writeEnable_driver <= (2'b00);
    end else begin
      _zz_1_ <= (io_wb_STB && io_wb_CYC);
      case(io_wb_ADR)
        32'b00010001000000000000000000000000 : begin
        end
        32'b00010001000000000000000000000100 : begin
        end
        32'b00010001000000000000000000001000 : begin
          if(ctrl_doWrite)begin
            io_gpio_writeEnable_driver <= io_wb_DAT_MOSI[1 : 0];
          end
        end
        default : begin
        end
      endcase
    end
  end

  always @ (posedge clk) begin
    case(io_wb_ADR)
      32'b00010001000000000000000000000000 : begin
      end
      32'b00010001000000000000000000000100 : begin
        if(ctrl_doWrite)begin
          io_gpio_write_driver <= io_wb_DAT_MOSI[1 : 0];
        end
      end
      32'b00010001000000000000000000001000 : begin
      end
      default : begin
      end
    endcase
  end


endmodule

module WishboneTimer (
  input               io_wb_CYC,
  input               io_wb_STB,
  output              io_wb_ACK,
  input               io_wb_WE,
  input      [31:0]   io_wb_ADR,
  output reg [31:0]   io_wb_DAT_MISO,
  input      [31:0]   io_wb_DAT_MOSI,
  input      [3:0]    io_wb_SEL,
  output              io_IRQ,
  input               clk,
  input               reset 
);
  wire                _zz_2_;
  wire                _zz_3_;
  wire                timer_1__io_full;
  wire       [15:0]   timer_1__io_value;
  reg        [7:0]    settings;
  wire       [15:0]   counter;
  wire       [15:0]   divider;
  wire                ctrl_askWrite;
  wire                ctrl_askRead;
  wire                ctrl_doWrite;
  wire                ctrl_doRead;
  reg                 _zz_1_;
  reg        [15:0]   counter_driver;
  reg        [15:0]   divider_driver;

  Timer timer_1_ ( 
    .io_tick       (_zz_2_                   ), //i
    .io_clear      (_zz_3_                   ), //i
    .io_limit      (counter[15:0]            ), //i
    .io_divider    (divider[15:0]            ), //i
    .io_full       (timer_1__io_full         ), //o
    .io_value      (timer_1__io_value[15:0]  ), //o
    .clk           (clk                      ), //i
    .reset         (reset                    )  //i
  );
  assign io_IRQ = (timer_1__io_full && settings[1]);
  always @ (*) begin
    io_wb_DAT_MISO = 32'h0;
    case(io_wb_ADR)
      32'b00010010000000000000000000000000 : begin
        io_wb_DAT_MISO[0 : 0] = io_IRQ;
      end
      32'b00010010000000000000000000001100 : begin
        io_wb_DAT_MISO[7 : 0] = settings;
      end
      32'b00010010000000000000000000000100 : begin
        io_wb_DAT_MISO[15 : 0] = counter_driver;
      end
      32'b00010010000000000000000000001000 : begin
        io_wb_DAT_MISO[15 : 0] = divider_driver;
      end
      default : begin
      end
    endcase
  end

  assign ctrl_askWrite = ((io_wb_CYC && io_wb_STB) && io_wb_WE);
  assign ctrl_askRead = ((io_wb_CYC && io_wb_STB) && (! io_wb_WE));
  assign ctrl_doWrite = (((io_wb_CYC && io_wb_STB) && ((io_wb_CYC && io_wb_ACK) && io_wb_STB)) && io_wb_WE);
  assign ctrl_doRead = (((io_wb_CYC && io_wb_STB) && ((io_wb_CYC && io_wb_ACK) && io_wb_STB)) && (! io_wb_WE));
  assign io_wb_ACK = (_zz_1_ && io_wb_STB);
  assign counter = counter_driver;
  assign divider = divider_driver;
  assign _zz_3_ = settings[2];
  assign _zz_2_ = settings[0];
  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      settings <= 8'h0;
      _zz_1_ <= 1'b0;
    end else begin
      _zz_1_ <= (io_wb_STB && io_wb_CYC);
      settings[3] <= timer_1__io_full;
      case(io_wb_ADR)
        32'b00010010000000000000000000000000 : begin
        end
        32'b00010010000000000000000000001100 : begin
          if(ctrl_doWrite)begin
            settings <= io_wb_DAT_MOSI[7 : 0];
          end
        end
        32'b00010010000000000000000000000100 : begin
        end
        32'b00010010000000000000000000001000 : begin
        end
        default : begin
        end
      endcase
    end
  end

  always @ (posedge clk) begin
    case(io_wb_ADR)
      32'b00010010000000000000000000000000 : begin
      end
      32'b00010010000000000000000000001100 : begin
      end
      32'b00010010000000000000000000000100 : begin
        if(ctrl_doWrite)begin
          counter_driver <= io_wb_DAT_MOSI[15 : 0];
        end
      end
      32'b00010010000000000000000000001000 : begin
        if(ctrl_doWrite)begin
          divider_driver <= io_wb_DAT_MOSI[15 : 0];
        end
      end
      default : begin
      end
    endcase
  end


endmodule

module WishboneUart (
  input               io_wb_CYC,
  input               io_wb_STB,
  output              io_wb_ACK,
  input               io_wb_WE,
  input      [31:0]   io_wb_ADR,
  output reg [31:0]   io_wb_DAT_MISO,
  input      [31:0]   io_wb_DAT_MOSI,
  input      [3:0]    io_wb_SEL,
  output              io_uart_txd,
  input               io_uart_rxd,
  input               clk,
  input               reset 
);
  wire                _zz_5_;
  wire                _zz_6_;
  wire                uartCtrl_1__io_write_ready;
  wire                uartCtrl_1__io_read_valid;
  wire       [7:0]    uartCtrl_1__io_read_payload;
  wire                uartCtrl_1__io_uart_txd;
  wire                uartCtrl_1__io_readError;
  wire                uartCtrl_1__io_readBreak;
  wire                wbCtrl_askWrite;
  wire                wbCtrl_askRead;
  wire                wbCtrl_doWrite;
  wire                wbCtrl_doRead;
  reg                 _zz_1_;
  reg        [15:0]   clockDivReg;
  reg                 uartDataToWrite;
  reg                 uartDataAccepted;
  reg        [7:0]    uartWriteData;
  reg                 uartDataAvailable;
  reg        [7:0]    uartDataRead;
  reg        [2:0]    uartCtrl_1__io_config_frame_driver_dataLength;
  reg        `UartStopType_defaultEncoding_type uartCtrl_1__io_config_frame_driver_stop;
  reg        `UartParityType_defaultEncoding_type uartCtrl_1__io_config_frame_driver_parity;
  wire       [5:0]    _zz_2_;
  wire       `UartStopType_defaultEncoding_type _zz_3_;
  wire       `UartParityType_defaultEncoding_type _zz_4_;
  `ifndef SYNTHESIS
  reg [23:0] uartCtrl_1__io_config_frame_driver_stop_string;
  reg [31:0] uartCtrl_1__io_config_frame_driver_parity_string;
  reg [23:0] _zz_3__string;
  reg [31:0] _zz_4__string;
  `endif


  UartCtrl uartCtrl_1_ ( 
    .io_config_frame_dataLength    (uartCtrl_1__io_config_frame_driver_dataLength[2:0]  ), //i
    .io_config_frame_stop          (uartCtrl_1__io_config_frame_driver_stop             ), //i
    .io_config_frame_parity        (uartCtrl_1__io_config_frame_driver_parity[1:0]      ), //i
    .io_config_clockDivider        (clockDivReg[15:0]                                   ), //i
    .io_write_valid                (uartDataToWrite                                     ), //i
    .io_write_ready                (uartCtrl_1__io_write_ready                          ), //o
    .io_write_payload              (uartWriteData[7:0]                                  ), //i
    .io_read_valid                 (uartCtrl_1__io_read_valid                           ), //o
    .io_read_ready                 (_zz_5_                                              ), //i
    .io_read_payload               (uartCtrl_1__io_read_payload[7:0]                    ), //o
    .io_uart_txd                   (uartCtrl_1__io_uart_txd                             ), //o
    .io_uart_rxd                   (io_uart_rxd                                         ), //i
    .io_readError                  (uartCtrl_1__io_readError                            ), //o
    .io_writeBreak                 (_zz_6_                                              ), //i
    .io_readBreak                  (uartCtrl_1__io_readBreak                            ), //o
    .clk                           (clk                                                 ), //i
    .reset                         (reset                                               )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(uartCtrl_1__io_config_frame_driver_stop)
      `UartStopType_defaultEncoding_ONE : uartCtrl_1__io_config_frame_driver_stop_string = "ONE";
      `UartStopType_defaultEncoding_TWO : uartCtrl_1__io_config_frame_driver_stop_string = "TWO";
      default : uartCtrl_1__io_config_frame_driver_stop_string = "???";
    endcase
  end
  always @(*) begin
    case(uartCtrl_1__io_config_frame_driver_parity)
      `UartParityType_defaultEncoding_NONE : uartCtrl_1__io_config_frame_driver_parity_string = "NONE";
      `UartParityType_defaultEncoding_EVEN : uartCtrl_1__io_config_frame_driver_parity_string = "EVEN";
      `UartParityType_defaultEncoding_ODD : uartCtrl_1__io_config_frame_driver_parity_string = "ODD ";
      default : uartCtrl_1__io_config_frame_driver_parity_string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_3_)
      `UartStopType_defaultEncoding_ONE : _zz_3__string = "ONE";
      `UartStopType_defaultEncoding_TWO : _zz_3__string = "TWO";
      default : _zz_3__string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_4_)
      `UartParityType_defaultEncoding_NONE : _zz_4__string = "NONE";
      `UartParityType_defaultEncoding_EVEN : _zz_4__string = "EVEN";
      `UartParityType_defaultEncoding_ODD : _zz_4__string = "ODD ";
      default : _zz_4__string = "????";
    endcase
  end
  `endif

  assign io_uart_txd = uartCtrl_1__io_uart_txd;
  always @ (*) begin
    io_wb_DAT_MISO = 32'h0;
    case(io_wb_ADR)
      32'b00100000000000000000000000000000 : begin
        io_wb_DAT_MISO[15 : 0] = clockDivReg;
      end
      32'b00100000000000000000000000001000 : begin
      end
      32'b00100000000000000000000000000100 : begin
        io_wb_DAT_MISO[5 : 0] = {uartCtrl_1__io_config_frame_driver_parity,{uartCtrl_1__io_config_frame_driver_stop,uartCtrl_1__io_config_frame_driver_dataLength}};
      end
      32'b00100000000000000000000000001100 : begin
        io_wb_DAT_MISO[0 : 0] = uartDataToWrite;
      end
      32'b00100000000000000000000000010000 : begin
        io_wb_DAT_MISO[0 : 0] = uartDataAvailable;
      end
      32'b00100000000000000000000000010100 : begin
        io_wb_DAT_MISO[7 : 0] = uartDataRead;
      end
      default : begin
      end
    endcase
  end

  assign wbCtrl_askWrite = ((io_wb_CYC && io_wb_STB) && io_wb_WE);
  assign wbCtrl_askRead = ((io_wb_CYC && io_wb_STB) && (! io_wb_WE));
  assign wbCtrl_doWrite = (((io_wb_CYC && io_wb_STB) && ((io_wb_CYC && io_wb_ACK) && io_wb_STB)) && io_wb_WE);
  assign wbCtrl_doRead = (((io_wb_CYC && io_wb_STB) && ((io_wb_CYC && io_wb_ACK) && io_wb_STB)) && (! io_wb_WE));
  assign io_wb_ACK = (_zz_1_ && io_wb_STB);
  assign _zz_6_ = 1'b0;
  assign _zz_5_ = 1'b1;
  assign _zz_2_ = io_wb_DAT_MOSI[5 : 0];
  assign _zz_3_ = _zz_2_[3 : 3];
  assign _zz_4_ = _zz_2_[5 : 4];
  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      _zz_1_ <= 1'b0;
      clockDivReg <= 16'h0;
      uartDataToWrite <= 1'b0;
      uartDataAccepted <= 1'b0;
      uartDataAvailable <= 1'b0;
      uartDataRead <= 8'h0;
    end else begin
      _zz_1_ <= (io_wb_STB && io_wb_CYC);
      if((uartCtrl_1__io_write_ready == 1'b0))begin
        uartDataAccepted <= 1'b1;
      end
      if(((uartCtrl_1__io_write_ready == 1'b1) && (uartDataAccepted == 1'b1)))begin
        uartDataToWrite <= 1'b0;
      end
      if((uartCtrl_1__io_read_valid == 1'b1))begin
        uartDataRead <= uartCtrl_1__io_read_payload;
        uartDataAvailable <= 1'b1;
      end
      case(io_wb_ADR)
        32'b00100000000000000000000000000000 : begin
          if(wbCtrl_doWrite)begin
            clockDivReg <= io_wb_DAT_MOSI[15 : 0];
          end
        end
        32'b00100000000000000000000000001000 : begin
          if(wbCtrl_doWrite)begin
            uartDataToWrite <= 1'b1;
            uartDataAccepted <= 1'b0;
          end
        end
        32'b00100000000000000000000000000100 : begin
        end
        32'b00100000000000000000000000001100 : begin
        end
        32'b00100000000000000000000000010000 : begin
        end
        32'b00100000000000000000000000010100 : begin
          if(wbCtrl_doRead)begin
            uartDataAvailable <= 1'b0;
          end
        end
        default : begin
        end
      endcase
    end
  end

  always @ (posedge clk) begin
    case(io_wb_ADR)
      32'b00100000000000000000000000000000 : begin
      end
      32'b00100000000000000000000000001000 : begin
        if(wbCtrl_doWrite)begin
          uartWriteData <= io_wb_DAT_MOSI[7 : 0];
        end
      end
      32'b00100000000000000000000000000100 : begin
        if(wbCtrl_doWrite)begin
          uartCtrl_1__io_config_frame_driver_dataLength <= _zz_2_[2 : 0];
          uartCtrl_1__io_config_frame_driver_stop <= _zz_3_;
          uartCtrl_1__io_config_frame_driver_parity <= _zz_4_;
        end
      end
      32'b00100000000000000000000000001100 : begin
      end
      32'b00100000000000000000000000010000 : begin
      end
      32'b00100000000000000000000000010100 : begin
      end
      default : begin
      end
    endcase
  end


endmodule

module WishboneTest (
  input               io_wb_CYC,
  input               io_wb_STB,
  output              io_wb_ACK,
  input               io_wb_WE,
  input      [31:0]   io_wb_ADR,
  output     [31:0]   io_wb_DAT_MISO,
  input      [31:0]   io_wb_DAT_MOSI,
  input      [3:0]    io_wb_SEL,
  output reg [7:0]    io_charOut,
  output reg          io_updateOut,
  input               clk,
  input               reset 
);
  wire                _zz_1_;
  wire                _zz_2_;
  reg                 ackReg;

  assign _zz_1_ = ((io_wb_CYC && io_wb_STB) && io_wb_WE);
  assign _zz_2_ = (io_wb_ADR == 32'h10000000);
  assign io_wb_ACK = ackReg;
  always @ (*) begin
    io_updateOut = 1'b0;
    if(_zz_1_)begin
      if(_zz_2_)begin
        io_updateOut = 1'b1;
      end
    end
  end

  always @ (*) begin
    io_charOut = 8'h0;
    if(_zz_1_)begin
      if(_zz_2_)begin
        io_charOut = io_wb_DAT_MOSI[7 : 0];
      end
    end
  end

  assign io_wb_DAT_MISO = 32'h0;
  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      ackReg <= 1'b0;
    end else begin
      if((io_wb_CYC && io_wb_STB))begin
        ackReg <= 1'b1;
      end else begin
        if((ackReg == 1'b1))begin
          ackReg <= 1'b0;
        end
      end
    end
  end


endmodule

module WishboneInterconComponent (
  input               io_busMasters_0_CYC,
  input               io_busMasters_0_STB,
  output              io_busMasters_0_ACK,
  input               io_busMasters_0_WE,
  input      [31:0]   io_busMasters_0_ADR,
  output     [31:0]   io_busMasters_0_DAT_MISO,
  input      [31:0]   io_busMasters_0_DAT_MOSI,
  input      [3:0]    io_busMasters_0_SEL,
  output              io_busSlaves_0_CYC,
  output              io_busSlaves_0_STB,
  input               io_busSlaves_0_ACK,
  output              io_busSlaves_0_WE,
  output     [31:0]   io_busSlaves_0_ADR,
  input      [31:0]   io_busSlaves_0_DAT_MISO,
  output     [31:0]   io_busSlaves_0_DAT_MOSI,
  output     [3:0]    io_busSlaves_0_SEL,
  output              io_busSlaves_1_CYC,
  output              io_busSlaves_1_STB,
  input               io_busSlaves_1_ACK,
  output              io_busSlaves_1_WE,
  output     [31:0]   io_busSlaves_1_ADR,
  input      [31:0]   io_busSlaves_1_DAT_MISO,
  output     [31:0]   io_busSlaves_1_DAT_MOSI,
  output     [3:0]    io_busSlaves_1_SEL,
  output              io_busSlaves_2_CYC,
  output              io_busSlaves_2_STB,
  input               io_busSlaves_2_ACK,
  output              io_busSlaves_2_WE,
  output     [31:0]   io_busSlaves_2_ADR,
  input      [31:0]   io_busSlaves_2_DAT_MISO,
  output     [31:0]   io_busSlaves_2_DAT_MOSI,
  output     [3:0]    io_busSlaves_2_SEL,
  output              io_busSlaves_3_CYC,
  output              io_busSlaves_3_STB,
  input               io_busSlaves_3_ACK,
  output              io_busSlaves_3_WE,
  output     [31:0]   io_busSlaves_3_ADR,
  input      [31:0]   io_busSlaves_3_DAT_MISO,
  output     [31:0]   io_busSlaves_3_DAT_MOSI,
  output     [3:0]    io_busSlaves_3_SEL,
  output              io_busSlaves_4_CYC,
  output              io_busSlaves_4_STB,
  input               io_busSlaves_4_ACK,
  output              io_busSlaves_4_WE,
  output     [31:0]   io_busSlaves_4_ADR,
  input      [31:0]   io_busSlaves_4_DAT_MISO,
  output     [31:0]   io_busSlaves_4_DAT_MOSI,
  output     [3:0]    io_busSlaves_4_SEL,
  input               clk,
  input               reset 
);
  wire       [31:0]   io_busMasters_0_decoder_io_input_DAT_MISO;
  wire                io_busMasters_0_decoder_io_input_ACK;
  wire       [31:0]   io_busMasters_0_decoder_io_outputs_0_DAT_MOSI;
  wire       [31:0]   io_busMasters_0_decoder_io_outputs_0_ADR;
  wire                io_busMasters_0_decoder_io_outputs_0_CYC;
  wire       [3:0]    io_busMasters_0_decoder_io_outputs_0_SEL;
  wire                io_busMasters_0_decoder_io_outputs_0_STB;
  wire                io_busMasters_0_decoder_io_outputs_0_WE;
  wire       [31:0]   io_busMasters_0_decoder_io_outputs_1_DAT_MOSI;
  wire       [31:0]   io_busMasters_0_decoder_io_outputs_1_ADR;
  wire                io_busMasters_0_decoder_io_outputs_1_CYC;
  wire       [3:0]    io_busMasters_0_decoder_io_outputs_1_SEL;
  wire                io_busMasters_0_decoder_io_outputs_1_STB;
  wire                io_busMasters_0_decoder_io_outputs_1_WE;
  wire       [31:0]   io_busMasters_0_decoder_io_outputs_2_DAT_MOSI;
  wire       [31:0]   io_busMasters_0_decoder_io_outputs_2_ADR;
  wire                io_busMasters_0_decoder_io_outputs_2_CYC;
  wire       [3:0]    io_busMasters_0_decoder_io_outputs_2_SEL;
  wire                io_busMasters_0_decoder_io_outputs_2_STB;
  wire                io_busMasters_0_decoder_io_outputs_2_WE;
  wire       [31:0]   io_busMasters_0_decoder_io_outputs_3_DAT_MOSI;
  wire       [31:0]   io_busMasters_0_decoder_io_outputs_3_ADR;
  wire                io_busMasters_0_decoder_io_outputs_3_CYC;
  wire       [3:0]    io_busMasters_0_decoder_io_outputs_3_SEL;
  wire                io_busMasters_0_decoder_io_outputs_3_STB;
  wire                io_busMasters_0_decoder_io_outputs_3_WE;
  wire       [31:0]   io_busMasters_0_decoder_io_outputs_4_DAT_MOSI;
  wire       [31:0]   io_busMasters_0_decoder_io_outputs_4_ADR;
  wire                io_busMasters_0_decoder_io_outputs_4_CYC;
  wire       [3:0]    io_busMasters_0_decoder_io_outputs_4_SEL;
  wire                io_busMasters_0_decoder_io_outputs_4_STB;
  wire                io_busMasters_0_decoder_io_outputs_4_WE;
  wire       [31:0]   io_busSlaves_0_arbiter_io_inputs_0_DAT_MISO;
  wire                io_busSlaves_0_arbiter_io_inputs_0_ACK;
  wire       [31:0]   io_busSlaves_0_arbiter_io_output_DAT_MOSI;
  wire       [31:0]   io_busSlaves_0_arbiter_io_output_ADR;
  wire                io_busSlaves_0_arbiter_io_output_CYC;
  wire       [3:0]    io_busSlaves_0_arbiter_io_output_SEL;
  wire                io_busSlaves_0_arbiter_io_output_STB;
  wire                io_busSlaves_0_arbiter_io_output_WE;
  wire       [31:0]   io_busSlaves_1_arbiter_io_inputs_0_DAT_MISO;
  wire                io_busSlaves_1_arbiter_io_inputs_0_ACK;
  wire       [31:0]   io_busSlaves_1_arbiter_io_output_DAT_MOSI;
  wire       [31:0]   io_busSlaves_1_arbiter_io_output_ADR;
  wire                io_busSlaves_1_arbiter_io_output_CYC;
  wire       [3:0]    io_busSlaves_1_arbiter_io_output_SEL;
  wire                io_busSlaves_1_arbiter_io_output_STB;
  wire                io_busSlaves_1_arbiter_io_output_WE;
  wire       [31:0]   io_busSlaves_2_arbiter_io_inputs_0_DAT_MISO;
  wire                io_busSlaves_2_arbiter_io_inputs_0_ACK;
  wire       [31:0]   io_busSlaves_2_arbiter_io_output_DAT_MOSI;
  wire       [31:0]   io_busSlaves_2_arbiter_io_output_ADR;
  wire                io_busSlaves_2_arbiter_io_output_CYC;
  wire       [3:0]    io_busSlaves_2_arbiter_io_output_SEL;
  wire                io_busSlaves_2_arbiter_io_output_STB;
  wire                io_busSlaves_2_arbiter_io_output_WE;
  wire       [31:0]   io_busSlaves_3_arbiter_io_inputs_0_DAT_MISO;
  wire                io_busSlaves_3_arbiter_io_inputs_0_ACK;
  wire       [31:0]   io_busSlaves_3_arbiter_io_output_DAT_MOSI;
  wire       [31:0]   io_busSlaves_3_arbiter_io_output_ADR;
  wire                io_busSlaves_3_arbiter_io_output_CYC;
  wire       [3:0]    io_busSlaves_3_arbiter_io_output_SEL;
  wire                io_busSlaves_3_arbiter_io_output_STB;
  wire                io_busSlaves_3_arbiter_io_output_WE;
  wire       [31:0]   io_busSlaves_4_arbiter_io_inputs_0_DAT_MISO;
  wire                io_busSlaves_4_arbiter_io_inputs_0_ACK;
  wire       [31:0]   io_busSlaves_4_arbiter_io_output_DAT_MOSI;
  wire       [31:0]   io_busSlaves_4_arbiter_io_output_ADR;
  wire                io_busSlaves_4_arbiter_io_output_CYC;
  wire       [3:0]    io_busSlaves_4_arbiter_io_output_SEL;
  wire                io_busSlaves_4_arbiter_io_output_STB;
  wire                io_busSlaves_4_arbiter_io_output_WE;

  WishboneDecoder io_busMasters_0_decoder ( 
    .io_input_CYC             (io_busMasters_0_CYC                                  ), //i
    .io_input_STB             (io_busMasters_0_STB                                  ), //i
    .io_input_ACK             (io_busMasters_0_decoder_io_input_ACK                 ), //o
    .io_input_WE              (io_busMasters_0_WE                                   ), //i
    .io_input_ADR             (io_busMasters_0_ADR[31:0]                            ), //i
    .io_input_DAT_MISO        (io_busMasters_0_decoder_io_input_DAT_MISO[31:0]      ), //o
    .io_input_DAT_MOSI        (io_busMasters_0_DAT_MOSI[31:0]                       ), //i
    .io_input_SEL             (io_busMasters_0_SEL[3:0]                             ), //i
    .io_outputs_0_CYC         (io_busMasters_0_decoder_io_outputs_0_CYC             ), //o
    .io_outputs_0_STB         (io_busMasters_0_decoder_io_outputs_0_STB             ), //o
    .io_outputs_0_ACK         (io_busSlaves_0_arbiter_io_inputs_0_ACK               ), //i
    .io_outputs_0_WE          (io_busMasters_0_decoder_io_outputs_0_WE              ), //o
    .io_outputs_0_ADR         (io_busMasters_0_decoder_io_outputs_0_ADR[31:0]       ), //o
    .io_outputs_0_DAT_MISO    (io_busSlaves_0_arbiter_io_inputs_0_DAT_MISO[31:0]    ), //i
    .io_outputs_0_DAT_MOSI    (io_busMasters_0_decoder_io_outputs_0_DAT_MOSI[31:0]  ), //o
    .io_outputs_0_SEL         (io_busMasters_0_decoder_io_outputs_0_SEL[3:0]        ), //o
    .io_outputs_1_CYC         (io_busMasters_0_decoder_io_outputs_1_CYC             ), //o
    .io_outputs_1_STB         (io_busMasters_0_decoder_io_outputs_1_STB             ), //o
    .io_outputs_1_ACK         (io_busSlaves_1_arbiter_io_inputs_0_ACK               ), //i
    .io_outputs_1_WE          (io_busMasters_0_decoder_io_outputs_1_WE              ), //o
    .io_outputs_1_ADR         (io_busMasters_0_decoder_io_outputs_1_ADR[31:0]       ), //o
    .io_outputs_1_DAT_MISO    (io_busSlaves_1_arbiter_io_inputs_0_DAT_MISO[31:0]    ), //i
    .io_outputs_1_DAT_MOSI    (io_busMasters_0_decoder_io_outputs_1_DAT_MOSI[31:0]  ), //o
    .io_outputs_1_SEL         (io_busMasters_0_decoder_io_outputs_1_SEL[3:0]        ), //o
    .io_outputs_2_CYC         (io_busMasters_0_decoder_io_outputs_2_CYC             ), //o
    .io_outputs_2_STB         (io_busMasters_0_decoder_io_outputs_2_STB             ), //o
    .io_outputs_2_ACK         (io_busSlaves_2_arbiter_io_inputs_0_ACK               ), //i
    .io_outputs_2_WE          (io_busMasters_0_decoder_io_outputs_2_WE              ), //o
    .io_outputs_2_ADR         (io_busMasters_0_decoder_io_outputs_2_ADR[31:0]       ), //o
    .io_outputs_2_DAT_MISO    (io_busSlaves_2_arbiter_io_inputs_0_DAT_MISO[31:0]    ), //i
    .io_outputs_2_DAT_MOSI    (io_busMasters_0_decoder_io_outputs_2_DAT_MOSI[31:0]  ), //o
    .io_outputs_2_SEL         (io_busMasters_0_decoder_io_outputs_2_SEL[3:0]        ), //o
    .io_outputs_3_CYC         (io_busMasters_0_decoder_io_outputs_3_CYC             ), //o
    .io_outputs_3_STB         (io_busMasters_0_decoder_io_outputs_3_STB             ), //o
    .io_outputs_3_ACK         (io_busSlaves_3_arbiter_io_inputs_0_ACK               ), //i
    .io_outputs_3_WE          (io_busMasters_0_decoder_io_outputs_3_WE              ), //o
    .io_outputs_3_ADR         (io_busMasters_0_decoder_io_outputs_3_ADR[31:0]       ), //o
    .io_outputs_3_DAT_MISO    (io_busSlaves_3_arbiter_io_inputs_0_DAT_MISO[31:0]    ), //i
    .io_outputs_3_DAT_MOSI    (io_busMasters_0_decoder_io_outputs_3_DAT_MOSI[31:0]  ), //o
    .io_outputs_3_SEL         (io_busMasters_0_decoder_io_outputs_3_SEL[3:0]        ), //o
    .io_outputs_4_CYC         (io_busMasters_0_decoder_io_outputs_4_CYC             ), //o
    .io_outputs_4_STB         (io_busMasters_0_decoder_io_outputs_4_STB             ), //o
    .io_outputs_4_ACK         (io_busSlaves_4_arbiter_io_inputs_0_ACK               ), //i
    .io_outputs_4_WE          (io_busMasters_0_decoder_io_outputs_4_WE              ), //o
    .io_outputs_4_ADR         (io_busMasters_0_decoder_io_outputs_4_ADR[31:0]       ), //o
    .io_outputs_4_DAT_MISO    (io_busSlaves_4_arbiter_io_inputs_0_DAT_MISO[31:0]    ), //i
    .io_outputs_4_DAT_MOSI    (io_busMasters_0_decoder_io_outputs_4_DAT_MOSI[31:0]  ), //o
    .io_outputs_4_SEL         (io_busMasters_0_decoder_io_outputs_4_SEL[3:0]        )  //o
  );
  WishboneArbiter io_busSlaves_0_arbiter ( 
    .io_inputs_0_CYC         (io_busMasters_0_decoder_io_outputs_0_CYC             ), //i
    .io_inputs_0_STB         (io_busMasters_0_decoder_io_outputs_0_STB             ), //i
    .io_inputs_0_ACK         (io_busSlaves_0_arbiter_io_inputs_0_ACK               ), //o
    .io_inputs_0_WE          (io_busMasters_0_decoder_io_outputs_0_WE              ), //i
    .io_inputs_0_ADR         (io_busMasters_0_decoder_io_outputs_0_ADR[31:0]       ), //i
    .io_inputs_0_DAT_MISO    (io_busSlaves_0_arbiter_io_inputs_0_DAT_MISO[31:0]    ), //o
    .io_inputs_0_DAT_MOSI    (io_busMasters_0_decoder_io_outputs_0_DAT_MOSI[31:0]  ), //i
    .io_inputs_0_SEL         (io_busMasters_0_decoder_io_outputs_0_SEL[3:0]        ), //i
    .io_output_CYC           (io_busSlaves_0_arbiter_io_output_CYC                 ), //o
    .io_output_STB           (io_busSlaves_0_arbiter_io_output_STB                 ), //o
    .io_output_ACK           (io_busSlaves_0_ACK                                   ), //i
    .io_output_WE            (io_busSlaves_0_arbiter_io_output_WE                  ), //o
    .io_output_ADR           (io_busSlaves_0_arbiter_io_output_ADR[31:0]           ), //o
    .io_output_DAT_MISO      (io_busSlaves_0_DAT_MISO[31:0]                        ), //i
    .io_output_DAT_MOSI      (io_busSlaves_0_arbiter_io_output_DAT_MOSI[31:0]      ), //o
    .io_output_SEL           (io_busSlaves_0_arbiter_io_output_SEL[3:0]            ), //o
    .clk                     (clk                                                  ), //i
    .reset                   (reset                                                )  //i
  );
  WishboneArbiter io_busSlaves_1_arbiter ( 
    .io_inputs_0_CYC         (io_busMasters_0_decoder_io_outputs_1_CYC             ), //i
    .io_inputs_0_STB         (io_busMasters_0_decoder_io_outputs_1_STB             ), //i
    .io_inputs_0_ACK         (io_busSlaves_1_arbiter_io_inputs_0_ACK               ), //o
    .io_inputs_0_WE          (io_busMasters_0_decoder_io_outputs_1_WE              ), //i
    .io_inputs_0_ADR         (io_busMasters_0_decoder_io_outputs_1_ADR[31:0]       ), //i
    .io_inputs_0_DAT_MISO    (io_busSlaves_1_arbiter_io_inputs_0_DAT_MISO[31:0]    ), //o
    .io_inputs_0_DAT_MOSI    (io_busMasters_0_decoder_io_outputs_1_DAT_MOSI[31:0]  ), //i
    .io_inputs_0_SEL         (io_busMasters_0_decoder_io_outputs_1_SEL[3:0]        ), //i
    .io_output_CYC           (io_busSlaves_1_arbiter_io_output_CYC                 ), //o
    .io_output_STB           (io_busSlaves_1_arbiter_io_output_STB                 ), //o
    .io_output_ACK           (io_busSlaves_1_ACK                                   ), //i
    .io_output_WE            (io_busSlaves_1_arbiter_io_output_WE                  ), //o
    .io_output_ADR           (io_busSlaves_1_arbiter_io_output_ADR[31:0]           ), //o
    .io_output_DAT_MISO      (io_busSlaves_1_DAT_MISO[31:0]                        ), //i
    .io_output_DAT_MOSI      (io_busSlaves_1_arbiter_io_output_DAT_MOSI[31:0]      ), //o
    .io_output_SEL           (io_busSlaves_1_arbiter_io_output_SEL[3:0]            ), //o
    .clk                     (clk                                                  ), //i
    .reset                   (reset                                                )  //i
  );
  WishboneArbiter io_busSlaves_2_arbiter ( 
    .io_inputs_0_CYC         (io_busMasters_0_decoder_io_outputs_2_CYC             ), //i
    .io_inputs_0_STB         (io_busMasters_0_decoder_io_outputs_2_STB             ), //i
    .io_inputs_0_ACK         (io_busSlaves_2_arbiter_io_inputs_0_ACK               ), //o
    .io_inputs_0_WE          (io_busMasters_0_decoder_io_outputs_2_WE              ), //i
    .io_inputs_0_ADR         (io_busMasters_0_decoder_io_outputs_2_ADR[31:0]       ), //i
    .io_inputs_0_DAT_MISO    (io_busSlaves_2_arbiter_io_inputs_0_DAT_MISO[31:0]    ), //o
    .io_inputs_0_DAT_MOSI    (io_busMasters_0_decoder_io_outputs_2_DAT_MOSI[31:0]  ), //i
    .io_inputs_0_SEL         (io_busMasters_0_decoder_io_outputs_2_SEL[3:0]        ), //i
    .io_output_CYC           (io_busSlaves_2_arbiter_io_output_CYC                 ), //o
    .io_output_STB           (io_busSlaves_2_arbiter_io_output_STB                 ), //o
    .io_output_ACK           (io_busSlaves_2_ACK                                   ), //i
    .io_output_WE            (io_busSlaves_2_arbiter_io_output_WE                  ), //o
    .io_output_ADR           (io_busSlaves_2_arbiter_io_output_ADR[31:0]           ), //o
    .io_output_DAT_MISO      (io_busSlaves_2_DAT_MISO[31:0]                        ), //i
    .io_output_DAT_MOSI      (io_busSlaves_2_arbiter_io_output_DAT_MOSI[31:0]      ), //o
    .io_output_SEL           (io_busSlaves_2_arbiter_io_output_SEL[3:0]            ), //o
    .clk                     (clk                                                  ), //i
    .reset                   (reset                                                )  //i
  );
  WishboneArbiter io_busSlaves_3_arbiter ( 
    .io_inputs_0_CYC         (io_busMasters_0_decoder_io_outputs_3_CYC             ), //i
    .io_inputs_0_STB         (io_busMasters_0_decoder_io_outputs_3_STB             ), //i
    .io_inputs_0_ACK         (io_busSlaves_3_arbiter_io_inputs_0_ACK               ), //o
    .io_inputs_0_WE          (io_busMasters_0_decoder_io_outputs_3_WE              ), //i
    .io_inputs_0_ADR         (io_busMasters_0_decoder_io_outputs_3_ADR[31:0]       ), //i
    .io_inputs_0_DAT_MISO    (io_busSlaves_3_arbiter_io_inputs_0_DAT_MISO[31:0]    ), //o
    .io_inputs_0_DAT_MOSI    (io_busMasters_0_decoder_io_outputs_3_DAT_MOSI[31:0]  ), //i
    .io_inputs_0_SEL         (io_busMasters_0_decoder_io_outputs_3_SEL[3:0]        ), //i
    .io_output_CYC           (io_busSlaves_3_arbiter_io_output_CYC                 ), //o
    .io_output_STB           (io_busSlaves_3_arbiter_io_output_STB                 ), //o
    .io_output_ACK           (io_busSlaves_3_ACK                                   ), //i
    .io_output_WE            (io_busSlaves_3_arbiter_io_output_WE                  ), //o
    .io_output_ADR           (io_busSlaves_3_arbiter_io_output_ADR[31:0]           ), //o
    .io_output_DAT_MISO      (io_busSlaves_3_DAT_MISO[31:0]                        ), //i
    .io_output_DAT_MOSI      (io_busSlaves_3_arbiter_io_output_DAT_MOSI[31:0]      ), //o
    .io_output_SEL           (io_busSlaves_3_arbiter_io_output_SEL[3:0]            ), //o
    .clk                     (clk                                                  ), //i
    .reset                   (reset                                                )  //i
  );
  WishboneArbiter io_busSlaves_4_arbiter ( 
    .io_inputs_0_CYC         (io_busMasters_0_decoder_io_outputs_4_CYC             ), //i
    .io_inputs_0_STB         (io_busMasters_0_decoder_io_outputs_4_STB             ), //i
    .io_inputs_0_ACK         (io_busSlaves_4_arbiter_io_inputs_0_ACK               ), //o
    .io_inputs_0_WE          (io_busMasters_0_decoder_io_outputs_4_WE              ), //i
    .io_inputs_0_ADR         (io_busMasters_0_decoder_io_outputs_4_ADR[31:0]       ), //i
    .io_inputs_0_DAT_MISO    (io_busSlaves_4_arbiter_io_inputs_0_DAT_MISO[31:0]    ), //o
    .io_inputs_0_DAT_MOSI    (io_busMasters_0_decoder_io_outputs_4_DAT_MOSI[31:0]  ), //i
    .io_inputs_0_SEL         (io_busMasters_0_decoder_io_outputs_4_SEL[3:0]        ), //i
    .io_output_CYC           (io_busSlaves_4_arbiter_io_output_CYC                 ), //o
    .io_output_STB           (io_busSlaves_4_arbiter_io_output_STB                 ), //o
    .io_output_ACK           (io_busSlaves_4_ACK                                   ), //i
    .io_output_WE            (io_busSlaves_4_arbiter_io_output_WE                  ), //o
    .io_output_ADR           (io_busSlaves_4_arbiter_io_output_ADR[31:0]           ), //o
    .io_output_DAT_MISO      (io_busSlaves_4_DAT_MISO[31:0]                        ), //i
    .io_output_DAT_MOSI      (io_busSlaves_4_arbiter_io_output_DAT_MOSI[31:0]      ), //o
    .io_output_SEL           (io_busSlaves_4_arbiter_io_output_SEL[3:0]            ), //o
    .clk                     (clk                                                  ), //i
    .reset                   (reset                                                )  //i
  );
  assign io_busMasters_0_DAT_MISO = io_busMasters_0_decoder_io_input_DAT_MISO;
  assign io_busMasters_0_ACK = io_busMasters_0_decoder_io_input_ACK;
  assign io_busSlaves_0_CYC = io_busSlaves_0_arbiter_io_output_CYC;
  assign io_busSlaves_0_ADR = io_busSlaves_0_arbiter_io_output_ADR;
  assign io_busSlaves_0_DAT_MOSI = io_busSlaves_0_arbiter_io_output_DAT_MOSI;
  assign io_busSlaves_0_STB = io_busSlaves_0_arbiter_io_output_STB;
  assign io_busSlaves_0_WE = io_busSlaves_0_arbiter_io_output_WE;
  assign io_busSlaves_0_SEL = io_busSlaves_0_arbiter_io_output_SEL;
  assign io_busSlaves_1_CYC = io_busSlaves_1_arbiter_io_output_CYC;
  assign io_busSlaves_1_ADR = io_busSlaves_1_arbiter_io_output_ADR;
  assign io_busSlaves_1_DAT_MOSI = io_busSlaves_1_arbiter_io_output_DAT_MOSI;
  assign io_busSlaves_1_STB = io_busSlaves_1_arbiter_io_output_STB;
  assign io_busSlaves_1_WE = io_busSlaves_1_arbiter_io_output_WE;
  assign io_busSlaves_1_SEL = io_busSlaves_1_arbiter_io_output_SEL;
  assign io_busSlaves_2_CYC = io_busSlaves_2_arbiter_io_output_CYC;
  assign io_busSlaves_2_ADR = io_busSlaves_2_arbiter_io_output_ADR;
  assign io_busSlaves_2_DAT_MOSI = io_busSlaves_2_arbiter_io_output_DAT_MOSI;
  assign io_busSlaves_2_STB = io_busSlaves_2_arbiter_io_output_STB;
  assign io_busSlaves_2_WE = io_busSlaves_2_arbiter_io_output_WE;
  assign io_busSlaves_2_SEL = io_busSlaves_2_arbiter_io_output_SEL;
  assign io_busSlaves_3_CYC = io_busSlaves_3_arbiter_io_output_CYC;
  assign io_busSlaves_3_ADR = io_busSlaves_3_arbiter_io_output_ADR;
  assign io_busSlaves_3_DAT_MOSI = io_busSlaves_3_arbiter_io_output_DAT_MOSI;
  assign io_busSlaves_3_STB = io_busSlaves_3_arbiter_io_output_STB;
  assign io_busSlaves_3_WE = io_busSlaves_3_arbiter_io_output_WE;
  assign io_busSlaves_3_SEL = io_busSlaves_3_arbiter_io_output_SEL;
  assign io_busSlaves_4_CYC = io_busSlaves_4_arbiter_io_output_CYC;
  assign io_busSlaves_4_ADR = io_busSlaves_4_arbiter_io_output_ADR;
  assign io_busSlaves_4_DAT_MOSI = io_busSlaves_4_arbiter_io_output_DAT_MOSI;
  assign io_busSlaves_4_STB = io_busSlaves_4_arbiter_io_output_STB;
  assign io_busSlaves_4_WE = io_busSlaves_4_arbiter_io_output_WE;
  assign io_busSlaves_4_SEL = io_busSlaves_4_arbiter_io_output_SEL;

endmodule

module MyTopLevel (
  output              io_flag,
  output     [7:0]    io_charOut,
  output              io_uart_txd,
  input               io_uart_rxd,
  input      [1:0]    io_gpio_read,
  output     [1:0]    io_gpio_write,
  output     [1:0]    io_gpio_writeEnable,
  input               clk,
  input               reset 
);
  wire       [31:0]   _zz_1_;
  wire       [31:0]   picorv_io_wbm_DAT_MOSI;
  wire       [31:0]   picorv_io_wbm_ADR;
  wire                picorv_io_wbm_CYC;
  wire       [3:0]    picorv_io_wbm_SEL;
  wire                picorv_io_wbm_STB;
  wire                picorv_io_wbm_WE;
  wire                picorv_io_mem_instr;
  wire       [31:0]   picorv_io_eoi;
  wire       [31:0]   WBrom_io_wb_DAT_MISO;
  wire                WBrom_io_wb_ACK;
  wire       [31:0]   WBGPIO_io_wb_DAT_MISO;
  wire                WBGPIO_io_wb_ACK;
  wire       [1:0]    WBGPIO_io_gpio_write;
  wire       [1:0]    WBGPIO_io_gpio_writeEnable;
  wire       [31:0]   WBTimer_io_wb_DAT_MISO;
  wire                WBTimer_io_wb_ACK;
  wire                WBTimer_io_IRQ;
  wire       [31:0]   WBUart_io_wb_DAT_MISO;
  wire                WBUart_io_wb_ACK;
  wire                WBUart_io_uart_txd;
  wire       [31:0]   WBtest_io_wb_DAT_MISO;
  wire                WBtest_io_wb_ACK;
  wire       [7:0]    WBtest_io_charOut;
  wire                WBtest_io_updateOut;
  wire       [31:0]   Wbint_io_busMasters_0_DAT_MISO;
  wire                Wbint_io_busMasters_0_ACK;
  wire       [31:0]   Wbint_io_busSlaves_0_DAT_MOSI;
  wire       [31:0]   Wbint_io_busSlaves_0_ADR;
  wire                Wbint_io_busSlaves_0_CYC;
  wire       [3:0]    Wbint_io_busSlaves_0_SEL;
  wire                Wbint_io_busSlaves_0_STB;
  wire                Wbint_io_busSlaves_0_WE;
  wire       [31:0]   Wbint_io_busSlaves_1_DAT_MOSI;
  wire       [31:0]   Wbint_io_busSlaves_1_ADR;
  wire                Wbint_io_busSlaves_1_CYC;
  wire       [3:0]    Wbint_io_busSlaves_1_SEL;
  wire                Wbint_io_busSlaves_1_STB;
  wire                Wbint_io_busSlaves_1_WE;
  wire       [31:0]   Wbint_io_busSlaves_2_DAT_MOSI;
  wire       [31:0]   Wbint_io_busSlaves_2_ADR;
  wire                Wbint_io_busSlaves_2_CYC;
  wire       [3:0]    Wbint_io_busSlaves_2_SEL;
  wire                Wbint_io_busSlaves_2_STB;
  wire                Wbint_io_busSlaves_2_WE;
  wire       [31:0]   Wbint_io_busSlaves_3_DAT_MOSI;
  wire       [31:0]   Wbint_io_busSlaves_3_ADR;
  wire                Wbint_io_busSlaves_3_CYC;
  wire       [3:0]    Wbint_io_busSlaves_3_SEL;
  wire                Wbint_io_busSlaves_3_STB;
  wire                Wbint_io_busSlaves_3_WE;
  wire       [31:0]   Wbint_io_busSlaves_4_DAT_MOSI;
  wire       [31:0]   Wbint_io_busSlaves_4_ADR;
  wire                Wbint_io_busSlaves_4_CYC;
  wire       [3:0]    Wbint_io_busSlaves_4_SEL;
  wire                Wbint_io_busSlaves_4_STB;
  wire                Wbint_io_busSlaves_4_WE;

  picorv32_wb_mapped picorv ( 
    .io_wbm_CYC         (picorv_io_wbm_CYC                     ), //o
    .io_wbm_STB         (picorv_io_wbm_STB                     ), //o
    .io_wbm_ACK         (Wbint_io_busMasters_0_ACK             ), //i
    .io_wbm_WE          (picorv_io_wbm_WE                      ), //o
    .io_wbm_ADR         (picorv_io_wbm_ADR[31:0]               ), //o
    .io_wbm_DAT_MISO    (Wbint_io_busMasters_0_DAT_MISO[31:0]  ), //i
    .io_wbm_DAT_MOSI    (picorv_io_wbm_DAT_MOSI[31:0]          ), //o
    .io_wbm_SEL         (picorv_io_wbm_SEL[3:0]                ), //o
    .io_mem_instr       (picorv_io_mem_instr                   ), //o
    .io_irq             (_zz_1_[31:0]                          ), //i
    .io_eoi             (picorv_io_eoi[31:0]                   ), //o
    .clk                (clk                                   ), //i
    .reset              (reset                                 )  //i
  );
  WishboneROM WBrom ( 
    .io_wb_CYC         (Wbint_io_busSlaves_0_CYC             ), //i
    .io_wb_STB         (Wbint_io_busSlaves_0_STB             ), //i
    .io_wb_ACK         (WBrom_io_wb_ACK                      ), //o
    .io_wb_WE          (Wbint_io_busSlaves_0_WE              ), //i
    .io_wb_ADR         (Wbint_io_busSlaves_0_ADR[31:0]       ), //i
    .io_wb_DAT_MISO    (WBrom_io_wb_DAT_MISO[31:0]           ), //o
    .io_wb_DAT_MOSI    (Wbint_io_busSlaves_0_DAT_MOSI[31:0]  ), //i
    .io_wb_SEL         (Wbint_io_busSlaves_0_SEL[3:0]        ), //i
    .clk               (clk                                  ), //i
    .reset             (reset                                )  //i
  );
  WishboneGpio WBGPIO ( 
    .io_wb_CYC              (Wbint_io_busSlaves_4_CYC             ), //i
    .io_wb_STB              (Wbint_io_busSlaves_4_STB             ), //i
    .io_wb_ACK              (WBGPIO_io_wb_ACK                     ), //o
    .io_wb_WE               (Wbint_io_busSlaves_4_WE              ), //i
    .io_wb_ADR              (Wbint_io_busSlaves_4_ADR[31:0]       ), //i
    .io_wb_DAT_MISO         (WBGPIO_io_wb_DAT_MISO[31:0]          ), //o
    .io_wb_DAT_MOSI         (Wbint_io_busSlaves_4_DAT_MOSI[31:0]  ), //i
    .io_wb_SEL              (Wbint_io_busSlaves_4_SEL[3:0]        ), //i
    .io_gpio_read           (io_gpio_read[1:0]                    ), //i
    .io_gpio_write          (WBGPIO_io_gpio_write[1:0]            ), //o
    .io_gpio_writeEnable    (WBGPIO_io_gpio_writeEnable[1:0]      ), //o
    .clk                    (clk                                  ), //i
    .reset                  (reset                                )  //i
  );
  WishboneTimer WBTimer ( 
    .io_wb_CYC         (Wbint_io_busSlaves_3_CYC             ), //i
    .io_wb_STB         (Wbint_io_busSlaves_3_STB             ), //i
    .io_wb_ACK         (WBTimer_io_wb_ACK                    ), //o
    .io_wb_WE          (Wbint_io_busSlaves_3_WE              ), //i
    .io_wb_ADR         (Wbint_io_busSlaves_3_ADR[31:0]       ), //i
    .io_wb_DAT_MISO    (WBTimer_io_wb_DAT_MISO[31:0]         ), //o
    .io_wb_DAT_MOSI    (Wbint_io_busSlaves_3_DAT_MOSI[31:0]  ), //i
    .io_wb_SEL         (Wbint_io_busSlaves_3_SEL[3:0]        ), //i
    .io_IRQ            (WBTimer_io_IRQ                       ), //o
    .clk               (clk                                  ), //i
    .reset             (reset                                )  //i
  );
  WishboneUart WBUart ( 
    .io_wb_CYC         (Wbint_io_busSlaves_2_CYC             ), //i
    .io_wb_STB         (Wbint_io_busSlaves_2_STB             ), //i
    .io_wb_ACK         (WBUart_io_wb_ACK                     ), //o
    .io_wb_WE          (Wbint_io_busSlaves_2_WE              ), //i
    .io_wb_ADR         (Wbint_io_busSlaves_2_ADR[31:0]       ), //i
    .io_wb_DAT_MISO    (WBUart_io_wb_DAT_MISO[31:0]          ), //o
    .io_wb_DAT_MOSI    (Wbint_io_busSlaves_2_DAT_MOSI[31:0]  ), //i
    .io_wb_SEL         (Wbint_io_busSlaves_2_SEL[3:0]        ), //i
    .io_uart_txd       (WBUart_io_uart_txd                   ), //o
    .io_uart_rxd       (io_uart_rxd                          ), //i
    .clk               (clk                                  ), //i
    .reset             (reset                                )  //i
  );
  WishboneTest WBtest ( 
    .io_wb_CYC         (Wbint_io_busSlaves_1_CYC             ), //i
    .io_wb_STB         (Wbint_io_busSlaves_1_STB             ), //i
    .io_wb_ACK         (WBtest_io_wb_ACK                     ), //o
    .io_wb_WE          (Wbint_io_busSlaves_1_WE              ), //i
    .io_wb_ADR         (Wbint_io_busSlaves_1_ADR[31:0]       ), //i
    .io_wb_DAT_MISO    (WBtest_io_wb_DAT_MISO[31:0]          ), //o
    .io_wb_DAT_MOSI    (Wbint_io_busSlaves_1_DAT_MOSI[31:0]  ), //i
    .io_wb_SEL         (Wbint_io_busSlaves_1_SEL[3:0]        ), //i
    .io_charOut        (WBtest_io_charOut[7:0]               ), //o
    .io_updateOut      (WBtest_io_updateOut                  ), //o
    .clk               (clk                                  ), //i
    .reset             (reset                                )  //i
  );
  WishboneInterconComponent Wbint ( 
    .io_busMasters_0_CYC         (picorv_io_wbm_CYC                     ), //i
    .io_busMasters_0_STB         (picorv_io_wbm_STB                     ), //i
    .io_busMasters_0_ACK         (Wbint_io_busMasters_0_ACK             ), //o
    .io_busMasters_0_WE          (picorv_io_wbm_WE                      ), //i
    .io_busMasters_0_ADR         (picorv_io_wbm_ADR[31:0]               ), //i
    .io_busMasters_0_DAT_MISO    (Wbint_io_busMasters_0_DAT_MISO[31:0]  ), //o
    .io_busMasters_0_DAT_MOSI    (picorv_io_wbm_DAT_MOSI[31:0]          ), //i
    .io_busMasters_0_SEL         (picorv_io_wbm_SEL[3:0]                ), //i
    .io_busSlaves_0_CYC          (Wbint_io_busSlaves_0_CYC              ), //o
    .io_busSlaves_0_STB          (Wbint_io_busSlaves_0_STB              ), //o
    .io_busSlaves_0_ACK          (WBrom_io_wb_ACK                       ), //i
    .io_busSlaves_0_WE           (Wbint_io_busSlaves_0_WE               ), //o
    .io_busSlaves_0_ADR          (Wbint_io_busSlaves_0_ADR[31:0]        ), //o
    .io_busSlaves_0_DAT_MISO     (WBrom_io_wb_DAT_MISO[31:0]            ), //i
    .io_busSlaves_0_DAT_MOSI     (Wbint_io_busSlaves_0_DAT_MOSI[31:0]   ), //o
    .io_busSlaves_0_SEL          (Wbint_io_busSlaves_0_SEL[3:0]         ), //o
    .io_busSlaves_1_CYC          (Wbint_io_busSlaves_1_CYC              ), //o
    .io_busSlaves_1_STB          (Wbint_io_busSlaves_1_STB              ), //o
    .io_busSlaves_1_ACK          (WBtest_io_wb_ACK                      ), //i
    .io_busSlaves_1_WE           (Wbint_io_busSlaves_1_WE               ), //o
    .io_busSlaves_1_ADR          (Wbint_io_busSlaves_1_ADR[31:0]        ), //o
    .io_busSlaves_1_DAT_MISO     (WBtest_io_wb_DAT_MISO[31:0]           ), //i
    .io_busSlaves_1_DAT_MOSI     (Wbint_io_busSlaves_1_DAT_MOSI[31:0]   ), //o
    .io_busSlaves_1_SEL          (Wbint_io_busSlaves_1_SEL[3:0]         ), //o
    .io_busSlaves_2_CYC          (Wbint_io_busSlaves_2_CYC              ), //o
    .io_busSlaves_2_STB          (Wbint_io_busSlaves_2_STB              ), //o
    .io_busSlaves_2_ACK          (WBUart_io_wb_ACK                      ), //i
    .io_busSlaves_2_WE           (Wbint_io_busSlaves_2_WE               ), //o
    .io_busSlaves_2_ADR          (Wbint_io_busSlaves_2_ADR[31:0]        ), //o
    .io_busSlaves_2_DAT_MISO     (WBUart_io_wb_DAT_MISO[31:0]           ), //i
    .io_busSlaves_2_DAT_MOSI     (Wbint_io_busSlaves_2_DAT_MOSI[31:0]   ), //o
    .io_busSlaves_2_SEL          (Wbint_io_busSlaves_2_SEL[3:0]         ), //o
    .io_busSlaves_3_CYC          (Wbint_io_busSlaves_3_CYC              ), //o
    .io_busSlaves_3_STB          (Wbint_io_busSlaves_3_STB              ), //o
    .io_busSlaves_3_ACK          (WBTimer_io_wb_ACK                     ), //i
    .io_busSlaves_3_WE           (Wbint_io_busSlaves_3_WE               ), //o
    .io_busSlaves_3_ADR          (Wbint_io_busSlaves_3_ADR[31:0]        ), //o
    .io_busSlaves_3_DAT_MISO     (WBTimer_io_wb_DAT_MISO[31:0]          ), //i
    .io_busSlaves_3_DAT_MOSI     (Wbint_io_busSlaves_3_DAT_MOSI[31:0]   ), //o
    .io_busSlaves_3_SEL          (Wbint_io_busSlaves_3_SEL[3:0]         ), //o
    .io_busSlaves_4_CYC          (Wbint_io_busSlaves_4_CYC              ), //o
    .io_busSlaves_4_STB          (Wbint_io_busSlaves_4_STB              ), //o
    .io_busSlaves_4_ACK          (WBGPIO_io_wb_ACK                      ), //i
    .io_busSlaves_4_WE           (Wbint_io_busSlaves_4_WE               ), //o
    .io_busSlaves_4_ADR          (Wbint_io_busSlaves_4_ADR[31:0]        ), //o
    .io_busSlaves_4_DAT_MISO     (WBGPIO_io_wb_DAT_MISO[31:0]           ), //i
    .io_busSlaves_4_DAT_MOSI     (Wbint_io_busSlaves_4_DAT_MOSI[31:0]   ), //o
    .io_busSlaves_4_SEL          (Wbint_io_busSlaves_4_SEL[3:0]         ), //o
    .clk                         (clk                                   ), //i
    .reset                       (reset                                 )  //i
  );
  assign _zz_1_ = 32'h0;
  assign io_flag = WBtest_io_updateOut;
  assign io_charOut = WBtest_io_charOut;
  assign io_uart_txd = WBUart_io_uart_txd;
  assign io_gpio_write = WBGPIO_io_gpio_write;
  assign io_gpio_writeEnable = WBGPIO_io_gpio_writeEnable;

endmodule
