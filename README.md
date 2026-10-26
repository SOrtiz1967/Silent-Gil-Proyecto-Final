# Silent Gil

Juego 2D hecho en Godot 4 para el proyecto final. Te dormís en el último tren, te despertás en Constitución a las 3 de la mañana con el celular casi muerto y lo único que querés es volver a tu casa. No hay nadie más: la historia se cuenta con los carteles y las cosas que dejaron.

La historia completa está en [docs/historia.md](docs/historia.md).

## Controles

| Tecla | Qué hace |
|---|---|
| WASD / flechas | moverse |
| Espacio | golpear |
| E | tirar piedras |
| F | agarrar, abrir, leer, cargar el celular |
| T | inventario |
| Q | apagar o prender la linterna del celular |
| H | ayuda con todos los controles |
| Esc | pausa |

## Ayuda dentro del juego

- Arriba a la derecha siempre se muestra el **objetivo** del momento y hacia dónde queda (se actualiza solo según las llaves que tengas).
- Al entrar a cada nivel por primera vez sale un texto con la historia y qué hacer.
- **H** muestra todos los controles.

## Recorrido

| Nivel | Escena | Qué hay |
|---|---|---|
| 1 | `nivel_1` | estación y plaza. Se busca la SUBE, se pasan los molinetes y se busca la llave del McDonald's |
| 2 | `nivel_mc` | McDonald's de dos pisos. El Cliente tiene la llave del subte y el powerbank está en la oficina de arriba |
| 3 | `nivel_5` | subte Línea C, con fisuras pálidos que aguantan más |
| 4 | `nivel_6` | la estación que no existe, con puertas que vuelven y un túnel que solo se cruza a oscuras. Se sale con la SUBE y el silbato del Guarda |
| 5 | `nivel_7` | la casa |
| opcional | `nivel_3`, `nivel_3_celda` | comisaría (la puerta está en la plaza, abajo a la derecha) y celda. Ahí está la pistola de bengalas |

### Llaves

| Llave | Dónde está | Qué abre |
|---|---|---|
| `sube` | tirada en la estación | los molinetes, y más adelante la salida de la estación que no existe |
| `llaveMc` | en la plaza | la puerta del McDonald's |
| `llaveSubte` | la suelta el Cliente | la reja del subte, en la plaza |
| `powerbank` | oficina del segundo piso del Mc | no se gasta más la batería del celular |
| `silbato` | lo suelta el Guarda | junto con la SUBE, el molinete de salida de la estación que no existe |
| pistola de bengalas | depósito de evidencia de la comisaría (se llega escapando de la celda) | se dispara con E y pega más que las piedras. Las bengalas son pocas |
| ganzúas | colchón de la celda, sala de objetos de la estación que no existe | forzar cerraduras con el minijuego |

## Mecánicas que cambian entre niveles

- **Luz:** en el subte y en la estación que no existe los fisuras pálidos y el Guarda solo se mueven si tenés la linterna del celular prendida (Q). Sin luz no te ven, pero vos tampoco los ves. Sin powerbank la batería se acaba: en ese caso hay que subir de nuevo al Mc a buscarlo.
- **Niebla:** en la plaza, si te vas por las avenidas, la niebla te devuelve al centro.
- **Estación que no existe:** las puertas falsas de las tres salas te devuelven a la misma sala. El túnel largo te manda al principio, salvo que lo cruces con la linterna apagada.
- **Celda:** al entrar a los calabozos quedás encerrado. Se sale sacando los pernos de la rejilla del fondo y arrastrándose por el conducto hasta el depósito.
- **Mc:** cuando agarrás el powerbank salen los bichos de la cocina y te persiguen.

## Cómo está organizado

- `escenas/`: un `.tscn` por nivel y las piezas que se reutilizan (`cartel`, `objetoClave`, `puerta`, `entradaNivel`, `enemigo`, `powerbank`).
- `scripts/`: un script por escena. `CambioNivel` (autoload) lleva al jugador de un nivel a otro y lo deja en el punto de destino.
- `pathfinding.gd`: arma una grilla con las colisiones del nivel y los enemigos la usan para rodear paredes y puertas en vez de chocarse. Si un nivel no tiene el nodo `Pathfinding`, persiguen en línea recta.
