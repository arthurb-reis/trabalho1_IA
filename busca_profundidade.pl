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
    % nth0() Varre a matriz Disponibilidades e associa o index da linha a variável Disciplina
    	% e a linha atual a variável LinhaAtual
    nth0(Disciplina, Disponibilidades, LinhaAtual),
    % Retorna o Valor do elemento de index Nro da LinhaAtual
    nth0(Nro, LinhaAtual, Valor),
    Valor =:= 1.

%Decrementa um no valor da posição relacionada a disciplina
decrementar_um([], _, []).
decrementar_um([Elemento|Resto], 0, [NovoElemento|Resto]) :-
    NovoElemento is Elemento - 1, !.
decrementar_um([Elemento|Resto], N, [Elemento|NovaLista]) :-
    N > 0,
    N1 is N - 1,
    decrementar_um(Resto, N1, NovaLista).

%Verifica se a quantidade de horário necessarios para a disciplina é maior que zero
verifica_horario_necessario(H, Lista) :-
    nth0(H, Lista, Valor),
    Valor > 0.

%Função chamada:
alocar(Lista) :-
    alocar(Lista, 0, [4,4,3,3,3,3,3,2]).

%Função principal:
alocar([], 25, _). %Se chegou no ultimo horário, lista vazia
alocar([H|Resto], Nro_horario, Horarios_necessarios) :-
    disponivel(Nro_horario, H), %Verifica qual prof está disponível no horário Nro_horario
    verifica_horario_necessario(H, Horarios_necessarios), %Verifica se o prof ainda precisa de horário
    decrementar_um(Horarios_necessarios, H, Novos_horarios_necessarios), %Decrementa um na necessidade de horário desse prof
    NovoNroHorario is Nro_horario + 1, %Vai para o próximo horário e chama a recursão
    alocar(Resto, NovoNroHorario, Novos_horarios_necessarios).

%Exemplo de teste: ?- alocar(Lista, 0, [4,4,3,3,3,3,3,2]).
