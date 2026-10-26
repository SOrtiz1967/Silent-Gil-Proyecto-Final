# Silent Gil: historia

Este es el borrador de la historia con lo que ya está hecho en el juego. Lo marcado con **[?]** todavía hay que decidirlo.

## Cómo está armado hoy

El recorrido que se puede jugar es este (las llaves y quién las da están en el README):

```
nivel_1 (estación + plaza) -> nivel_mc (McDonald's, 2 pisos) -> nivel_1 (reja del subte)
-> nivel_5 (subte Línea C) -> nivel_6 (la estación que no existe) -> nivel_7 (la casa)
```

Cambios respecto del borrador anterior:
- La llave del parque (`llaveMc`) abre directo el McDonald's. La comisaría (`nivel_3` y `nivel_3_celda`) está modelada pero todavía no está conectada a la plaza. **[?]** decidir si se conecta o se saca.
- El Cliente suelta la `llaveSubte` al morir. Es un enemigo grande, sin ataques especiales todavía.
- El powerbank está en la oficina del segundo piso del Mc y no dispara a los bichos de la cocina todavía.
- El celular tiene una llamada perdida de «Casa» a las 3:07. Se avisa en la estación y se vuelve a ver en la casa.
- Cada nivel deja una nota firmada a las 3:07 por alguien que pasó antes («no agarren las hamburguesas», «se quedan quietos mientras no los alumbrás», «el guarda quiere que te quedes»). Así la historia se cuenta sin gente.
- En el Mc hay un ticket del pedido 307 que nunca se entregó. **[?]** darlo como alternativa a la pelea con el Cliente.

---

Estado: borrador para discutir. Lo que está marcado con **[?]** todavía hay que decidirlo.

## En una frase

Alguien se duerme en el último tren y se despierta en Constitución a las 3 de la mañana, con el celular casi muerto. No hay nadie más. Quiere volver a su casa, y el único camino es el subte.

## Tono

- Realista y social de base: estación vacía de noche, fisuras, un local de comidas rápidas cerrado, la oscuridad.
- Lo sobrenatural entra de a poco y nunca se explica del todo.
- Como en Silent Hill, **no hay gente normal**. Ningún civil, ningún NPC con quien hablar. Lo único que queda de las personas son sus cosas: carteles, notas, una campera en un banco, un llavero. La historia se cuenta con lo que dejaron.
- Los fisuras no son "gente": son el peligro del lugar. Lo que no se aclara es si alguna vez lo fueron.

## Protagonista

- Una persona común que volvió tarde, sin poderes. Quiere una sola cosa: llegar a su casa.
- Lo que tiene: un celular con poca batería que hace de linterna, y piedras para tirar.
- **[?]** Nombre y género. Si el jugador nunca lo escucha, puede quedar sin nombre.

## Lo raro que se repite: las 3:07

El reloj de la estación está clavado en las 3:07. Después, la hora en el celular también. Nunca amanece: el cielo y la luz no cambian en ningún nivel. El tren que lo dejó se va despacio y no vuelve.

## El camino: por qué el orden es ese

Es la lógica clásica de Silent Hill: el objetivo se ve desde el principio, pero está cerrado, y hay que ir a buscar lo que lo abre.

**El objetivo:** el subte Línea C. Constitución es la cabecera, así que la boca está en la plaza, a la vista.

**Por qué no puede ir directo al subte:**
- La reja de la boca del subte está baja y cerrada con un candado grande. Se puede forzar con la ganzúa, pero el candado no cede. **[?]** Alternativa: no se abre con ganzúa porque es una cerradura de seguridad y necesita la llave.
- Un cartel pegado en la reja, con letra de oficina, dice algo como: *"Cerrado por obras. Llaves en custodia del local de la esquina."* No dice cuál. El único local de la esquina es el McDonald's.

**Por qué no puede irse por la calle:**
- Las avenidas que salen de la plaza están tapadas por una niebla densa. Si el protagonista se mete, vuelve a aparecer en la plaza. Es la primera señal clara de que algo no es normal.
- No hay colectivos ni taxis. El subte es la única opción.

