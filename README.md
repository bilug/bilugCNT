
Il programma **bilugCNT** gestisce le scritture di contabilita' generale in
partita doppia e le relative elaborazioni, la contabilita' magazzino,
clienti, fornitori nonche' la chiusura annuale di bilancio con riporto
patrimoniali a nuovo esercizio.

E' destinato principalmente a contabilita' personali, familiari o di
piccole aziende.

L'applicativo e' in script bash, l'interfaccia grafica e' il terminale
xterm.

Puo' funzionare anche con la sola console testuale modificando le chiamate
a xterm e la dimensione dei caratteri per permettere la corretta lettura
degli output delle query.

Richiede risorse di macchina estremamente modeste e funziona ottimamente
anche su macchine molto vecchie e limitate.

E' costituito dai seguenti moduli:

- `cnt1.sh`     ->     *menu principale*
- `cntbil.sh`   ->     *bilancio annuale*
- `cntcli.sh`   ->     *clienti*
- `cntfor.sh`   ->     *fornitori*
- `cntmag.sh`   ->     *magazzino*

- `ESEGUIMI.sh`  ->    *installatore dell'applicazione*
- `LEGGIMI.txt`  ->    *documentazione di installazione*

L'applicativo richiama le funzioni dei seguenti programmi normalmente
disponibili nelle distribuzioni Linux:

  - interprete `bash`
  - `sqlite3`
  - `xterm`
  - `cups`

L'esecuzione dell'installer `ESEGUIMI.sh` verifica l'esistenza di `xterm` ed
`sqlite3` ed altrimenti ne richiede l'installazione.

Se non si e' interessati alla stampa si puo' omettere l'installazione di
cups

Per l'installazione aprire un terminale con diritti di root, avviare il
programma `ESEGUIMI.sh` e seguirne la procedura.


PERSONALIZZAZIONE
-----------------

inserire i codici dei conti
inserire i codici di operazione

Questa contabilita' e' in partita doppia ed applica le seguenti
convenzioni nella definizione del nome dei conti e nell'immissione degli
importi:

|categoria conto        |segno      |iniziale
--- | --- | ---
|*economico costo*            |**+**|            **c**
|*economico ricavo*           |**-**|            **r**
|*patrimoniale attivo*        |**+**|            **a**
|*patrimoniale passivo*       |**-**|            **p**
|*patrimonio netto*           |**-**|            **cn**

separazione decimali:      **.**
formato data:            **aammgg**   (e' il formato unificato ISO)

Il programma esegue automaticamente la somma di piu' importi.
Esempi del formato di immissione degli importi:

 *xxx.xx-yy.y+zz*     **xxx.x*yy**     **-xx.xx/y**


UTILIZZO
--------

Ogni immissione deve venire confermata con (`Invio`)

Questi comandi non sono indicati ma sono sempre attivi:

(`<`)  ritorno all' immissione precedente
(`<<`) ritorno all' inizio del modulo di programma

Ad ogni avvio il programma verifica l' esistenza di squadrature nella
contabilita' affinche' possano immediatamente essere effettuate le
rettifiche delle scritture errate.

Inviate osservazioni e proposte di modifica direttamente in mailing list
pubblica bilug: [https://www.bilug.it/argo/associazione-10/news/mailing-list-bilug-232/](https://www.bilug.it/argo/associazione-10/news/mailing-list-bilug-232/)

Crediti: vallini.daniele@bilug.it