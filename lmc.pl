%%%% -*- Mode: Prolog -*-

%%%% Fermini Simone 830748
%%%% Poveromo Marco 830626
%%%% Zorat Lorenzo  830641

%%%% Start of file: lmc.pl


%%% is_state/1
%%% Prende in input uno stato e restituisce true se rispetta i
%%% parametri, false altrimenti.
is_state(state(Acc, Pc, Mem, In, Out, flag)) :-
    Acc >= 0,
    Acc =< 999,
    Pc >= 0,
    Pc =< 99,
    is_list_ok(In),
    is_list_ok(Out),
    length(Mem, 100),
    is_list_ok(Mem),
    !.

is_state(state(Acc, Pc, Mem, In, Out, noflag)) :-
    Acc >= 0,
    Acc =< 999,
    Pc >= 0,
    Pc =< 99,
    is_list_ok(In),
    is_list_ok(Out),
    length(Mem, 100),
    is_list_ok(Mem),
    !.


%%% is_list_ok/1
%%% Controlla se la lista rispetta i parametri richiesti.
is_list_ok([]) :-
    !.

is_list_ok([X | Xs]) :-
    X >= 0,
    X =< 999,
    is_list_ok(Xs),
    !.


%%% one_instruction/2
%%% Prendendo in input uno state, in base al valore contenuto in mem,
%%% esegue una particolare operazione. Il risultato genera un nuovo
%%% state.

%%% Addizione
one_instruction(state(Acc, Pc, Mem, In, Out, _),
                state(NAcc, NPc, Mem, In, Out, flag)) :-
    agg_pc(Pc, NPc),
    nth0(Pc, Mem, Num, _),
    number_istr(Num, 1, Reg),
    nth0(Reg, Mem, Num1, _),
    NAcc1 is Acc + Num1,
    NAcc1 > 999,
    NAcc is NAcc1 mod 1000,
    !.

one_instruction(state(Acc, Pc, Mem, In, Out, Flag),
                state(NAcc, NPc, Mem, In, Out, Flag)) :-
    agg_pc(Pc, NPc),
    nth0(Pc, Mem, Num, _),
    number_istr(Num, 1, Reg),
    nth0(Reg, Mem, Num1, _),
    NAcc is Acc + Num1,
    NAcc < 1000,
    !.

%%% Sottrazione
one_instruction(state(Acc, Pc, Mem, In, Out, _),
                state(NAcc, NPc, Mem, In, Out, flag)) :-
    agg_pc(Pc, NPc),
    nth0(Pc, Mem, Num, _),
    number_istr(Num, 2, Reg),
    nth0(Reg, Mem, Num1, _),
    NAcc1 is Acc - Num1,
    NAcc1 < 0,
    NAcc is NAcc1 mod 1000,
    !.

one_instruction(state(Acc, Pc, Mem, In, Out, Flag),
                state(NAcc, NPc, Mem, In, Out, Flag)) :-
    agg_pc(Pc, NPc),
    nth0(Pc, Mem, Num, _),
    number_istr(Num, 2, Reg),
    nth0(Reg, Mem, Num1, _),
    NAcc is Acc - Num1,
    NAcc >= 0,
    !.

%%% Store
one_instruction(state(Acc, Pc, Mem, In, Out, Flag),
                state(Acc, NPc, NMem, In, Out, Flag)) :-
    agg_pc(Pc, NPc),
    nth0(Pc, Mem, Num, _),
    number_istr(Num, 3, Reg),
    !,
    nth0(Reg, Mem, _, List),
    nth0(Reg, NMem, Acc, List).

%%% Load
one_instruction(state(_, Pc, Mem, In, Out, Flag),
                state(Num1, NPc, Mem, In, Out, Flag)) :-
    agg_pc(Pc, NPc),
    nth0(Pc, Mem, Num, _),
    number_istr(Num, 5, Reg),
    !,
    nth0(Reg, Mem, Num1, _).

%%% Branch
one_instruction(state(Acc, Pc, Mem, In, Out, Flag),
                state(Acc, Reg, Mem, In, Out, Flag)) :-
    nth0(Pc, Mem, Num, _),
    number_istr(Num, 6, Reg),
    !.

