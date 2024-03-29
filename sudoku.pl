:- dynamic existe/3.
:- dynamic fila/2.
:- dynamic columna/2.
:- dynamic cuadrante/3.
:- dynamic posibilidades/3.

% -----HECHOS-----

% Formato del sudoku
sudoku(1,
       [5,3,4,.,7,.,.,.,.,
        6,.,.,1,9,5,.,.,.,
        .,9,8,.,.,.,.,6,.,
        8,.,.,.,6,.,.,.,3,
        4,.,.,8,.,3,.,.,1,
        7,.,.,.,2,.,.,.,6,
        .,6,.,.,.,.,2,8,.,
        .,.,.,4,1,9,.,.,5,
        .,.,.,.,8,.,.,7,9]).

sudoku(2,
       [.,2,3,4,5,6,7,8,9,
        7,8,9,1,2,3,4,5,6,
        4,5,6,7,8,9,1,2,3,
        9,1,2,3,4,5,6,7,8,
        6,7,8,9,1,2,3,4,5,
        3,4,4,5,6,7,8,1,2,
        8,9,1,2,3,4,5,6,7,
        5,6,7,8,9,1,2,3,4,
        2,3,4,5,6,7,8,9,1]).

sudoku(3,
       [.,.,8,.,.,7,.,.,.,
        .,4,2,.,.,5,.,.,.,
        .,.,3,.,.,6,8,.,1,
        .,.,.,.,.,.,.,.,6,
        9,.,.,.,.,.,.,.,.,
        .,.,1,.,.,.,.,.,.,
        .,8,.,1,3,.,4,7,.,
        .,.,.,.,9,.,.,.,.,
        .,1,.,.,.,.,.,.,.]).

% Lista de los numeros posibles
numeros([1,2,3,4,5,6,7,8,9]).

% -----REGLAS-----

start() :-
    generarSudoku(),
    colocarPosibilidades(0).

% Regla para llamar a crearSudoku
generarSudoku() :-
    sudoku(1, Sudoku),
    crearSudoku(Sudoku, 0),
    imprimirSudoku(),
    recopilarPosibilidades().

% Regla para llamar a la generación de posibilidades
recopilarPosibilidades() :-
    recopilarFilas(0),
    recopilarColumnas(0),
    recopilarCuadrantes().
    % colocarPosibilidades(0).

actualizarPosibilidades() :-
    retractall(posibilidades(_, _, _)),
    recopilarPosibilidades(),
    colocarPosibilidades(0).


% Reglas para buscar en que posición nos encontramos
buscaX(N, X) :- X is N mod 9.
buscaY(N, Y) :- Y is N // 9.

% Llama a la creación de los hechos del sudoku en sí
crearSudoku([], _).
crearSudoku([Primero|Resto], N) :-
    buscaX(N, X),
    buscaY(N, Y),
    (not(Primero == .) ->               % si no es un punto
    assertz(existe(Primero, X, Y)) ;    % agrega el numero a los hechos
    true),                              % si es un punto, no hace nada
    crearSudoku(Resto, N+1).



% Regla para imprimir el Sudoku
imprimirSudoku() :-
    sudoku(3, Sudoku),
    imprimirElemento(Sudoku, 0).

imprimirElemento([], _) :-
    write('+-------+-------+-------+\n').
imprimirElemento([_|Resto], N) :-
    X is N mod 9,
    Y is N // 9,
    (N mod 27 =:= 0 -> write('+-------+-------+-------+\n'); true),  % Si estamos al inicio de un cuadrado, imprimimos una línea de separación
    (N mod 9 =:= 0 -> write('| '); true),  % Si estamos al inicio de una fila, imprimimos un separador de fila
    (existe(Num,X,Y) -> write(Num); write('_')),  % Si el elemento es un punto, imprimimos un guión bajo
    (N mod 3 =:= 2 -> write(' | '); write(' ')),  % Si estamos al final de una celda, imprimimos un separador de celda
    (N mod 9 =:= 8 -> write('\n'); true),  % Si estamos al final de una fila, hacemos un salto de línea
    N1 is N + 1,
    imprimirElemento(Resto, N1).
% Regla para imprimir el Sudoku con posibilidades
imprimirSudokuPosibilidades() :-
    imprimirElementoPosibilidades(0).

% Regla para imprimir cada elemento del Sudoku con posibilidades
imprimirElementoPosibilidades(81).
imprimirElementoPosibilidades(N) :-
    (N mod 27 =:= 0 -> write('+-------+-------+-------+\n'); true),  % Si estamos al inicio de un cuadrado, imprimimos una línea de separación
    (N mod 9 =:= 0 -> write('| '); true),  % Si estamos al inicio de una fila, imprimimos un separador de fila
    buscaX(N, X),
    buscaY(N, Y),
    (posibilidades(X, Y, Pos) ; existe(Pos, X, Y)),
    write(Pos),
    (N mod 3 =:= 2 -> write(' | '); write(' ')),  % Si estamos al final de una celda, imprimimos un separador de celda
    (N mod 9 =:= 8 -> write('\n'); true),  % Si estamos al final de una fila, hacemos un salto de línea
    N1 is N + 1,
    imprimirElementoPosibilidades(N1).





