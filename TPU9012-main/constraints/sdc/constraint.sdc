set_units -time ns -resistance kOhm -capacitance pF -voltage V -current uA

# Design constraints
set_max_fanout 6 [current_design]
set_max_capacitance 0.5 [current_design]
set_max_transition 1.5 [current_design]

# Clock
set clock_period 8.0
create_clock [get_pins clk_pad/p2c] -name clk -period $clock_period -waveform "0 [expr {$clock_period / 2}]"
set_propagated_clock [all_clocks]
set_clock_uncertainty 0.15 [get_clocks clk]
set_clock_transition 0.25 [get_clocks clk]

# Timing derate (OCV 5%)
set_timing_derate -early 0.95
set_timing_derate -late 1.05

# Driving cells
set input_ports [get_ports {rst_n_PAD kernel_we_PAD data_in_PAD[*]}]
set_driving_cell -lib_cell sg13g2_IOPadIn -pin pad $input_ports

set output_ports [get_ports {result_PAD[*]}]

# Input delays - data (30% de la période)
set data_ports [get_ports {kernel_we_PAD data_in_PAD[*]}]
set_input_delay -max [expr {$clock_period * 0.30}] -clock clk $data_ports
set_input_delay -min 0 -clock clk $data_ports

# Input delays - reset (10% de la période)
set_input_delay -max [expr {$clock_period * 0.10}] -clock clk [get_ports rst_n_PAD]
set_input_delay -min 0 -clock clk [get_ports rst_n_PAD]

# Output delays (30% de la période)
set_output_delay [expr {$clock_period * 0.30}] -clock clk $output_ports

# Load (outputs seulement)
# IOPadOut30mA max_capacitance = 2.63 pF
set_load -pin_load 2.6 [all_outputs]

# Alive pad : sortie constante, pas de timing
set_false_path -to [get_ports alive_PAD]

# IO pads : relâcher les contraintes au niveau PDK (max_transition 200ns, max_cap 500pF)
set io_ports [get_ports {rst_n_PAD kernel_we_PAD data_in_PAD[*] clk_PAD result_PAD[*] alive_PAD}]
set_max_transition 200 $io_ports
set_max_capacitance 500 $io_ports