%%% Branch if zero
one_instruction(state(Acc, Pc, Mem, In, Out, Flag),
                state(Acc, Reg, Mem, In, Out, Flag)) :-
    nth0(Pc, Mem, Num, _),
    number_istr(Num, 7, Reg),
    Acc = 0,
    Flag = 'noflag',
    !.

%%% Branch if zero, con Acc != 0 -> fallisce
one_instruction(state(Acc, Pc, Mem, In, Out, Flag),
                state(Acc, NPc, Mem, In, Out, Flag)) :-
    agg_pc(Pc, NPc),
    nth0(Pc, Mem, Num, _),
    number_istr(Num, 7, _),
    Acc > 0,
    !.

%%% Branch if zero, con Flag = flag -> fallisce
one_instruction(state(Acc, Pc, Mem, In, Out, Flag),
                state(Acc, NPc, Mem, In, Out, Flag)) :-
    agg_pc(Pc, NPc),
    nth0(Pc, Mem, Num, _),
    number_istr(Num, 7, _),
    Flag = 'flag',
    !.

%%% Branch if positive
one_instruction(state(Acc, Pc, Mem, In, Out, Flag),
                state(Acc, Reg, Mem, In, Out, Flag)) :-
    nth0(Pc, Mem, Num, _),
    number_istr(Num, 8, Reg),
    Flag = 'noflag',
    !.

%%% Branch if positive con Flag = flag -> fallisce
one_instruction(state(Acc, Pc, Mem, In, Out, Flag),
                state(Acc, NPc, Mem, In, Out, Flag)) :-
    agg_pc(Pc, NPc),
    nth0(Pc, Mem, Num, _),
    number_istr(Num, 8, _),
    Flag = 'flag',
    !.

%%% Halt
one_instruction(state(Acc, Pc, Mem, In, Out, Flag),
                halted_state(Acc, NPc, Mem, In, Out, Flag)) :-
    agg_pc(Pc, NPc),
    nth0(Pc, Mem, Num, _),
    number_istr(Num, 0, _),
    !.

%%% Input con lista vuota
one_instruction(state(Acc, Pc, Mem, In, Out, Flag),
                error_state_input(Acc, NPc, Mem, In, Out, Flag)) :-
    agg_pc(Pc, NPc),
    nth0(Pc, Mem, Num, _),
    number_istr(Num, 9, 1),
    In = [],
    !.

%%% Input
one_instruction(state(_, Pc, Mem, [X | In], Out, Flag),
                state(X, NPc, Mem, In, Out, Flag)) :-
    agg_pc(Pc, NPc),
    nth0(Pc, Mem, Num, _),
    number_istr(Num, 9, 1),
    X \= [],
    !.

%%% Output
one_instruction(state(Acc, Pc, Mem, In, Out, Flag),
                state(Acc, NPc, Mem, In, Out1, Flag)) :-
    agg_pc(Pc, NPc),
    nth0(Pc, Mem, Num, _),
    number_istr(Num, 9, 2),
    append(Out, [Acc], Out1),
    !.

%%% Istruzione non valida (comincia per 4)
one_instruction(state(Acc, Pc, Mem, In, Out, Flag),
                error_state_istr(Acc, NPc, Mem, In, Out, Flag)) :-
    agg_pc(Pc, NPc),
    nth0(Pc, Mem, Num, _),
    Num >= 400,
    Num =< 499,
    !.

%%% Istruzione non valida (diversa da 901 e 902)
one_instruction(state(Acc, Pc, Mem, In, Out, Flag),
                error_state_istr(Acc, NPc, Mem, In, Out, Flag)) :-
    agg_pc(Pc, NPc),
    nth0(Pc, Mem, Num, _),
    Num > 902,
    !.

%%% Istruzione non valida (uguale a 900)
one_instruction(state(Acc, Pc, Mem, In, Out, Flag),
                error_state_istr(Acc, NPc, Mem, In, Out, Flag)) :-
    agg_pc(Pc, NPc),
    nth0(Pc, Mem, Num, _),
    Num = 900,
    !.


%%% agg_pc/2
%%% Aggiorna il PC a PC+1