colocarPosibilidades(81).
colocarPosibilidades(N):-
    X is N mod 9,
    Y is N // 9,
    ocupados(X, Y, Ocupados),
    numeros(Numeros),
    contrario(Ocupados, Numeros, P),
    assertz(posibilidades(X, Y, P)),
    NEXT is N + 1,
    colocarPosibilidades(NEXT).
colocarPosibilidades(N):-
    NEXT is N + 1,
    colocarPosibilidades(NEXT).


% Busca las posibilidades de la casilla que quieras
% posibilidades(X, Y, Posibilidades) :-
%     ocupados(X, Y, Ocupados),
%     numeros(Numeros),
%     contrario(Ocupados, Numeros, Posibilidades).    % Devuelve los numeros que faltan en la lista

% Localiza en que cuadrante nos encontramos y lo devuelve
localCuadr(X, Y, Cuadr) :-
    CX is X // 3,
    CY is Y // 3,
    cuadrante(CX, CY, Cuadr).

% Utiliza buscarNumeros solo si no existe numero en la casilla
ocupados(X, Y, Ocupados) :-
    (not(existe(_, X, Y)) ->
    buscarNumeros(X, Y, Ocupados)).

% Busca los números que ya están en la fila, columna y cuadrante
buscarNumeros(X, Y, Numeros) :-
    fila(Y, Fila),                      % Busca los números de la fila
    columna(X, Columna),                % Busca los números de la columna
    localCuadr(X, Y, Cuadrante),        % Busca los números del cuadrante
    merge(Fila, Columna, Temp),         % Une los números de la fila y columna
    merge(Temp, Cuadrante, Numeros).    % Une los números de la fila, columna y cuadrante

% -----BUSCAR DATOS DE LAS FILAS-----

% Recopila los datos de las filas desde la N hasta la 9
recopilarFilas(9).
recopilarFilas(N) :-
    (fila(N, _) ->
    retract(fila(N, _));        % Si ya existe la fila, la borra
    true),
    buscarFila(N, 0),           % Busca los números de la fila
    NEXT is N+1,
    recopilarFilas(NEXT).       % Recursión para la siguiente fila

% Busca los números de la fila
buscarFila(_,9).
buscarFila(Y, X):-
    (existe(Numero, X, Y) ->    % Si existe un número en la casilla
    agregarAFila(Y, Numero);    % Agrega el número a la fila
    true),
    NEXT is X+1,
    buscarFila(Y,NEXT).         % Recursión para la siguiente casilla

% Agrega el número a la fila
agregarAFila(Y, Numero) :-
    (fila(Y, _) ->                  % Si ya existe la fila
    modificarFila(Y, Numero) ;      % Modifica la fila
    assertz(fila(Y, [Numero]))).    % Si no existe, la crea

% Modifica la fila
modificarFila(Y, Numero) :-
    fila(Y, Fila),                  % Busca la fila
    append(Fila, [Numero], AFila),  % Agrega el número a la fila
    sort(AFila, NFila),             % Ordena la fila
    retract(fila(Y,_)),             % Borra la fila
    assertz(fila(Y, NFila)).        % Crea la nueva fila

% -----BUSCAR DATOS DE LAS COLUMNAS-----

% Recopila los datos de las columnas desde la N hasta la 9
recopilarColumnas(9).
recopilarColumnas(N) :-
    (columna(N, _) ->
    retract(columna(N, _));     % Si ya existe la columna, la borra
    true),
    buscarColumna(N, 0),        % Busca los números de la columna
    NEXT is N+1,
    recopilarColumnas(NEXT).    % Recursión para la siguiente columna

% Busca los números de la columna
buscarColumna(_, 9).
buscarColumna(X, Y):-
    (existe(Numero, X, Y) ->        % Si existe un número en la casilla
    agregarAColumna(X, Numero);     % Agrega el número a la columna
    true),
    NEXT is Y+1,
    buscarColumna(X,NEXT).          % Recursión para la siguiente casilla

% Agrega el número a la columna
agregarAColumna(X, Numero) :-
    (columna(X, _) ->                   % Si ya existe la columna
    modificarColumna(X, Numero) ;       % Modifica la columna
    assertz(columna(X, [Numero]))).     % Si no existe, la crea

