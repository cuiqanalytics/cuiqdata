# cuiqData: Orquestación SQL Rápida y Local

**[Read in English →](README.md)**

## Instalación

**Descarga** los ejecutables o instaladores para tu plataforma desde [Releases](https://github.com/cuiqanalytics/cuiqdata/releases) y sigue las instrucciones indicadas ahí.

---

## Elige Tu Camino

### 📊 Opción A: Usuarios principiantes

Aprende pipelines de datos con SQL simple. Crea archivos SQL numerados, sin configuración.

**Paso 1: Crea tu proyecto**

Elige un directorio para tu proyecto y crea la siguiente estructura de directorios:

```
my_project
├── data
├── output
└── sql
```

**Paso 2: Crea archivos SQL (usa cualquier editor de texto: Notepad, Notepad++, VSCode, Sublime, etc.)**

Genera los siguientes archivos con extensión `.sql` (muy importante) y guárdalos en la carpeta `sql`:

`sql/001_ingest.sql`:
```sql
-- Nota: Las líneas que parten con "--" son comentarios y son ignorados al procesar el archivo

-- Carga datos desde un archivo CSV
SELECT * FROM 'data/input.csv'
```

`sql/002_transform.sql`:
```sql
-- Transformación simple: filtro y conteo
SELECT 
  category,
  COUNT(*) as total_registros,
  ROUND(AVG(amount), 2) as promedio_cantidad
FROM raw_data
WHERE amount > 0
GROUP BY category
ORDER BY total_registros DESC
```

`sql/003_export.sql`:
```sql
-- Exporta resultados finales
SELECT * FROM transformed_data
```

**Segundo: Abre un Terminal**

**macOS**:
1. Press `Cmd + Space` to open Spotlight
2. Type `terminal` and press Enter
3. A Terminal window opens

**Windows**:
1. Press `Win + R` to open Run dialog
2. Type `cmd` and press Enter
3. A Command Prompt window opens (or use PowerShell)


**Paso 3: Ejecuta tu pipeline**
```bash
cuiqdata run ./sql
```

¡Eso es! Tus archivos SQL se ejecutan en orden (001 → 002 → 003), y los resultados se almacenan en un cache para re-ejecuciones rápidas.

**Modifica y re-ejecuta**:
- Abre cualquier archivo SQL en tu editor
- Cambia la consulta
- Ejecuta `cuiqdata run ./sql` de nuevo

¿Cómo seguir? Mira los [tutoriales](tutorials/es)

---

### 🚀 Opción B: Para Ingenieros de Datos (SQL o TOML)

**Para ingenieros experimentados**: Usa el estilo que mejor se ajuste a tu flujo de trabajo.

#### Opción B1: SQL-First (SQL Puro, Configuración Mínima)

```bash
cd mi_proyecto

# Crea archivos SQL numerados
mkdir -p sql
cat > sql/001_ingest.sql << 'EOF'
-- Carga datos crudos desde CSV
SELECT * FROM read_csv_auto('data/sales.csv')
EOF

cat > sql/002_transform.sql << 'EOF'
-- Agregación mensual (sintaxis DuckDB)
SELECT 
  DATE_TRUNC('month', order_date) as mes,
  SUM(amount) as ingresos,
  COUNT(*) as cantidad_ordenes
FROM raw_data
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY mes DESC
EOF

cat > sql/003_sink.sql << 'EOF'
-- Exporta resultados
SELECT * FROM transformed_data
EOF

# Ejecuta el pipeline
cuiqdata run ./sql
```

**¿Por qué este enfoque?**
- Directo: Sin capa de traducción entre tú y DuckDB
- Rápido de iterar: Edita SQL, ejecuta
- Overhead mínimo: Un archivo = un paso
- Caché: Solo los pasos que cambias se re-ejecutan

#### Opción B2: TOML + SQL (Configuración Avanzada)

```bash
cuiq init my_project
cd my_project
cuiqdata run .
```

Usa `pipeline.toml` cuando necesites:
- Ingesta de múltiples fuentes
- Reglas de validación complejas
- Variables de plantilla (fechas, rutas, etc.)
- Características de colaboración en equipo

```bash
cuiqdata init mi_proyecto
cd mi_proyecto

# Edita pipeline.toml para características avanzadas
nano pipeline.toml
```

---

## Características

- **Local-first**: Sin infraestructura. DuckDB + SQLite, todo local.
- **Rapidísimo**: Caché a nivel de paso entrega aceleros de 100x en re-ejecuciones.
- **SQL + Config**: Escribe SQL de DuckDB directamente (sin YAML o DSLs de Python).
- **Sin dependencias**: Binario único. Sin Python, Node, Rust.
- **Logs inmutables**: Historial de ejecución con event-sourcing para reproducibilidad.

---

## Tareas Comunes

**Ve qué cambió entre ejecuciones**:
```bash
cuiqdata report ./sql
# Genera: execution_report.html (timings de pasos, info de caché, cantidad de filas)
```

**Valida antes de ejecutar**:
```bash
cuiqdata test pipeline.toml
# Comprueba sintaxis, valida referencias de tablas, detecta errores temprano
```

**Aprende con ejemplos**:
```bash
# Tutorial interactivo integrado
cuiqdata tutorial

# Ve toda la documentación
cuiqdata docs

# Consulta tópicos específicos
cuiqdata docs config
cuiqdata docs steps
cuiqdata docs templating
```

---

## Cuándo Usar Cada Opción

| Aspecto | Opción A (Principiantes) | Opción B1 (SQL-Only) | Opción B2 (TOML) |
|---------|----------|-----------|------------|
| **Mejor para** | Aprender lo básico | Iteración rápida, pipelines simples | Flujos complejos, características avanzadas |
| **Tiempo de setup** | ~60 seg | ~30 seg | ~60 seg |
| **Modificación** | Edita archivos .sql | Edita archivos .sql | Edita configuración .toml |
| **Curva de aprendizaje** | Introducción suave | Mínima si sabes SQL | Necesita conocimiento de TOML |
| **Escalabilidad** | Hasta complejidad media | Directa para cualquier tamaño | Mejor para orquestación compleja |

**Flujo de Caminos**: La mayoría de usuarios comienzan con **Opción A**, se mueven a **Opción B1** (SQL-First) conforme crecen, luego agregan características de **Opción B2** (TOML) según sea necesario.

---

## ¿Qué Sigue?

- ⭐ [Dale una estrella en GitHub](https://github.com/cuiqdata/cuiqdata)
- 💬 [Únete a nuestro Discord](https://discord.gg/cuiqdata)
- 🚀 [Características Pro](https://www.cuiqanalytics.com/cuiqdata_es.html)

---

Construido con ❤️ para equipos de datos que valoran velocidad y SQL.
