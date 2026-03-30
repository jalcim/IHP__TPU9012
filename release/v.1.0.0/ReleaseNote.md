# Release v.1.0.0

## Contenu
- GDS final avec seal ring et fillers (TPU9012.gds)
- Netlist gate-level post-synthese (TPU9012.nl.v)

## Verifications
- DRC : clean (KLayout 0 erreurs, Magic 0 erreurs, 77 etapes LibreLane)
- Timing typ (25C) : setup ws = +2.49 ns
- Timing fast (-40C) : setup ws = +3.37 ns
- Timing slow (125C) : setup ws = -0.095 ns (violation 1.2% de la periode de 8 ns)
- Hold : clean sur les 3 corners (min = +0.132 ns)
- Seal ring : present (etape 63)
- Fillers : inseres (etape 64)

## Changements
- Soumission initiale pour shuttle March-2026