% Modifica la columna
modificarColumna(X, Numero) :-
    columna(X, Col),                % Busca la columna
    append(Col, [Numero], ACol),    % Agrega el número a la columna
    sort(ACol, NCol),               % Ordena la columna
    retract(columna(X, _)),         % Borra la columna
    assertz(columna(X, NCol)).      % Crea la nueva columna

% -----BUSCAR DATOS DE LOS CUADRANTES-----

% Recopila los datos de los cuadrantes
recopilarCuadrantes() :-
    recopilarCuadrCol(0).

% Recopila los datos del cuadrante desde la fila N hasta la 3 en la columna CY
recopilarCuadrFila(_, 3).
recopilarCuadrFila(CY, CX):-
    buscarCuadrante(CX, CY),        % Busca los números del cuadrante
    NEXT is CX+1,
    recopilarCuadrFila(CY, NEXT).   % Recursión para la siguiente fila

% Recopila los datos de todos los cuadrantes de la columna N hasta la 3
recopilarCuadrCol(3).
recopilarCuadrCol(N):-
    recopilarCuadrFila(N, 0),       % Recopila los datos de los cuadrantes de la columna N
    NEXT is N+1,
    recopilarCuadrCol(NEXT).        % Recursión para la siguiente columna

% Busca los números del cuadrante
buscarCuadrante(CX, CY):-
    (cuadrante(CX, CY, _) ->            % Si ya existe el cuadrante
    retract(cuadrante(CX, CY, _));      % Borra el cuadrante
    true),
    buscarColumnaCuadr(CX, CY, 0).      % Busca los números del cuadrante

% Busca los números de la fila dentro del cuadrante por casilla
buscarFilaCuadr(_, _, _, 3).
buscarFilaCuadr(CX, CY, PY, PX):-
    X is 3*CX+PX,                           % Calcula la posición X
    Y is 3*CY+PY,                           % Calcula la posición Y
    (existe(Numero, X, Y) ->                % Si existe un número en la casilla
    agregarACuadrante(CX, CY, Numero);      % Agrega el número al cuadrante
    true),
    NEXT is PX+1,
    buscarFilaCuadr(CX, CY, PY, NEXT).      % Recursión para la siguiente casilla

% Busca los números de de todas las filas de un cuadrante desde la N hasta la 3
buscarColumnaCuadr(_, _, 3).
buscarColumnaCuadr(CX, CY, N):-
    buscarFilaCuadr(CX, CY, N, 0),      % Busca los números de la fila
    NEXT is N+1,
    buscarColumnaCuadr(CX, CY, NEXT).   % Recursión para la siguiente fila

% Agrega el número al cuadrante
agregarACuadrante(CX, CY, Numero) :-
    (cuadrante(CX, CY, _) ->                % Si ya existe el cuadrante
    modificarCuadrante(CX, CY, Numero) ;    % Modifica el cuadrante
    assertz(cuadrante(CX, CY, [Numero]))).  % Si no existe, lo crea

% Modifica el cuadrante
modificarCuadrante(CX, CY, Numero) :-
    cuadrante(CX, CY, Cuadrante),               % Busca el cuadrante
    append(Cuadrante, [Numero], ACuadrante),    % Agrega el número al cuadrante
    sort(ACuadrante, NCuadrante),               % Ordena el cuadrante
    retract(cuadrante(CX, CY, _)),              % Borra el cuadrante
    assertz(cuadrante(CX, CY, NCuadrante)).     % Crea el nuevo cuadrante

% -----REGLA 0----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

detectarNumeroUnico(X, Y) :-
    posibilidades(X, Y, [Num|Resto]),
    Resto == [],
    assertz(existe(Num, X, Y)),
    retract(posibilidades(X,Y,_)).
    % elimiarDeCuadrante(Num, X, Y, 0),
    % eliminarDeFila(Num, Y, 0),
    % eliminarDeColumna(Num, X, 0).

% elimiarDeCuadrante(_, _, _, 9).
% eliminarDeCuadrante(Num, X, Y, N) :-
%     CX is X // 3,
%     CY is Y // 3,
%     LX is N mod 3,
%     LY is N // 3,
%     X1 is 3*CX+LX,
%     Y1 is 3*CY+LY,
%     posibilidades(X1, Y1, Pos),
%     contrario(Num, Pos, Nueva),
%     retract(posibilidades(X, Y, _)),
%     assertz(posibilidades(X, Y, Nueva)),
%     NEXT is N + 1,
%     eliminarDeCuadrante(Num, X, Y, NEXT).
% eliminarDeCuadrante(Num, X, Y, N) :-
%     NEXT is N + 1,
%     eliminarDeCuadrante(Num, X, Y, NEXT).

