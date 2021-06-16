% E1 --> fila superior
% E2 --> columna derecha
% E3 --> fila inferior
% E4 --> columna izquierda
% F  --> fila
% C  --> celda

% Método que resuelve el tablero 4x4 teniendo en cuenta que el primer elemento que debe aparecer tanto por fila como por columna viene definido por una
% listas que se introducen por parámetros. Además, tiene en cuenta que no se repitan los caracteres a nivel columna

% Realizamos una permutación, comprobamos que cumpla los requisitos por fila y luego los requisitos por columna. En caso de no cumplirlo realiza backtraking

lletres([E11,E12,E13,E14],[E21,E22,E23,E24],[E31,E32,E33,E34],[E41,E42,E43,E44]):-
	% Permutamos las 4 filas
	permutacio([a,b,c,-] , [C11,C12,C13,C14]),
	permutacio([a,b,c,-] , [C21,C22,C23,C24]),
	permutacio([a,b,c,-] , [C31,C32,C33,C34]),
	permutacio([a,b,c,-] , [C41,C42,C43,C44]),
	% 1.1 comprobamos a nivel de fila 
	comprobarCelda(C11, E11, E21),  comprobarCelda(C11, E44, E12), comprobarCelda(C12, E12, E22), comprobarCelda(C13, E13, E23), comprobarCelda(C14, E14, E24), comprobarCelda(C14, E21, C13),
	% 1.2 comprobamos a nivel de columna
	comprobarColumna(C11, [C21,C31,C41]), comprobarColumna(C12, [C22,C32,C42]), comprobarColumna(C13, [C23,C33,C43]), comprobarColumna(C14, [C24,C34,C44]),
	% 2.1 comprobamos a nivel de fila
	comprobarCelda(C21, E43, C22), comprobarCelda(C24, E22, C23),
	% 2.2 comprobamos a nivel de columna
	comprobarColumna(C21, [C11,C31,C41]), comprobarColumna(C22, [C12,C32,C42]), comprobarColumna(C23, [C13,C33,C43]), comprobarColumna(C24, [C14,C34,C44]),
	% 3.1 comprobamos a nivel de fila
	comprobarCelda(C31, E42, C32), comprobarCelda(C34, E23, C33),
	% 3.2 comprobamos a nivel de columna
	comprobarColumna(C31, [C21,C11,C41]), comprobarColumna(C32, [C22,C12,C42]), comprobarColumna(C33, [C23,C13,C43]), comprobarColumna(C34, [C24,C14,C44]),
	% 4.1 comprobamos a nivel de fila
	comprobarCelda(C41, E34, C31),  comprobarCelda(C41, E41, C42), comprobarCelda(C42, E33, C32), comprobarCelda(C43, E32, C33), comprobarCelda(C44, E31, C34), comprobarCelda(C44, E24, C43),
	% 4.2 comprobamos a nivel de columna
	comprobarColumna(C41, [C21,C31,C11]), comprobarColumna(C42, [C22,C32,C12]), comprobarColumna(C43, [C23,C33,C13]), comprobarColumna(C44, [C24,C34,C14]),
	% imprimimos el resultado
	imprimirTablero([E11,E12,E13,E14],[E21,E22,E23,E24],[E31,E32,E33,E34],[E41,E42,E43,E44], [C11,C12,C13,C14], [C21,C22,C23,C24], [C31,C32,C33,C34], [C41,C42,C43,C44]), !.
	
% Resolvemos el tablero únicamente teniendo en cuenta que no se pueden repetir letras por columna. Resuelve el tablero hasta que no encuentra más 
% soluciones e incrementa un contador
	
lletresSinRestricciones:- 
	permutacio([a,b,c,-] , [C11,C12,C13,C14]),
	permutacio([a,b,c,-] , [C21,C22,C23,C24]),
	permutacio([a,b,c,-] , [C31,C32,C33,C34]),
	permutacio([a,b,c,-] , [C41,C42,C43,C44]),
	% comprobamos a nivel de columna
	comprobarColumna(C11, [C21,C31,C41]), comprobarColumna(C12, [C22,C32,C42]), comprobarColumna(C13, [C23,C33,C43]), comprobarColumna(C14, [C24,C34,C44]),
	% comprobamos a nivel de columna
	comprobarColumna(C21, [C11,C31,C41]), comprobarColumna(C22, [C12,C32,C42]), comprobarColumna(C23, [C13,C33,C43]), comprobarColumna(C24, [C14,C34,C44]),
	% comprobamos a nivel de columna
	comprobarColumna(C31, [C21,C11,C41]), comprobarColumna(C32, [C22,C12,C42]), comprobarColumna(C33, [C23,C13,C43]), comprobarColumna(C34, [C24,C14,C44]),
	% comprobamos a nivel de columna
	comprobarColumna(C41, [C21,C31,C11]), comprobarColumna(C42, [C22,C32,C12]), comprobarColumna(C43, [C23,C33,C13]), comprobarColumna(C44, [C24,C34,C14]),
	% contador
	% incrementamos en 1 el contador
	comptador(X), X1 is X+1, 	
	% borramos el contador anterior
	retract(comptador(X)), 		
	% ponemos el nuevo
	asserta(comptador(X1)), 	
	fail.

% Función que devuelve una lista con todos los elementos cambiados de posición
	
permutacio([],[]).
permutacio([X|Y],Z):-
	permutacio(Y,L),
    inserir(X,L,Z).
	
% Función que devuelve una lista con los elementos de otra introducidos en ella

inserir(E,L,[E|L]).
inserir(E,[X|Y],[X|Z]):-
	inserir(E,Y,Z).
	
% Función que comprueba si un elemento pertenece a una lista
	
pertany(X,[X|_]).
pertany(X,[_|L]):-pertany(X,L).

% Tiene dos alternativas (condiciones permitidas)
% El primer caso comprueba a ver si la celda contiene la misma letra que la restricción exterior
% El segundo caso comprueba en caso de contener un guión entonces comprueba que la adyacente empiece por la letra
	
comprobarCelda(Celda, Letra, _):-
	Celda = Letra .	
comprobarCelda(Celda, Letra, Celda2):-
	Celda = - ,
	comprobarCelda(Celda2, Letra, _).
	
% Devuelve true si en la columna la celda introducida es la única que contiene esa letra 	
	
comprobarColumna(Celda, Columna):-
	not(pertany(Celda, Columna)).
	
% Contador de soluciones. Llama al método que busca soluciones sin restricciones externas
	
comptar:- asserta(comptador(0)), lletresSinRestricciones.
comptar:- 
	nl, write("Hi ha "),
	comptador(X),
	write(X), write(" resultats").
	
% Método para imprimir por pantalla el tablero solución
	
imprimirTablero([E11,E12,E13,E14],[E21,E22,E23,E24],[E31,E32,E33,E34],[E41,E42,E43,E44], F1, F2, F3, F4):-
	nl,
    write("   "),write(E11),write(" "),write(E12),write(" "),write(E13),write(" "),write(E14), write(" "),nl,
    write(E44),write(" "),write(F1),write(" "), write(E21),nl,
    write(E43),write(" "),write(F2),write(" "), write(E22),nl,
    write(E42),write(" "),write(F3),write(" "), write(E23),nl,
    write(E41),write(" "),write(F4),write(" "), write(E24),nl,
    write("   "),write(E34),write(" "),write(E33),write(" "),write(E32),write(" "),write(E31), write(" "),nl.
