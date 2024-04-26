disponibilidade_professores([
    [1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0],
    [1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1],
    [0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1]
]).

% Heuristica professor com mais necessidade de horários antes *************
ordenar_prioridades([],[]) :- !.
ordenar_prioridades([X|Cauda], PrioridadesOrdenada) :-
    particionar(X, Cauda, Menor, Maior),
    ordenar_prioridades(Menor, MenorOrd),
    ordenar_prioridades(Maior, MaiorOrd),
    concatenar(MaiorOrd, [X|MenorOrd], PrioridadesOrdenada).

particionar(_, [], [], []) :- !.
particionar(X, [Y|Resto], [Y|Menor], Maior) :-
    maior(X,Y),
    !,
    particionar(X, Resto, Menor, Maior).

particionar(X, [Y|Resto], Menor, [Y|Maior]) :-
    particionar(X, Resto, Menor, Maior).

maior([_,X], [_,Y]) :-
    X > Y.

concatenar([], ListaFinal, ListaFinal).
concatenar([Elem|Resto], Maior, [Elem|ListaFinal]) :-
    concatenar(Resto, Maior, ListaFinal).

criar_prioridades(Prioridades, Horarios_necessarios) :-
    criar_vetor(Horarios_necessarios, Lista),
    ordenar_prioridades(Lista, PrioridadesComValores),
	prioridades_index(PrioridadesComValores, Prioridades).

criar_vetor([], []).
criar_vetor(Lista, Vetores) :-
    criar_vetor(Lista, 0, Vetores).

criar_vetor([], _, []).
criar_vetor([X|Xs], Index, [[Index,X]|Resto]) :-
    NovoIndex is Index + 1,
    criar_vetor(Xs, NovoIndex, Resto).

prioridades_index([],[]).
prioridades_index([[X,_]|RestoPrioridadesComValores], [X|RestoPrioridades]) :-
	prioridades_index(RestoPrioridadesComValores, RestoPrioridades).
    
soma([], 0).
soma([Elem|Cauda], S) :-
    soma(Cauda, S1),
    S is S1+Elem.
%Fim da heurística *******************************************************

ver_prioridade([X|_], X).
ver_prioridade([_|Resto], Elemento) :-
    ver_prioridade(Resto, Elemento).

% Recebe o nro do horário e retorna o nro da disciplina disponível nesse horário
disponivel(Nro, Disciplina, Horarios_necessarios) :-
    % Atribui a matriz a Disponibilidades
    disponibilidade_professores(Disponibilidades),
    % nth0(?Index, ?List, ?Elem)
    % Varre a matriz Disponibilidades e associa o index da linha a variável Disciplina
    	% e a linha atual a variável LinhaAtual
    criar_prioridades(Prioridades, Horarios_necessarios), % Para busca em profundidade, comente
    ver_prioridade(Prioridades, Disciplina), % Para busca em profundidade, comente
    nth0(Disciplina, Disponibilidades, LinhaAtual),
    % Retorna o Valor do elemento de index Nro da LinhaAtual
    nth0(Nro, LinhaAtual, Valor),
    Valor =:= 1.
    
decrementar_um([], _, []).
decrementar_um([Elemento|Resto], 0, [NovoElemento|Resto]) :-
    NovoElemento is Elemento - 1, !.
decrementar_um([Elemento|Resto], N, [Elemento|NovaLista]) :-
    N > 0,
    N1 is N - 1,
    decrementar_um(Resto, N1, NovaLista).

verifica_horario_necessario(H, Lista) :-
    nth0(H, Lista, Valor),
    Valor > 0.

alocar(Lista) :-
    alocar(Lista, 0, [4,4,3,3,3,3,3,2]).

alocar([], 25, _).
alocar([H|Resto], Nro_horario, Horarios_necessarios) :-
    disponivel(Nro_horario, H, Horarios_necessarios),
    verifica_horario_necessario(H, Horarios_necessarios),
    decrementar_um(Horarios_necessarios, H, Novos_horarios_necessarios),
    NovoNroHorario is Nro_horario + 1,
    alocar(Resto, NovoNroHorario, Novos_horarios_necessarios).

%Exemplo de teste: ?- alocar(Lista, 0, [4,4,3,3,3,3,3,2]).