% eliminarDeFila(_, _, 9).
% eliminarDeFila(Num, Y, N) :-
%     posibilidades(N, Y, Pos),
%     contrario(Num, Pos, Nueva),
%     retract(posibilidades(N, Y, _)),
%     assertz(posibilidades(N, Y, Nueva)),
%     NEXT is N + 1,
%     eliminarDeFila(Num, Y, NEXT).
% eliminarDeFila(Num, Y, N) :-
%     NEXT is N + 1,
%     eliminarDeFila(Num, Y, NEXT).

% eliminarDeColumna(_, _, 9).
% eliminarDeColumna(Num, X, N) :-
%     posibilidades(X, N, Pos),
%     contrario(Num, Pos, Nueva),
%     retract(posibilidades(X, N, _)),
%     assertz(posibilidades(X, N, Nueva)),
%     NEXT is N + 1,
%     eliminarDeColumna(Num, X, NEXT).
% eliminarDeColumna(Num, X, N) :-
%     NEXT is N + 1,
%     eliminarDeColumna(Num, X, NEXT).


regla0() :-
    aplicarRegla0(0),
    imprimirSudoku(),
    actualizarPosibilidades().

aplicarRegla0(81).
aplicarRegla0(N) :-
    buscaX(N, X),
    buscaY(N, Y),
    detectarNumeroUnico(X, Y),
    write('Detectado numero unico en '), write(X), write(', '), write(Y), nl,
    N1 is N + 1,
    aplicarRegla0(N1).
aplicarRegla0(N) :-
    N1 is N + 1,
    aplicarRegla0(N1).

% -----REGLA 1-----------------------------------------------------------------------------------------------------------------------------------------------------------

buscarNumeroFila(_, 9, _, 0).
buscarNumeroFila(F, N, Num, Amount) :-
    posibilidades(N, F, Pos),
    member(Num, Pos),
    NEXT is N + 1,
    buscarNumeroFila(F, NEXT, Num, Amount1),
    Amount is Amount1 + 1.
buscarNumeroFila(F, N, Num, Amount) :-
    NEXT is N + 1,
    buscarNumeroFila(F, NEXT, Num, Amount).

buscarNumeroColumna(9, _, _, 0).
buscarNumeroColumna(N, C, Num, Amount) :-
    posibilidades(C, N, Pos),
    member(Num, Pos),
    NEXT is N + 1,
    buscarNumeroColumna(NEXT, C, Num, Amount1),
    Amount is Amount1 + 1.
buscarNumeroColumna(N, C, Num, Amount) :-
    NEXT is N + 1,
    buscarNumeroColumna(NEXT, C, Num, Amount).

buscarNumerosFila(_, 9, Result) :-
    Result = [].
buscarNumerosFila(F, N, Result) :-
    NEXT is N + 1,
    buscarNumeroFila(F, 0, NEXT, Amount),
    buscarNumerosFila(F, NEXT, Result1),
    append([Amount], Result1, Result).

buscarRegla1([], _, Resultado) :-
    Resultado = [].
buscarRegla1([Probar|Resto], N, Resultado) :-
    Probar == 1,
    NEXT is N + 1,
    buscarRegla1(Resto, NEXT, Resultado1),
    append([NEXT], Resultado1, Resultado).
buscarRegla1([_|Resto], N, Resultado) :-
    NEXT is N + 1,
    buscarRegla1(Resto, NEXT, Resultado).

aplicarRegla1Fila(_, 9, _).
aplicarRegla1Fila(_, _, []).
aplicarRegla1Fila(F, N, [Num|Resto]) :-
    posibilidades(N, F, Pos),
    member(Num, Pos),
    assertz(existe(Num, N, F)),
    retract(posibilidades(N, F, _)),
    NEXT is 0,
    aplicarRegla1Fila(F, NEXT, Resto).
aplicarRegla1Fila(F, N, [Num|Resto]) :-
    NEXT is N + 1,
    aplicarRegla1Fila(F, NEXT, [Num|Resto]).

regla1Fila(F) :-
    buscarNumerosFila(F, 0, Result),
    buscarRegla1(Result, 0, Resultado),
    aplicarRegla1Fila(F, 0, Resultado),
    write('Fila '), write(F), write(Resultado), nl.


buscarNumeroCuadrante(_, _, 9, _, 0).
buscarNumeroCuadrante(CX, CY, N, Num, Amount) :-
    X is 3*CX + N mod 3,
    Y is 3*CY + N // 3,
    posibilidades(X, Y, Pos),
    member(Num, Pos),
    NEXT is N + 1,
    buscarNumeroCuadrante(CX, CY, NEXT, Num, Amount1),
    Amount is Amount1 + 1.
buscarNumeroCuadrante(CX, CY, N, Num, Amount) :-
    NEXT is N + 1,
    buscarNumeroCuadrante(CX, CY, NEXT, Num, Amount).

buscarNumerosCuadrante(_, _, 9, Result) :-
    Result = [].