**Por qué tiene que pasar por el McDonald's:**
1. **La llave del candado del subte** la tiene el Cliente, que es el custodio. El candado no se fuerza con la ganzúa, solo abre con esa llave.
2. **La powerbank** está en el depósito o la oficina del segundo piso. El subte es el nivel más oscuro del juego y no tiene puntos de carga, así que sin la powerbank el celular se muere adentro.
3. Al Mc se llega pasando por la comisaría, y la llave de la comisaría está escondida en el parque. Eso justifica la búsqueda en la plaza.

**La trampa del orden:** la pelea con el Cliente es obligatoria para conseguir la llave, pero la powerbank es opcional en esa primera visita. El jugador puede derrotar al Cliente, agarrar la llave y bajar al subte sin pasar por el depósito. No pasa nada al principio, pero la batería se gasta, se apaga el celular y el subte se queda en negro. Ahí tiene que volver al Mc a buscar la powerbank, que es el único modo de seguir. Si la agarró antes, el subte se cruza con el celular cargado.

## La cadena completa

```
Estación: SUBE con saldo -> molinetes -> plaza
Plaza:    llave en el parque -> comisaría
Comisaría: arma más poderosa -> McDonald's
Mc:       Cliente (piso 1) -> llave del candado
Mc:       depósito / oficina (piso 2) -> powerbank -> enemigo molesto
Plaza:    llave del candado -> reja del subte
Subte:    andenes y túneles con el celular cargado -> puerta de servicio
Estación que no existe: puzzles con la luz -> Guarda -> salida
Casa:     el reloj marca 3:07
```

## Niveles

La dificultad sube de a poco y cada nivel enseña algo nuevo antes de pedirlo.

| # | Nivel | Qué aprende el jugador | Amenaza | Qué se siente |
|---|-------|------------------------|---------|---------------|
| 1 | Estación Constitución | Moverse, linterna, batería, cargar el celular, ganzúa | Casi ninguna: oscuridad y batería | Soledad, algo está mal |
| 2 | Plaza | Combate (golpes y piedras), curarse, buscar la llave | Fisuras agresivos | Peligro real |
| 3 | Comisaría | Explorar un interior, conseguir el arma más poderosa | Fisuras, un poco más duros | Alivio y tensión |
| 4 | McDonald's | Explorar dos pisos con objetivo, pelea de boss | El Cliente, bichos de la cocina | Lo raro se vuelve evidente |
| 5 | Subte Línea C: andenes y túneles | Moverse casi a ciegas, gestionar batería al límite | Fisuras pálidos y más fuertes | Claustrofobia |
| 6 | La estación que no existe | Resolver puzzles, jugar con la luz, pelea de boss | El Guarda | Irrealidad |
| 7 | La casa | Cierre | Ninguna | Final |

### Nivel 1: Estación Constitución

- El protagonista baja del tren sin SUBE. Con 10% de batería, el celular se le apaga en poco tiempo.
- Aprende a cargarlo en los puntos de carga de la estación.
- Encuentra una SUBE con saldo (tirada cerca de los molinetes, o en un lugar cerrado que se abre con la ganzúa). La usa para pasar. **[?]** Quién la dejó ahí. Puede tener un nombre escrito en un sticker, y eso podría volver en el final.
- Apenas pasa los molinetes, un cartel le avisa de los fisuras y de que el kiosco tiene provisiones.
- El tren se va despacio y no vuelve.

### Nivel 2: Plaza

- Es el paso obligado. Hay fisuras, bancos rotos, farolas que parpadean y el refugio.
- Se ve la boca del subte, con la reja baja y el cartel de las llaves.
- Intenta salir por las avenidas y la niebla lo devuelve.
- La llave de la comisaría está escondida en el parque. Buscarla es el objetivo del nivel.

### Nivel 3: la comisaría (entre el parque y el Mc)

