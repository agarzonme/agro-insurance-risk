# Agricultural Insurance Risk: Colombian Rice

Agricultural insurance pricing and default risk for Colombian crops using public data.
Status: work in progress.

## Motivation

Farming in Colombia is exposed to droughts, floods and El Niño/La Niña cycles, yet only
about 5% of the planted area had agricultural insurance in 2022
([Agronegocios, 2023](https://www.agronegocios.co/agricultura/las-plantaciones-forestales-cana-de-azucar-y-banano-los-cultivos-mas-asegurados-3641557)),
even though the government subsidizes up to 85% of the premium for small producers
([El Espectador, 2026](https://www.elespectador.com/economia/finanzas-personales/proteger-al-agro-de-el-nino-estos-son-los-beneficios-del-gobierno-para-los-productores/)).

This project asks: **how much does it cost a rice farmer in Casanare not to be insured?**
It estimates the probability that a bad harvest leaves the farmer unable to repay a crop
loan, the premium of an insurance that covers that risk, and how much the probability
falls when the farmer is insured.

Agricultural productivity has historically supported economic development
(Johnston & Mellor, 1961). My family comes from a farming background, and the code is
designed to extend this analysis to other crops.

## Data

**Yields:** DANE–Fedearroz, [Encuesta Nacional de Arroz Mecanizado (ENAM)](https://www.dane.gov.co/index.php/estadisticas-por-tema/agropecuario/encuesta-de-arroz-mecanizado),
sheet "Históricos", by department.

- **Semiannual, not annual:** insurance and credit are tied to each harvest, and annual
  averages can hide bad semesters.
- **From 2008-I:** in the published series, semester II yields for 2000–2007 match the
  following year's semester I yields in every department, so earlier data is excluded
  (37 semesters for Casanare).

**Production cost:** COP 6,719,257 per hectare, rainfed rice, Llanos zone, 2025-I
(source: [(https://fedearroz.com.co/es/fondo-nacional-del-arroz/investigaciones-economicas/estadisticas-arroceras/costos/]). Cost is only published for the Llanos zone; it is used as a proxy
for Casanare, which accounts for most of the rice area in the Llanos.

| Item | COP per hectare |
| --- | ---: |
| Fertilization | 1,733,026 |
| Land preparation and sowing | 1,420,785 |
| Crop protection | 1,256,792 |
| Harvesting and transport | 1,038,481 |
| Other | 664,580 |
| Land rent | 558,596 |
| Technical assistance | 46,996 |
| Irrigation | 0 |
| **Total** | **6,719,257** |

**Price:** COP 1,352,000 per tonne of green paddy rice, Yopal market average, 2025-I
(source: [add source]).

## References

- Johnston, B. F., & Mellor, J. W. (1961). The Role of Agriculture in Economic Development.
  *The American Economic Review*, 51(4), 566–593.
