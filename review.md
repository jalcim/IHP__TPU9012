# Review IHP__TPU9012

## CRITIQUE

- [x] **top_cell_name = chip_top vs TPU9012** — Renomme via KLayout (GDS) + sed (SPICE). Top cell = TPU9012 partout.
- [x] **sealring_x/y : 1200 vs 1.2** — LNA7096 utilise 1750/2950 (um). LDO6259 utilise 1470/880 (um). Notre 1200/1200 est en um, c'est correct.
- [x] **LICENCE.md manquant** — Ajoute : LICENSE (CERN-OHL-S-2.0, 289 lignes).

## IMPORTANT

*(pdk_version et repository : a remplir apres push GitHub)*
- [x] **process: SG13G2** — Reponse IHP : SG13CMOS et SG13G2 acceptes, futurs runs = SG13G2 ou SG13CMOS5L uniquement. Mis a SG13G2.
