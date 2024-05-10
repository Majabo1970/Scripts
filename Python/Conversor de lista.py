# Nombre del archivo de texto de entrada
nombre_archivo_entrada = 'archivo.txt'

# Nombre del archivo de texto de salida
nombre_archivo_salida = 'resultado.txt'

# Tamaño del grupo de registros por renglón
tamaño_grupo = 12

# Lista para almacenar temporalmente los registros
registros = []

# Abrir el archivo de entrada en modo lectura
with open(nombre_archivo_entrada, 'r') as archivo_entrada:
    # Leer todos los registros del archivo y eliminar saltos de línea
    for linea in archivo_entrada:
        registros.append(linea.strip())

# Crear una lista para almacenar los grupos de registros
grupos = []

# Iterar sobre los registros y dividirlos en grupos de tamaño_grupo
for i in range(0, len(registros), tamaño_grupo):
    grupo = registros[i:i+tamaño_grupo]
    # Unir los registros del grupo separados por comas y agregarlos a la lista de grupos
    grupos.append("','".join(grupo))

# Escribir los grupos de registros en el archivo de salida
with open(nombre_archivo_salida, 'w') as archivo_salida:
    for grupo in grupos:
        archivo_salida.write(grupo + "','")