buscarNumerosCuadrante(CX, CY, N, Result) :-
    NEXT is N + 1,
    buscarNumeroCuadrante(CX, CY, 0, NEXT, Amount),
    buscarNumerosCuadrante(CX, CY, NEXT, Result1),
    append([Amount], Result1, Result).

aplicarRegla1Cuadrante(_, _, 9, _).
aplicarRegla1Cuadrante(_, _, _, []).
aplicarRegla1Cuadrante(CX, CY, N, [Num|Resto]) :-
    X is 3*CX + N mod 3,
    Y is 3*CY + N // 3,
    posibilidades(X, Y, Pos),
    member(Num, Pos),
    assertz(existe(Num, X, Y)),
    retract(posibilidades(X, Y, _)),
    NEXT is 0,
    aplicarRegla1Cuadrante(CX, CY, NEXT, Resto).
aplicarRegla1Cuadrante(CX, CY, N, [Num|Resto]) :-
    NEXT is N + 1,
    aplicarRegla1Cuadrante(CX, CY, NEXT, [Num|Resto]).

regla1Cuadrante(CX, CY) :-
    buscarNumerosCuadrante(CX, CY, 0, Result),
    buscarRegla1(Result, 0, Resultado),
    write('Cuadrante '), write(CX), write(CY), write(Resultado), nl,
    aplicarRegla1Cuadrante(CX, CY, 0, Resultado).

buscarNumerosColumna(_, 9, Result) :-
    Result = [].
buscarNumerosColumna(C, N, Result) :-
    NEXT is N + 1,
    buscarNumeroColumna(N, C, 0, Amount),
    buscarNumerosColumna(C, NEXT, Result1),
    append([Amount], Result1, Result).

aplicarRegla1Columna(_, 9, _).
aplicarRegla1Columna(_, _, []).
aplicarRegla1Columna(C, N, [Num|Resto]) :-
    posibilidades(C, N, Pos),
    member(Num, Pos),
    assertz(existe(Num, C, N)),
    retract(posibilidades(C, N, _)),
    NEXT is 0,
    aplicarRegla1Columna(C, NEXT, Resto).
aplicarRegla1Columna(C, N, [Num|Resto]) :-
    NEXT is N + 1,
    aplicarRegla1Columna(C, NEXT, [Num|Resto]).

regla1Columna(C) :-
    buscarNumerosColumna(C, 0, Result),
    buscarRegla1(Result, 0, Resultado),
    aplicarRegla1Columna(C, 0, Resultado),
    write('Columna'), write(C), write(Resultado), nl.

regla1() :-
    regla1Fila(0),
    regla1Fila(1),
    regla1Fila(2),
    regla1Fila(3),
    regla1Fila(4),
    regla1Fila(5),
    regla1Fila(6),
    regla1Fila(7),
    regla1Fila(8),
    regla1Cuadrante(0, 0),
    regla1Cuadrante(0, 1),
    regla1Cuadrante(0, 2),
    regla1Cuadrante(1, 0),
    regla1Cuadrante(1, 1),
    regla1Cuadrante(1, 2),
    regla1Cuadrante(2, 0),
    regla1Cuadrante(2, 1),
    regla1Cuadrante(2, 2),
    regla1Columna(0),
    regla1Columna(1),
    regla1Columna(2),
    regla1Columna(3),
    regla1Columna(4),
    regla1Columna(5),
    regla1Columna(6),
    regla1Columna(7),
    regla1Columna(8),
    imprimirSudoku(),
    actualizarPosibilidades().
% -----REGLA 2-----------------------------------------------------------------------------------------------------------------------------------------

% regla2Cuadrante(0).
% aplicarRegla2Cuadrante(0).

% Calcula que posibilidades son iguales en una fila
posibilidadesIgualesFila(_, _, 9, Count, Res) :-
    sort(Count, Res).
posibilidadesIgualesFila(F, X, N, Count, Res) :-
    posibilidades(X, F, P),
    posibilidades(N, F, Pc),
    Pc == P,
    NEXT is N + 1,
    posibilidadesIgualesFila(F, X, NEXT, [N|Count], Res).
posibilidadesIgualesFila(F, X, N, Count, Res) :-
    posibilidades(X,F, _),
    NEXT is N + 1,
    posibilidadesIgualesFila(F, X, NEXT, Count, Res).

% Calcula que posibilidades son iguales en una columna
posibilidadesIgualesColumna(_, _, 9, Count, Res) :-
    sort(Count, Res).
posibilidadesIgualesColumna(C, Y, N, Count, Res) :-
    posibilidades(C, Y, P),
    posibilidades(C, N, Pf),
    Pf == P,
    NEXT is N + 1,
    posibilidadesIgualesColumna(C, Y, NEXT, [N|Count], Res).
