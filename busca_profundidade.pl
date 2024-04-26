disponibilidade_professores([
    [1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    [1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1],
    [0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1]
]).

% Recebe o nro do horário e retorna o nro da disciplina disponível nesse horário
disponivel(Nro, Disciplina) :-
    % Atribui a matriz a Disponibilidades
    disponibilidade_professores(Disponibilidades),
    % nth0(?Index, ?List, ?Elem)
    % Varre a matriz Disponibilidades e associa o index da linha a variável Disciplina
    	% e a linha atual a variável LinhaAtual
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
    disponivel(Nro_horario, H),
    verifica_horario_necessario(H, Horarios_necessarios),
    decrementar_um(Horarios_necessarios, H, Novos_horarios_necessarios),
    NovoNroHorario is Nro_horario + 1,
    alocar(Resto, NovoNroHorario, Novos_horarios_necessarios).

%Exemplo de teste: ?- alocar(Lista, 0, [4,4,3,3,3,3,3,2]).