%%% agg_pc(PC precedente è 99)
agg_pc(99, 0) :-
    !.

%%% agg_pc(Generico)
agg_pc(Pc, NPc) :-
    Pc < 99,
    NPc is Pc + 1,
    !.


%%% number_instr/3
%%% Converte l'intero (Num) nel numero dell'istruzione da
%%% eseguire (Istr) e nel numero del registro (Reg).

%%% number_istr (Num compreso tra 0 e 9)
number_istr(Num, 0, Num) :-
    integer(Num),
    atom_length(Num, 1),
    !.

%%% number_istr (Num compreso tra 10 e 99)
number_istr(Num, 0, Num) :-
    integer(Num),
    atom_length(Num, 2),
    !.

%%% number_istr (Num compreso tra 100 e 999)
number_istr(Num, Istr, Reg) :-
    integer(Num),
    atom_length(Num, 3),
    sub_atom(Num, 0, _, _, Istr1),
    atom_number(Istr1, Istr),
    Istr100 is Istr * 100,
    Reg is Num - Istr100,
    !.


%%% execution_loop/2
%%% Prende in input lo stato iniziale del programma e restituisce la
%%% coda di output nel momento in cui incontra un halted_state

%%% execution_loop (Generico, continua a ciclare)
execution_loop(state(Acc, Pc, Mem, In, Out, Flag), Out2) :-
    is_state(state(Acc, Pc, Mem, In, Out, Flag)),
    one_instruction(state(Acc, Pc, Mem, In, Out, Flag), NewState),
    NewState = state(_, _, _, _, _, _),
    execution_loop(NewState, Out2),
    !.

%%% execution_loop (Si ferma quando incontra un halted state)
execution_loop(state(Acc, Pc, Mem, In, Out, Flag), Out2) :-
    is_state(state(Acc, Pc, Mem, In, Out, Flag)),
    one_instruction(state(Acc, Pc, Mem, In, Out, Flag), NewState),
    NewState = halted_state(_, _, _, _, Out2, _),
    !.

%%% execution_loop (Si ferma quando incontra un istruzione non valida)
execution_loop(state(Acc, Pc, Mem, In, Out, Flag),
               "Errore: istruzione non esistente! ") :-
    is_state(state(Acc, Pc, Mem, In, Out, Flag)),
    one_instruction(state(Acc, Pc, Mem, In, Out, Flag), NewState),
    NewState = error_state_istr(_, _, _, _, _, _),
    !.

%%% execution_loop (Si ferma se esegue l'istruzione 901 con la coda di
%%% input vuota)
execution_loop(state(Acc, Pc, Mem, In, Out, Flag),
               "Errore: comando 901 con lista input vuota! " ) :-
    is_state(state(Acc, Pc, Mem, In, Out, Flag)),
    one_instruction(state(Acc, Pc, Mem, In, Out, Flag), NewState),
    NewState = error_state_input(_, _, _, _, _, _),
    !.


%%% ISTRUZIONI CODIFICATE
istr("add", 100).
istr("sub", 200).
istr("sta", 300).
istr("lda", 500).
istr("bra", 600).
istr("brz", 700).
istr("brp", 800).
istr("inp", 901).
istr("out", 902).
istr("hlt", 0).
istr("dat").

%%% lmc_run/3
%%% Dato in input un file contenente istruzioni in codice assembly
%%% esegue tutte le operazioni del little man compueter e restituisce la
%%% coda di output.
lmc_run(Directory, Input, Output) :-
    lmc_load(Directory, Mem),
    is_list(Input),
    execution_loop(state(0, 0, Mem, Input, [], noflag), Output).