- La llave del parque abre la comisaría, no el Mc. Desde la comisaría se llega al Mc.
- Está abandonada y a oscuras, como todo lo demás. No hay policías ni detenidos: solo lo que quedó.
- Ahí se consigue el **arma más poderosa** del juego, en el depósito de evidencia. Hay un motivo para necesitarla: un cartel o una nota en la guardia avisa que el Mc "está lleno de lo que ya sabés" y que no se entra solo con piedras.
- Es un nivel corto y de exploración, con fisuras un poco más duros que los de la plaza, para que el arma nueva se note.
- Lugares posibles: mesa de entradas, oficinas, calabozos y el depósito de evidencia (con una puerta cerrada que sirve para usar la ganzúa).
- Lore con objetos: el libro de guardia con todas las entradas a las 3:07, un calabozo con la puerta abierta desde adentro y un cartel de "Se busca" con la cara borrada.
- **Arma: la pistola de bengalas.** Dispara a distancia, hace más daño que las piedras y ilumina la zona, así que encaja con la batería del celular. **[?]** Hay que decidir cuántas bengalas hay (munición limitada para que cada tiro importe) y cuánto dura la luz.

#### Subnivel: la celda

- Cuando el jugador entra a los calabozos, la puerta se cierra sola detrás de él (el libro de guardia marca las 3:07 en esa hoja). Queda encerrado en una celda, a oscuras.
- La batería sigue gastándose, así que hay presión de tiempo: no puede quedarse a pensar.
- **Cómo escapa (propuesta):**
  1. Con la linterna encuentra una ganzúa escondida bajo el colchón. Pero la cerradura de la celda está del lado de afuera, y no llega.
  2. En la pared de atrás hay una rejilla de ventilación sujeta con pernos. Los saca con el minijuego de pernos que ya existe.
  3. Se arrastra por el conducto y sale en el depósito de evidencia, donde está la pistola de bengalas. El arma se consigue como premio por escapar, no se encuentra tirada.
- Mientras trabaja, los fisuras se acercan a los barrotes de la celda desde el pasillo. Si la linterna está prendida, los atrae. Eso le da riesgo a la escena sin sumar otra mecánica.
- Es corto: una sola sala y un conducto.

### Nivel 4: McDonald's

- Dos pisos, mesas, mostrador, baños, cocina y la oficina de arriba con la powerbank.
- Está vacío. No hay empleados ni clientes. Sobre las mesas hay bandejas, vasos y comida que no se pudre.
- El parlante repite siempre el mismo número de pedido: el 307.
- En el primer piso hay una figura sentada comiendo, sola, rodeada de envoltorios.
- En el segundo piso, en el depósito o la oficina, está la powerbank.

**El Cliente (boss, primer piso)**
- Es una figura que alguna vez fue una persona, sin que se sepa cuál. **[?]** Puede llevar puesto un uniforme de empleado o ropa de oficina, para dejar la duda.
- Es el custodio de la llave del candado del subte. Nadie le dijo por qué la tiene, y en el juego tampoco se explica.
- Si el jugador se le acerca a pedirle la llave, se enoja: no lo dejan comer en paz. Ahí empieza la pelea.
- Espera un pedido que nunca llega, y por eso come lo que encuentra.
- Las hamburguesas del nivel, las que curan al jugador, son suyas. **[?]** Si el jugador las agarra, el Cliente se enfurece más.
- Ataques simples: tira comida, carga contra el jugador, golpea la mesa.
- Al derrotarlo suelta la llave. Después de eso, el parlante deja de repetir el 307.

**La powerbank y el enemigo molesto (piso 2)**
- Agarrar la powerbank activa un enemigo que aparece de golpe y persigue al jugador hasta que sale del Mc. No es un boss, es un susto y una molestia.
- El enemigo son **los bichos de la cocina**: chicos, rápidos, en grupo y con poca vida. Salen de golpe, te sacan vida de a poco y molestan más de lo que matan.
- Si el jugador vuelve por la powerbank después de haber bajado al subte, el Cliente ya no está, pero este enemigo sí aparece.

### Nivel 5: Subte Línea C (andenes y túneles)

Tono: combate y supervivencia, en la oscuridad.

- Con la llave abre el candado y baja.
- Los enemigos son una **variante nueva de fisuras**, distinta a los de la plaza: más pálidos, se mueven por el piso y las paredes, y se quedan quietos mientras no los alumbres. La linterna cambia cómo se juega acá.
- Son **más fuertes** que los de la plaza: aguantan dos golpes más y pegan un poco más fuerte. Con los números actuales, los de la plaza tienen vida 6 y daño 1 (mueren con 2 golpes). Los del subte tendrían vida 12 (4 golpes) y daño 1.5.
- Es el nivel más oscuro y no tiene puntos de carga. Con la powerbank el celular aguanta. Sin ella, la batería se gasta, el celular se apaga y el jugador queda a oscuras: tiene que volver al Mc a buscarla al depósito.
- **[?]** Cuando el celular se apaga, se ve apenas una luz tenue en la entrada, para que el jugador entienda que tiene que volver y no sienta que el juego se rompió.
- Hay que cruzar los andenes y los túneles hasta una puerta de servicio que lleva al nivel siguiente.
- Primeras señales raras: un tren que pasa sin nadie, carteles con el nombre cambiado.

