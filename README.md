# Riesgo y seguro agrícola: el arroz en Colombia

Precio de un seguro agrícola y riesgo de no pagar el crédito para cultivos colombianos, con datos públicos.
Estado: en construcción.

## Motivación

El campo colombiano está expuesto a sequías, inundaciones y a los ciclos de El Niño y La Niña.
Aun así, en 2022 solo cerca del 5% del área sembrada tenía seguro agrícola
([Agronegocios, 2023](https://www.agronegocios.co/agricultura/las-plantaciones-forestales-cana-de-azucar-y-banano-los-cultivos-mas-asegurados-3641557)),
aunque el Estado subsidia hasta el 85% de la prima a los pequeños productores
([El Espectador, 2026](https://www.elespectador.com/economia/finanzas-personales/proteger-al-agro-de-el-nino-estos-son-los-beneficios-del-gobierno-para-los-productores/)).

Este proyecto pregunta: **¿cuánto le cuesta a un arrocero de Casanare no tener seguro?**
Estima la probabilidad de que una mala cosecha deje al productor sin cómo pagar su crédito,
la prima de un seguro que cubra ese riesgo y cuánto baja esa probabilidad cuando el
productor está asegurado.

La productividad agrícola ha sido históricamente una base del desarrollo económico
(Johnston y Mellor, 1961). Vengo de una familia del campo, y el código está pensado para
extender este análisis a otros cultivos.

## Datos

**Rendimientos:** DANE–Fedearroz, [Encuesta Nacional de Arroz Mecanizado (ENAM)](https://www.dane.gov.co/index.php/estadisticas-por-tema/agropecuario/encuesta-de-arroz-mecanizado),
hoja "Históricos", por departamento.

- **Semestral, no anual:** el seguro y el crédito van atados a cada cosecha, y un promedio
  anual puede esconder los semestres malos.
- **Desde 2008-I:** en la serie publicada, los rendimientos del semestre II de 2000 a 2007
  son iguales a los del semestre I del año siguiente en todos los departamentos, así que
  esos años se excluyen (quedan 37 semestres para Casanare).

**Costo de producción:** $6.719.257 por hectárea, arroz secano, zona Llanos, 2025-I
([Fedearroz, costos de producción](https://fedearroz.com.co/es/fondo-nacional-del-arroz/investigaciones-economicas/estadisticas-arroceras/costos/)).
Fedearroz solo publica el costo para la zona Llanos; se usa como aproximación para
Casanare, que concentra la mayor parte del área arrocera de los Llanos.

| Rubro | $ por hectárea |
| --- | ---: |
| Fertilización | 1.733.026 |
| Preparación del suelo y siembra | 1.420.785 |
| Protección del cultivo | 1.256.792 |
| Cosecha y transporte | 1.038.481 |
| Otros | 664.580 |
| Arriendo de la tierra | 558.596 |
| Asistencia técnica | 46.996 |
| Riego | 0 |
| **Total** | **6.719.257** |

**Precio:** $1.352.000 por tonelada de arroz paddy verde, promedio del mercado de Yopal, 2025-I
([Fedearroz, precios del sector arrocero](https://www.fedearroz.com.co/es/fondo-nacional-del-arroz/investigaciones-economicas/estadisticas-arroceras/precios-del-sector-arrocero/)).

### Limitaciones

- **Promedios por departamento:** la ENAM no tiene datos por finca. Las pérdidas de unas
  fincas se compensan con las de otras, así que una finca sola tiene más riesgo del que
  muestran estos datos.
- **Serie corta:** 37 semestres, de 2008-I a 2026-I. Los datos anteriores se excluyeron
  porque no son confiables (ver arriba).
- **Pocos semestres malos:** frente a su tendencia, ningún semestre cae por debajo del 80%,
  uno cae por debajo del 85% (2011-II) y tres por debajo del 90%. Con tan pocos casos, la
  historia sola no alcanza para estimar la probabilidad de pérdida, y por eso se complementa
  con un modelo de simulación.
- **Las pérdidas vienen en racha:** los tres peores semestres (2011-II, 2012-I y 2013-II)
  son seguidos, así que no se puede suponer, sin revisarlo, que cada semestre es
  independiente del anterior.

## Referencias

- Johnston, B. F., y Mellor, J. W. (1961). The Role of Agriculture in Economic Development.
  *The American Economic Review*, 51(4), 566–593.