%%% lmc_load/2
%%% Prende in input un file contenente istruzioni in codice assembly e
%%% restituisce una memoria costituita da codice macchina lmc decimale.
%%% Il predicato prima suddivide il file in righe, successivamente
%%% rimuove i commenti e le righe vuote. Asserisce tutte le label, le
%%% cancella e traduce le istruzioni in numeri tramite il predicato
%%% compiler/2. Infine restituisce la memoria.
lmc_load(Directory, Mem2) :-
    retractall(label(_,_)), %elimina vecchie label
    open(Directory, read, In), %Apre il file
    read_string(In, _, AsmText), %Legge il contenuto
    close(In), %Chiude il file
    %% split_string/4 divide il testo originale assembly in righe
    split_string(AsmText, "\n", " ", Split),
    %% remove_comments/2 separa il codice dai commenti
    remove_comments(Split, SplitNoComm),
    %% delete/3 cancella le righe vuote in eccesso
    delete(SplitNoComm, "", SplitNoCommEmptyLine),
    %% label_picker/3 prende tutte le label e le separa dal codice
    labels_picker(SplitNoCommEmptyLine, SplitNoLabel, 0),
    %% compiler/2 analizza il codice e produce la parte di memoria
    compiler(SplitNoLabel, Mem),
    %% padding/2 completa il contenuto della memoria a 99 elementi
    padding(Mem, Mem2).


%%% compiler/2
%%% Scorre la lista e invoca il predicato verify/2 su ogni elemento, uno
%%% per uno. Ogni elemento è tradotto in numero.
compiler([X | Xs], [LMC_Code | Mem2]) :-
    compiler(Xs, Mem2),
    verify(X, LMC_Code),
    !.

compiler([], []) :-
    !.


%%% verify/2
%%% Posso avere due casi, il primo ho una sola stringa che corrisponde
%%% all'istruzione, ne secondo caso ho una stringa e un valore (label o
%%% valore numerico).
%%% To down case traduce tutto in minuscolo

