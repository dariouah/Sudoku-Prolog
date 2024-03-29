
# Solucionador de Sudoku en Prolog

Este repositorio contiene un solucionador de tableros de Sudoku implementado en Prolog. El programa es capaz de resolver sudokus mediante la aplicación de reglas lógicas definidas en Prolog, proporcionando una solución paso a paso.

## Requisitos Previos

Para ejecutar este solucionador de Sudoku, necesitarás tener instalado Prolog en tu sistema. Puedes descargar e instalar Prolog desde [SWI-Prolog](https://www.swi-prolog.org/Download.html).

## Configuración

Antes de ejecutar el programa, realiza los siguientes pasos para asegurarte de que Prolog está correctamente instalado y configurado en tu sistema:

1. Verifica la instalación ejecutando `swipl` en tu terminal o consola de comandos. Si no funciona, probablemente necesites agregar Prolog a las variables de entorno de tu sistema.
2. Para hacer Prolog accesible desde cualquier terminal, debes agregar la ruta del directorio binario de Prolog a las variables de entorno de tu sistema. Esto te permitirá ejecutar Prolog escribiendo `swipl` en el terminal.

   - **En Windows:** Busca "Variables de entorno" en el menú de inicio, y en la sección "Variables del sistema", encuentra y selecciona la variable "Path", y luego elige "Editar". Agrega la ruta del directorio binario de Prolog al final de la lista.
   
   - **En macOS y Linux:** Abre tu archivo de perfil de shell (por ejemplo, `~/.bash_profile`, `~/.zshrc`, etc.) con un editor de texto y añade la siguiente línea al final del archivo: `export PATH=$PATH:/ruta/a/prolog/bin`. Asegúrate de reemplazar `/ruta/a/prolog/bin` con la ruta actual al directorio binario de Prolog en tu sistema.

3. Reinicia tu terminal o consola de comandos para aplicar los cambios.

## Cómo Usar

Para empezar a resolver sudokus con este programa, sigue los siguientes pasos:

1. Clona este repositorio en tu máquina local usando el siguiente comando:

   ```
   git clone https://github.com/dariouah/sudoku-prolog.git
   ```

2. Navega al directorio del repositorio clonado.

3. Inicia SWI-Prolog en el directorio del proyecto:

   ```
   swipl
   ```

4. Carga el archivo de código fuente del solucionador de Sudoku:

   ```prolog
   ?- ['sudoku.pl'].
   ```

5. Para empezar a resolver un tablero de Sudoku, ejecuta el predicado `start/0`:

   ```prolog
   ?- start().
   ```

   Esto inicializará el programa y preparará el sistema para que introduzcas el tablero de Sudoku que deseas resolver.

6. Aplica las reglas que desees para resolver el tablero, utilizando los predicados `regla0`, `regla1`, `regla2`, etc. Por ejemplo:

   ```prolog
   ?- regla0.
   ?- regla1.
   ```

   Sigue aplicando reglas hasta que el tablero de Sudoku se resuelva.

## Video Tutorial de Uso

Para complementar las instrucciones provistas en la sección "Cómo Usar", consulta el [video tutorial de uso](/ejemplo-como-usar.mp4) que muestra en detalle los pasos a seguir para configurar tu entorno, iniciar el solucionador de Sudoku en Prolog, y aplicar las reglas necesarias para resolver el tablero.

Este video es especialmente útil si prefieres una guía visual que te lleve a través del proceso paso a paso, asegurando que puedas seguir las instrucciones y aplicar correctamente las reglas para resolver sudokus con éxito.

Encuentra el video tutorial en la sección de archivos del repositorio y mira cómo llevar a la práctica lo que has aprendido en este README.

Esperamos que este recurso te sea de gran ayuda y facilite tu experiencia al usar el solucionador de Sudoku en Prolog.

## Notas Adicionales

- Asegúrate de ingresar el tablero de Sudoku siguiendo el formato especificado en `sudoku.pl`.
- Puedes modificar el tablero de Sudoku dentro de `sudoku.pl` para resolver diferentes puzzles.

## Contribuciones

Si deseas contribuir a mejorar este solucionador de Sudoku en Prolog, por favor, siente libre de hacer un fork del repositorio, realizar cambios y enviar un pull request con tus mejoras.

## Licencia

Este proyecto se comparte de manera libre y abierta. Se permite el uso, distribución y modificación sin restricciones. Sin embargo, se agradece el crédito al autor original en caso de uso público.
