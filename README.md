# TPU9012 — TensorCore Convolution Accelerator

Accelerateur materiel de convolution 3x3 sur flux serie pour inference CNN.
Technologie IHP SG13G2 130nm.

## Caracteristiques

- Convolution 3x3 sur flux serie (28 pixels/ligne, MNIST)
- 8 bits par pixel, kernel configurable
- Frequence cible : 125 MHz
- Die : 1200x1200 um, core : 470x470 um
- 28 pads IO (clk, rst_n, 8x data_in, kernel_we, 8x result, alive, 6x power)
- Logo Nebula integre comme macro decorative

## Structure

- `doc/` : metadonnees et documentation
- `TPU9012-main/` : sources RTL, contraintes, resultats PnR
- `dependencies/` : bondpad_70x70_novias, logo_nebula
- `release/v.1.0.0/` : GDS et netlist finaux

## Outils

- Synthese : Yosys
- Place & Route : OpenROAD
- Flow : LibreLane
- DRC : KLayout + Magic
