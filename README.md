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
| Esc | pausa |

## Recorrido

| Nivel | Escena | Qué hay |
|---|---|---|
| 1 | `nivel_1` | estación y plaza. Se busca la SUBE, se pasan los molinetes y se busca la llave del McDonald's |
| 2 | `nivel_mc` | McDonald's de dos pisos. El Cliente tiene la llave del subte y el powerbank está en la oficina de arriba |
| 3 | `nivel_5` | subte Línea C, con fisuras pálidos que aguantan más |
| 4 | `nivel_6` | la estación que no existe. Se sale con la SUBE, después de pasar por el Guarda |
| 5 | `nivel_7` | la casa |
| aparte | `nivel_3`, `nivel_3_celda` | comisaría y celda, modeladas y sin conectar todavía |

### Llaves

| Llave | Dónde está | Qué abre |
|---|---|---|
| `sube` | tirada en la estación | los molinetes, y más adelante la salida de la estación que no existe |
| `llaveMc` | en la plaza | la puerta del McDonald's |
| `llaveSubte` | la suelta el Cliente | la reja del subte, en la plaza |
| `powerbank` | oficina del segundo piso del Mc | no se gasta más la batería del celular |
| ganzúas | colchón de la celda, sala de objetos de la estación que no existe | forzar cerraduras con el minijuego |

## Cómo está organizado

- `escenas/`: un `.tscn` por nivel y las piezas que se reutilizan (`cartel`, `objetoClave`, `puerta`, `entradaNivel`, `enemigo`, `powerbank`).
- `scripts/`: un script por escena. `CambioNivel` (autoload) lleva al jugador de un nivel a otro y lo deja en el punto de destino.
- `pathfinding.gd`: arma una grilla con las colisiones del nivel y los enemigos la usan para rodear paredes y puertas en vez de chocarse. Si un nivel no tiene el nodo `Pathfinding`, persiguen en línea recta.