posibilidadesIgualesColumna(C, Y, N, Count, Res) :-
    posibilidades(C, Y, _),
    NEXT is N + 1,
    posibilidadesIgualesColumna(C, Y, NEXT, Count, Res).

% Calcula que posibilidades son iguales en un cuadrante
posibilidadesIgualesCuadrante(_, _, 10,_ , _).
posibilidadesIgualesCuadrante(_, _, 9, Count, Res) :-
    sort(Count, Res).
posibilidadesIgualesCuadrante(X, Y, N, Count, Res) :-
    posibilidades(X, Y, P),
    CX is X // 3,
    CY is Y // 3,
    LX is N mod 3,
    LY is N // 3,
    X1 is 3*CX+LX,
    Y1 is 3*CY+LY,
    N < 9,
    % write('Escaneando '), write(X1), write(', '), write(Y1), nl,
    posibilidades(X1, Y1, Pc),
    Pc == P,
    % write('Encontrado'), nl,
    NEXT is N + 1,
    posibilidadesIgualesCuadrante(X, Y, NEXT, [N|Count], Res).
posibilidadesIgualesCuadrante(X, Y, N, Count, Res) :-
    posibilidades(X, Y, _),
    N < 9,
    % write('No encontrado, pasando.'), nl,
    NEXT is N + 1,
    posibilidadesIgualesCuadrante(X, Y, NEXT, Count, Res).


% CALCULAR REGLA 2 CUADRANTES

% Calcula dónde existe un par de posibilidades en el cuadrante y lo guarda como pIC(X, Y)
parPosibilidadesCuadrante(X, Y):-
    posibilidadesIgualesCuadrante(X, Y, 0, [], Res),
    assertz(pIC(X, Y, Res)).

% Aplica la regla 2 para la posición (X, Y)
aplicarParPosibilidadesCuadrante(X,Y):-
    pIC(X,Y,Res),
    length(Res, 2),
    posibilidades(X, Y, P),
    length(P, 2),
    write('Par encontrado en posicion '), write(X), write(', '), write(Y), write(' con puestos '), write(Res), nl,
    cambiarPosibilidadesCuadranteDuo(P, X, Y, 0, Res),
    retract(pIC(X,Y,_)).

% Cambia las posibilidades del cuadrante, quitando las posibilidades de P a cada una
cambiarPosibilidadesCuadranteDuo(_, _, _, 9, _).
cambiarPosibilidadesCuadranteDuo(P, X, Y, N, Descartar) :-
    not(member(N, Descartar)),
    CX is X // 3,
    CY is Y // 3,
    LX is N mod 3,
    LY is N // 3,
    X1 is 3*CX+LX,
    Y1 is 3*CY+LY,
    posibilidades(X1, Y1, NP),
    contrario(P, NP, Nuevas),
    retract(posibilidades(X1, Y1, _)),
    assertz(posibilidades(X1, Y1, Nuevas)),
    % write('Cambiando las cosas en '), write(X1), write(', '), write(Y1), nl,
    NEXT is N + 1,
    cambiarPosibilidadesCuadranteDuo(P, X, Y, NEXT, Descartar).
cambiarPosibilidadesCuadranteDuo(P, X, Y, N, Descartar) :-
    NEXT is N + 1,
    cambiarPosibilidadesCuadranteDuo(P, X, Y, NEXT, Descartar).

% busca las posibilidades iguales de todos los cuadrantes y los guarda en pIC(X, Y)
regla2Cuadrante(81).
regla2Cuadrante(N):-
    X is N mod 9,
    Y is N // 9,
    not(existe(_, X, Y)),
    parPosibilidadesCuadrante(X, Y),
    NEXT is N + 1,
    regla2Cuadrante(NEXT).
regla2Cuadrante(N):-
    NEXT is N + 1,
    regla2Cuadrante(NEXT).

% Aplica la regla 2 a todas las casillas, borrando los pIC(X, Y) y las posibilidades del resto
aplicarRegla2Cuadrante(81).
aplicarRegla2Cuadrante(N):-
    X is N mod 9,
    Y is N // 9,
    not(existe(_, X, Y)),
    aplicarParPosibilidadesCuadrante(X, Y),
    NEXT is N + 1,
    aplicarRegla2Cuadrante(NEXT).
aplicarRegla2Cuadrante(N):-
    NEXT is N + 1,
    aplicarRegla2Cuadrante(NEXT).

regla2CuadranteDef() :-
    regla2Cuadrante(0),
    aplicarRegla2Cuadrante(0).


% CALCULAR REGLA 2 PARA FILAS

parPosibilidadesFila(X, Y):-
    posibilidadesIgualesFila(X, Y, 0, [], Res),
    assertz(pIF(X, Y, Res)).

