# Release v.1.0.0

## Contenu
- GDS final avec seal ring et fillers (chip_top.gds)
- Netlist gate-level post-synthese (chip_top.nl.v)

## Verifications
- DRC : clean (KLayout 0 erreurs, Magic 0 erreurs, 77 etapes LibreLane)
- Timing typ (25C) : setup ws = +2.49 ns
- Timing fast (-40C) : setup ws = +3.37 ns
- Timing slow (125C) : setup ws = -0.138 ns (violation 1.7% de la periode de 8 ns)
- Hold : clean sur les 3 corners (min = +0.128 ns)
- Seal ring : present (etape 63)
- Fillers : inseres (etape 64)

## Changements
- Soumission initiale pour shuttle March-2026