%%% verify (Se l'istruzione ha un 'parametro')
%%% caso 1: inp
verify(X, LMC_Code) :-
    split_string(X, " ", " ", Y),
    length(Y, 1),
    nth0(0, Y, Z),
    string_lower(Z, LowerCase),
    LowerCase = "inp",
    istr(LowerCase, LMC_Code),
    !.

%%% caso 2: out
verify(X, LMC_Code) :-
    split_string(X, " ", " ", Y),
    length(Y, 1),
    nth0(0, Y, Z),
    string_lower(Z, LowerCase),
    LowerCase = "out",
    istr(LowerCase, LMC_Code),
    !.

%%% caso 3: hlt
verify(X, LMC_Code) :-
    split_string(X, " ", " ", Y),
    length(Y, 1),
    nth0(0, Y, Z),
    string_lower(Z, LowerCase),
    LowerCase = "hlt",
    istr(LowerCase, LMC_Code),
    !.

%%% caso 4: dat
verify(X, LMC_Code) :-
    split_string(X, " ", " ", Y),
    length(Y, 1),
    nth0(0, Y, Z),
    string_lower(Z, LowerCase),
    istr(LowerCase),
    LMC_Code = 0, !.

%%% verify (Se l'istruzione ha due 'parametri')
%%% caso 1: "istruzione" "numero"
verify(X, LMC_Code) :-
    split_string(X, " ",  " ", Y),
    length(Y, 2),
    nth0(0, Y, Z),
    string_lower(Z, LowerCase),
    LowerCase \= "inp",
    LowerCase \= "out",
    LowerCase \= "hlt",
    istr(LowerCase, N),
    nth0(1, Y, A),
    number_string(C, A),
    C < 100,
    C >= 0,
    LMC_Code is N + C,
    !.

%%% caso 2: cerca la label nei fatti e se la trova assegna l'istruzione
verify(X, LMC_Code) :-
    split_string(X, " ",  " ", Y),
    length(Y, 2),
    nth0(0, Y, Z),
    string_lower(Z, LowerCase),
    istr(LowerCase, N),
    nth0(1, Y, A),
    string_lower(A, B),
    label(B, NumLabel),
    NumLabel < 100,
    NumLabel >= 0,
    LMC_Code is N + NumLabel,
    !.

%%% caso 3: dat "numero"
verify(X, LMC_Code) :-
    split_string(X, " ",  " ", Y),
    length(Y, 2),
    nth0(0, Y, Z),
    string_lower(Z, LowerCase),
    istr(LowerCase),
    nth0(1, Y, A),
    number_string(LMC_Code, A),
    LMC_Code < 1000,
    LMC_Code >= 0,
    !.


%%% label_picker/3
%%% Rimuove i commenti e toglie le labels, se presenti, e fa un assert
%%% nel programma logico della label e del corrispettivo numero di riga
%%% a partire ovviamente da 0.

%%% caso 1: se il numero di righe e <=100
labels_picker([], [], N) :-
    N =< 100,
    !.

%%% caso 2: Generico
labels_picker([X | Xs], [NoLabelRow | B], N) :-
    N2 is N + 1,
    labels_picker(Xs, B, N2),
    split_string(X, " ", " ", Row2),
    verify_label(Row2, NoLabelRow, N).


%%% verify_label/3
%%% verify_label prende in input una riga del programma asm, se trova
%%% una label la asserisce nel programma logico con il relativo numero
%%% della riga associato.

%%% caso 1: Se la lunghezza della riga è 3
verify_label(Row, NoLabelRow2, N) :-
    length(Row, 3),
    !,
    nth0(0, Row, Label, NoLabelRow),
    sub_string(Label, 0, 1, _, FirstChar),
    not(char_type(FirstChar, digit)),
    string_lower(Label, LowerLabel),
    not(label(LowerLabel, _Q)),
    unify_strings(NoLabelRow, NoLabelRow2),
    assert(label(LowerLabel, N)).

%%% caso 2: Se la lunghezza è 2 e il secondo è un 'istr'
verify_label(Row, X, N) :-
    length(Row, 2),
    nth0(1, Row, X),
    string_lower(X, Lower),
    istr(Lower, _Num),
    !,
    nth0(0, Row, Label),
    sub_string(Label, 0, 1, _, FirstChar),
    not(char_type(FirstChar, digit)),
    string_lower(Label, LowerLabel),
    not(label(LowerLabel, _Q)),
    assert(label(LowerLabel, N)).

%%% caso 3: Se la lunghezza è 2 e la prima è un 'dat'
verify_label(Row, X, N) :-
    length(Row, 2),
    nth0(1, Row, X),
    string_lower(X, Lower),
    istr(Lower),
    !,
    nth0(0, Row, Label),
    sub_string(Label, 0, 1, _, FirstChar),
    not(char_type(FirstChar, digit)),
    string_lower(Label, LowerLabel),
    not(label(LowerLabel, _Q)),
    assert(label(LowerLabel, N)).

%%% caso 4: Se la lunghezza è 2 e non ci sono label (è un istruzione)
verify_label(Row, Row2, _N) :-
    length(Row, 2),
    !,
    unify_strings(Row, Row2).

%%% caso 5: Se la lunghezza è 1 (è un istruzione)
verify_label(Row, Row2, _N) :-
    length(Row, 1),
    !,
    nth0(0, Row, Row2).


%%% unify_string/2
%%% unifica le stringhe di una lista, cioè esegue l'append di due
%%% stringhe
unify_strings([], "").

unify_strings([X | Xs], String) :-
    unify_strings(Xs, String2),
    string_concat(X, " ", S),
    string_concat(S, String2, String).


%%% remove_comments/2
%%% Rimuove tutti i commenti dal file asm (da ogni riga)
remove_comments([],[]) :-
    !.

remove_comments([X | Xs], [Z | L]) :-
    remove_comments(Xs, L),
    split_string(X, "//", " ", Y),
    nth0(0, Y, Z).

%%% padding/2
%%% Riempie la memoria (solamente le restanti n celle a 0)

%%% caso 1: La memoria è gia di 100 elementi
padding(Mem, Mem) :-
    length(Mem, Length),
    Length = 100,
    !.

%%% caso 2: Memoria non di 100 elementi
padding(Mem, Mem2) :-
    length(Mem, Length),
    N is 100 - Length,
    gen_rest(N, Rest, 0),
    append(Mem, Rest, Mem2).

%%% gen_rest/3
%%% è una funzione helper per padding ovvero genera tutti gli 0 mancanti
gen_rest(N, [], N) :-
    !.

gen_rest(N, [0 | Rest], N2) :-
    N3 is N2 + 1,
    gen_rest(N, Rest, N3),
    !.


%%%% End of file: lmc.pl