aplicarParPosibilidadesFila(X,Y):-
    pIF(X,Y,Res),
    length(Res, 2),
    posibilidades(X, Y, P),
    length(P, 2),
    write('Par encontrado en fila '), write(Y), write(' con puestos '), write(Res), nl,
    cambiarPosibilidadesFilaDuo(P, X, Y, 0, Res),
    retract(pIF(X,Y,_)).

cambiarPosibilidadesFilaDuo(_, _, _, 9, _).
cambiarPosibilidadesFilaDuo(P, X, Y, N, Descartar) :-
    not(member(N, Descartar)),
    posibilidades(N, Y, NP),
    contrario(P, NP, Nuevas),
    retract(posibilidades(N, Y, _)),
    assertz(posibilidades(N, Y, Nuevas)),
    % write('Cambiando las cosas en '), write(X1), write(', '), write(Y1), nl,
    NEXT is N + 1,
    cambiarPosibilidadesFilaDuo(P, X, Y, NEXT, Descartar).
cambiarPosibilidadesFilaDuo(P, X, Y, N, Descartar) :-
    NEXT is N + 1,
    cambiarPosibilidadesFilaDuo(P, X, Y, NEXT, Descartar).

regla2Fila(81).
regla2Fila(N):-
    X is N mod 9,
    Y is N // 9,
    not(existe(_, X, Y)),
    parPosibilidadesFila(X, Y),
    NEXT is N + 1,
    regla2Fila(NEXT).
regla2Fila(N):-
    NEXT is N + 1,
    regla2Fila(NEXT).

aplicarRegla2Fila(81).
aplicarRegla2Fila(N):-
    X is N mod 9,
    Y is N // 9,
    not(existe(_, X, Y)),
    aplicarParPosibilidadesFila(X, Y),
    NEXT is N + 1,
    aplicarRegla2Fila(NEXT).
aplicarRegla2Fila(N):-
    NEXT is N + 1,
    aplicarRegla2Fila(NEXT).

regla2FilaDef() :-
    regla2Fila(0),
    aplicarRegla2Fila(0).

% CALCULAR REGLA 2 PARA COLUMNAS

parPosibilidadesColumna(X, Y):-
    posibilidadesIgualesColumna(X, Y, 0, [], Res),
    assertz(pICol(X, Y, Res)).

aplicarParPosibilidadesColumna(X,Y):-
    pICol(X,Y,Res),
    length(Res, 2),
    posibilidades(X, Y, P),
    length(P, 2),
    write('Par encontrado en columna '), write(Y), write(' con puestos '), write(Res), nl,
    cambiarPosibilidadesColumnaDuo(P, X, Y, 0, Res),
    retract(pICol(X,Y,_)).

cambiarPosibilidadesColumnaDuo(_, _, _, 9, _).
cambiarPosibilidadesColumnaDuo(P, X, Y, N, Descartar) :-
    not(member(N, Descartar)),
    posibilidades(X, N, NP),
    contrario(P, NP, Nuevas),
    retract(posibilidades(X, N, _)),
    assertz(posibilidades(X, N, Nuevas)),
    % write('Cambiando las cosas en '), write(X1), write(', '), write(Y1), nl,
    NEXT is N + 1,
    cambiarPosibilidadesColumnaDuo(P, X, Y, NEXT, Descartar).
cambiarPosibilidadesColumnaDuo(P, X, Y, N, Descartar) :-
    NEXT is N + 1,
    cambiarPosibilidadesColumnaDuo(P, X, Y, NEXT, Descartar).

regla2Columna(81).
regla2Columna(N):-
    X is N mod 9,
    Y is N // 9,
    not(existe(_, X, Y)),
    parPosibilidadesColumna(X, Y),
    NEXT is N + 1,
    regla2Columna(NEXT).
regla2Columna(N):-
    NEXT is N + 1,
    regla2Columna(NEXT).

aplicarRegla2Columna(81).
aplicarRegla2Columna(N):-
    X is N mod 9,
    Y is N // 9,
    not(existe(_, X, Y)),
    aplicarParPosibilidadesColumna(X, Y),
    NEXT is N + 1,
    aplicarRegla2Columna(NEXT).
aplicarRegla2Columna(N):-
    NEXT is N + 1,
    aplicarRegla2Columna(NEXT).

regla2ColumnaDef() :-
    regla2Columna(0),
    aplicarRegla2Columna(0).


regla2():-
    regla2CuadranteDef(),
    regla2FilaDef(),
    regla2ColumnaDef(),
    imprimirSudoku().


% -----REGLA 3----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

aplicarTrioPosibilidadesColumna(X,Y):-
    pICol(X,Y,Res),
    length(Res, 3),
    posibilidades(X, Y, P),
    length(P, 3),
    write('Trio encontrado en columna '), write(Y), write(' con puestos '), write(Res), nl,
    cambiarPosibilidadesColumnaDuo(P, X, Y, 0, Res),
    retract(pICol(X,Y,_)).

