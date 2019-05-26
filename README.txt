	 ___         _____    _____     _________
	|   |       |     \  /     |   |         |
	|   |       |      \/      |   |    _____|
	|   |       |   |\    /|   |   |   |
	|   |       |   | \__/ |   |   |   |
	|   |___    |   |      |   |   |   |_____
	|       |   |   |      |   |   |         |
	|_______|   |___|      |___|   |_________|


SVILUPPATO DA
Poveromo Marco	- 830626
Zorat Lorenzo	- 830641
Fermini Simone	- 830748

LITTLE MAN COMPUTER
Il little man computer (LMC) e' un semplice modello di computer a istruzioni
creato, nel nostro caso, per scopi didattici. Questo permette di gestire una 
memoria e puo' avere in input un file assembly che richiede di eseguire una
sequenza di istruzioni. Questo LMC e' implementato in linguaggio PROLOG.

ESECUZIONE
Per eseguire l'lmc da ambiente Prolog con in input il file esempio.asm
e' necessario richiamare la funzione lmc_run/3 con parametri la directory del 
file e l'input richiesto dal programma inserito in una lista. 
Come segue: lmc_run("directory", [input], Out).
Esempio:
?- lmc_run("C:/Users/utente/Desktop/esempio.asm", [5, 4], Out).
Out = [1].

?- 

ESEMPIO DI FILE DI INPUT
Programma .asm che sottrae due numeri.
- Start of file -- esempio.asm --
INP
STA FIRST
INP
STA SECOND
LDA FIRST
SUB SECOND
OUT
HLT
FIRST DAT
SECOND DAT
- End of file -- esempio.asm --

AVVERTENZE
- Nell'addizione e nella sottrazione i numeri sono calcolati in modulo 1000.
- Se il risultato di una addizione o di una sottrazione viene rispettivamente
  > 1000 o < 0, viene settato il flag a presente.
- La lista di input e' valida solo con numeri < 1000 non negativi.
- Se il file .asm contiene istruzioni non valide l'lmc genera un errore.
- Le istruzioni assembly consentite sono: ADD, SUB, STA, LDA, BRA, BRZ, BRP, 
  INP, OUT, HLT, DAT.
- Assembly per lmc e' case-insensitive.
- Le label numeriche, anche se consentite, potrebbero causare ambiguita'. 
  Sconsigliato l'uso.
- Non si possono assegnare due label uguali.
- Il file di input puo' avere qualsiasi estensione, l'importante e' che 
  contenga codice assembly all'interno.

FILE NELLA DIRECTORY
- lmc.pl
- README.txt

INFO
Progetto creato per il Corso di Linguaggi di Programmazione dell'Universita'
di Milano Bicocca. 
Per il testo completo dell'esercizio (L'URL necessita di login):
https://elearning.unimib.it/pluginfile.php/549456/mod_resource/content/
24/LP%20201901%20E1P%20LMC.pdf

CONTACT
s.fermini@campus.unimib.it
m.poveromo@campus.unimib.it
l.zorat@campus.unimib.it

VERSIONE
1.0