### Nivel 6: La estación que no existe

Tono: exploración y puzzles, con lo sobrenatural a la vista. Pocos combates, hay que pensar.

- Es una estación que no está en ningún mapa. El cartel dice "Constitución" aunque el jugador ya salió de ahí. Los relojes marcan las 3:07.
- Las salas no cierran: una puerta lleva a la misma sala, y el túnel largo hace que el jugador reaparezca al principio.
- **Puzzle de la luz (propuesta):** el túnel solo cambia, y deja pasar, cuando el jugador apaga la linterna y camina a oscuras. Se conecta con la mecánica del Guarda y es barato de programar (es una teletransportación según la linterna).
- **Puzzles de objetos:** una puerta con cerradura (ganzúa), una rejilla con pernos y notas sobre quién se quedó acá antes. Se usan las mecánicas que ya existen.
- **[?]** La SUBE vuelve a servir: el molinete de esta estación es el único que se abre con ella, y es la única salida.
- Pocos fisuras, pero los pálidos aparecen donde la luz está prendida.
- Termina en el andén final, donde espera el Guarda.

**El Guarda (boss, andén final)**
- Es el guarda del último tren, el que lo dejó en Constitución y no lo despertó. Quiere que se quede.
- Se lo siente antes de verlo: un silbato lejano y pasos en el andén.
- Su frase repetida: *"Última estación. Todos bajan."*
- Mecánica: reacciona a la luz del celular. Si la linterna está prendida, el Guarda lo ve de lejos y lo persigue. Si está apagada, no lo ve, pero el jugador tampoco. Eso lo vuelve una pelea distinta a la del Cliente, sin necesidad de programar mucho más.
- Al derrotarlo se abre la salida del subte hacia la calle.

### Nivel 7: La casa

- Es el nivel más corto, de cierre. Llega a su casa, todo parece normal, y el reloj de la cocina marca 3:07. No hay nadie.

## El final: ambiguo

**Elegido: la casa está, pero...** Llega y todo parece normal, pero el reloj de la cocina marca 3:07 y no hay nadie. No se explica nada más.

Descartados: *el tren otra vez* (abre la puerta y se despierta en el tren que entra a Constitución) y *nadie lo ve* (llega y no hay modo de saber si está vivo o no).

## Cosas del juego que ya existen y que conectan con la historia

- **Batería del celular:** presión de tiempo, y razón para la powerbank.
- **Provisiones del kiosco y del Mc:** son los curas.
- **Carteles legibles:** cuentan el lore sin cinemáticas ni diálogos.
- **Ganzúa y llaves:** ya hay mecánicas para las puertas cerradas.

## Para decidir

Ya decidido:
- Siete niveles (estación, plaza, comisaría, Mc, subte, estación que no existe y casa) y dos bosses (el Cliente y el Guarda).
- Los fisuras del subte tienen vida 12 y daño 1.5.
- La comisaría tiene un subnivel: queda encerrado en una celda y escapa sacando los pernos de una rejilla de ventilación.
- El nivel intermedio es la comisaría, y ahí se consigue la pistola de bengalas.
- El candado solo abre con la llave. El Cliente es el custodio de la llave.
- La powerbank está en el depósito o la oficina del segundo piso. Al agarrarla aparecen los bichos de la cocina.
- El Guarda reacciona a la luz del celular.
- Los fisuras del subte son una variante nueva: pálidos, quietos mientras no los alumbres y más fuertes que los de la plaza.
- Final: **la casa está, pero...** El reloj de la cocina marca 3:07 y no hay nadie.
- El docente no pidió nada específico.

Falta:
1. Munición de la pistola de bengalas y cuánto dura la luz.
2. Nombre y género del protagonista (por ahora se deja sin decidir).