aplicarRegla3Columna(81).
aplicarRegla3Columna(N):-
    X is N mod 9,
    Y is N // 9,
    not(existe(_, X, Y)),
    aplicarTrioPosibilidadesColumna(X, Y),
    NEXT is N + 1,
    aplicarRegla3Columna(NEXT).
aplicarRegla3Columna(N):-
    NEXT is N + 1,
    aplicarRegla3Columna(NEXT).

aplicarTrioPosibilidadesCuadrante(X,Y):-
    pIC(X,Y,Res),
    length(Res, 3),
    posibilidades(X, Y, P),
    length(P, 3),
    write('Trio encontrado en posicion '), write(X), write(', '), write(Y), write(' con puestos '), write(Res), nl,
    cambiarPosibilidadesCuadranteDuo(P, X, Y, 0, Res),
    retract(pIC(X,Y,_)).

aplicarRegla3Cuadrante(81).
aplicarRegla3Cuadrante(N):-
    X is N mod 9,
    Y is N // 9,
    not(existe(_, X, Y)),
    aplicarTrioPosibilidadesCuadrante(X, Y),
    NEXT is N + 1,
    aplicarRegla3Cuadrante(NEXT).
aplicarRegla3Cuadrante(N):-
    NEXT is N + 1,
    aplicarRegla3Cuadrante(NEXT).

aplicarTrioPosibilidadesFila(X,Y):-
    pIF(X,Y,Res),
    length(Res, 3),
    posibilidades(X, Y, P),
    length(P, 3),
    write('Trio encontrado en fila '), write(Y), write(' con puestos '), write(Res), nl,
    cambiarPosibilidadesFilaDuo(P, X, Y, 0, Res),
    retract(pIF(X,Y,_)).

aplicarRegla3Fila(81).
aplicarRegla3Fila(N):-
    X is N mod 9,
    Y is N // 9,
    not(existe(_, X, Y)),
    aplicarTrioPosibilidadesFila(X, Y),
    NEXT is N + 1,
    aplicarRegla3Fila(NEXT).
aplicarRegla3Fila(N):-
    NEXT is N + 1,
    aplicarRegla3Fila(NEXT).

regla3FilaDef() :-
    regla2Fila(0),
    aplicarRegla3Fila(0).

regla3ColumnaDef() :-
    regla2Columna(0),
    aplicarRegla3Columna(0).

regla3CuadranteDef() :-
    regla2Cuadrante(0),
    aplicarRegla3Cuadrante(0).

regla3():-
    regla3CuadranteDef(),
    regla3FilaDef(),
    regla3ColumnaDef(),
    imprimirSudoku().

% -----MISC------------------------------------------------------------------------------------------------------------------------------------------------

head([H|_], H).


borrar( _, [], []).
borrar( R, [R|T], T2) :- borrar( R, T, T2).
borrar( R, [H|T], [H|T2]) :- H \= R, borrar( R, T, T2).

merge( []     , []     , []     ).   % the merger of two empty lists is the empty list.
merge( [X|Xs] , []     , [X|Xs] ).   % the merger of a non-empty list and an empty list is the non-empty list
merge( []     , [Y|Ys] , [Y|Ys] ).   % the merger of an empty list and a non-empty list is the non-empty list
merge( [X|Xs] , [Y|Ys] , [X|Zs] ) :- % to merge two non-empty lists
  X @< Y,                            % and the left item is less than the right item
  merge( Xs, [Y|Ys], Zs )            % take the left item and recurse down
  .                                  %
merge( [X|Xs] , [Y|Ys] , [Y|Zs] ) :- % to merge two non-empty lists
  X @> Y,                            % and the left item is greater than the right item
  merge( [X|Xs], Ys, Zs )            % take the right item and recurse down
  .                                  %
merge( [X|Xs] , [Y|Ys] , [X|Zs] ) :- % to merge two non-empty lists
  X == Y,                            % and the left and right items are equal
  merge( Xs, Ys, Zs )                % take either item, discard the other and recurse down
  .                                  % Easy!


% Devuelve los números de la lista Ys que faltan en la lista Xs con output en Zs
contrario([], [], []).
contrario(_, [], []).
contrario([], [Y|Ys], [Y|Ys]).
contrario([X|Xs], [Y|Ys] , Zs) :-
    X @< Y,
    contrario( Xs, [Y|Ys], Zs ).
contrario([X|Xs], [Y|Ys], [Y|Zs]) :-
    X @> Y,
    contrario( [X|Xs], Ys, Zs).
contrario([X|Xs], [Y|Ys], Zs) :-
    X == Y,
    contrario(Xs, Ys, Zs).

