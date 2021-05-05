#! /bin/bash

# colorazione con sequenze ANSI

nn="[0;0;01m"    # fondo nero
rr="[0;0;41m"    # fondo ross
vv="[0;0;42m"    # fondo verde
gg="[0;0;43m"    # fondo giallo
bb="[0;0;44m"    # fondo blu
mm="[0;0;45m"    # fondo magenta
cc="[0;0;46m"    # fondo cyan

rn="[0;31;40m"   # rosso su nero
Rn="[1;31;40m"   # rosso grassetto su nero
vn="[0;32;40m"   # verde su nero
Vn="[1;32;40m"   # verde grassetto su nero
gn="[0;33;40m"   # giallo su nero
Gn="[1;33;40m"   # giallo grassetto su nero
bn="[0;34;40m"   # blu su nero
Bn="[1;34;40m"   # blu grassetto su nero
mn="[0;35;40m"   # magenta su nero
Mn="[1;35;40m"   # magenta grassetto su nero
cn="[0;36;40m"   # cyan su nero
Cn="[1;36;40m"   # cyan grassetto su nero

z="[0m";         # normale

ini1(){
clear
echo "
$vn

  Questo file eseguibile e' parte del programma di contabilita' scritto e
  mantenuto da Daniele Vallini del Gruppo Linux di Biella (BiLUG)

$rn   vallini.daniele@bilug.it          www.bilug.it $vn

  Il programma e' stato curato e collaudato da tempo ma viene fornito
  privo di qualsiasi garanzia poiche' e' compito dell' utilizzatore
  verificarne l' adeguatezza alle proprie esigenze.

  Il programma e' liberamente utilizzabile nei termini della licenza GPL3

$rn   http://www.gnu.org/licenses/gpl.txt $vn

  Il codice puo' essere liberamente modificato ed adattato ma questo
  commento introduttivo deve essere mantenuto

  E' gradita ogni forma di collaborazione segnalando commenti, sviluppi ed
  integrazioni al Gruppo Linux di Biella - BiLUG, mailing list pubblica:

$rn  linux@ml.bilug.linux.it


$Rn   (+) $gn procedo
$Rn   (-) $gn abbandono

$gn        CONFERMARE OGNI OPZIONE CON $rn Invio
"
read x
case $x in
"+") ini2;;
"-") exit;;
esac
ini1
}

ini2(){
clear

echo "
$vn
  Il programma di installazione esegue le seguenti operazioni:

$gn - verifica la presenza dei programmi:
$rn
  - xterm
  - sqlite3

$gn - crea l'utente cnt,

$gn - inserisce in /home/cnt i moduli del programma di contabilita':
$rn
   - cnt1.sh      (avvio)
   - cntbil.sh    (bilanci)
   - cntcli.sh    (clienti)
   - cntfor.sh    (fornitori)
   - cntgen.sh    (generale)
   - cntmag.sh    (magazzino)

   - ESEGUIMI.sh  (installatore dell'applicativo)
   - LEGGIMI.txt  (documentazione di installazione)

$gn - crea il database con le sue tabelle nel file /home/cnt/cnt.db:
$rn
   - cliana         anagrafe clienti
   - clifat1        fatture clienti parte 1
   - clifat2        fatture clienti parte 2
   - forana         anagrafe fornitori
   - giocon         piano dei conti
   - gioope         codici di operazione contabile
   - giornale       libro giornale
   - magart         articoli di magazzino
   - magazzino      movimenti di magazzino
   - magope         codici di operazione di magazzino


 $Rn (+)  $gn procedo
 $Rn (-)  $gn abbandono
 $Rn (<)  $gn indietro
$z"
read x
case $x in
"+") inst1;;
"-") exit;;
"<") ini1;;
esac
ini2
}

inst1(){
clear
xx=`whoami`
if [ "$xx" = "root" ] 
then
   echo "$vn  OK sei l'utente  $xx, puoi procedere"
   inst2
else 
   echo "
$vn  Sei l'utente $xx, devi essere root per procedere

$gn              Fra 5 secondi esco
"
sleep 5
exit
fi
}

inst2(){
echo "
$vn  verifico l'installazione della console xterm'
"
file=/usr/bin/xterm
if [[ -e $file ]]
then echo "
$gn  OK $file e' installato
"
inst3
else echo "
$vn non esiste $file, provvedi ad installarlo
$vn con il comando $gn apt-get install xterm

$gn          fra 5 secondi esco
"
sleep 5
exit
fi
}

inst3(){
echo "
$vn  verifico l'installazione di sqlite3
$vn  (e' il database)
"
file=/usr/bin/sqlite3
if [[ -e $file ]]
then echo "
$gn  OK $file e' installato
"
inst4
else echo "
$vn non esiste $file, provvedi ad installarlo
$vn con il comando apt-get install sqlite3

$gn           fra 5 secondi esco
"
sleep 5
exit
fi
}

inst4(){
echo "
$vn  Creo il gruppo $rn cnt e l'utente $rn cnt $vn per il quale devi
$vn  immettere la password, gli altri dati richiesti (nome, stanza,
$vn  telefoni, altro) sono facoltativi.

$gn  ATTENZIONE: se utente e gruppo cnt gia' esistono verranno annullati e
$gn  l'utente ricreato con nuova password

$Rn (+)  $gn procedo
$Rn (-)  $gn abbandono
$Rn (<)  $gn indietro
$z"
read x
case $x in
"+") inst5;;
"-") exit;;
"<") inst3
esac
inst4
}

inst5(){
clear
delgroup cnt
deluser cnt
adduser cnt
echo "
$vn installato gruppo cnt ed utente cnt, $gn ricordati la password!
"
inst6
}

inst6(){
echo "
$vn copio ora in /home/cnt i moduli del programma:
$rn
   - cnt1.sh   (avvio)
   - cntbil.sh (bilanci)
   - cntcli.sh (clienti)
   - cntfor.sh (fornitori)
   - cntgen.sh (generale)
   - cntmag.sh (magazzino)

   - ESEGUIMI.sh  (installatore dell'applicazione)
   - LEGGIMI.txt  (documentazione di installazione)

$Rn >>>  $gn immetti la posizione ove si trovano detti file da copiare
$Rn (-)  $gn abbandono
$Rn (<)  $gn indietro
$z
"
read path
case $path in
("")  inst6;;
("-")  exit;;
("<")  inst4;;
esac
inst7
}

inst7(){
path1=/home/cnt
for file in "/cnt1.sh" "/cntbil.sh" "/cntcli.sh" "/cntfor.sh" "/cntgen.sh" "/cntmag.sh" "/ESEGUIMI.sh" "/LEGGIMI.txt"
do
if [[ -e $path$file ]]
then echo "$gn  OK $path$file esiste, copio in /home/cnt"
cp $path$file $path1/$file
else echo "$vn non esiste $path$file"
inst6
fi
done
inst8
}

inst8(){
echo "
$vn  verifico l'installazione dei moduli del programma
"
for file in "/cnt1.sh" "/cntbil.sh" "/cntcli.sh" "/cntfor.sh" "/cntgen.sh" "/cntmag.sh" "/ESEGUIMI.sh" "/LEGGIMI.txt"
do
if [[ -e $path1$file ]]
then echo "$gn  OK $path1$file e' installato"
else echo "$vn non esiste $path1$file"
inst6
fi
done
inst9
}

inst9(){

echo "
$vn  creo ora Il database sqlite3 e creo le tabelle necessarie
"
if [[ -e $path1/cnt.db ]]
  then echo "
  $rn  ATTENZIONE IL DATABASE ESISTE LA NUOVA CREAZIONE COMPORTA
  $rn  LA PERDITA DEI DATI ESISTENTI

  $Rn  (-) $gn Esco e salvo altrove il file /home/cnt/db
  $Rn  (+) $gn Procedo annullando il database esistente
  "
  read x
    case $x in
    "-") exit;;
    "+") rm /home/cnt/cnt.db; inst10;;
    "<") inst8;;
    esac
  else inst10
fi
}

inst10(){

echo > /home/cnt/sql "

CREATE TABLE cliana (
 idcli     TEXT(5)   PRIMARY KEY,
 cliente   TEXT(30)  NOT NULL,
 clien2    TEXT(30),
 via       TEXT(30)  NOT NULL,
 citta    TEXT(30)  NOT NULL,
 piva      TEXT(13)  NOT NULL,
 codfis    TEXT(16),
 listino   INT(1)    NOT NULL,
 pagamen   TEXT(80)  NOT NULL,
 destina   TEXT(30),
 destin2   TEXT(30),
 destvia   TEXT(30),
 destcit   TEXT(30)
);
CREATE TABLE clifat1 (
 nrfat     INT(4)     PRIMARY KEY,
 idcli     TEXT(6)    NOT NULL,
 datafat   TEXT(6)    NOT NULL,
 datatras  TEXT(6)    NOT NULL,
 causale   TEXT(7)    NOT NULL,
 colli     TEXT(3)    NOT NULL,
 trasp     TEXT(12)   NOT NULL
);
CREATE TABLE clifat2 (
 nrfat     INT(4)     NOT NULL,
 datafat   TEXT(6)    NOT NULL,
 idart     TEXT(6)    NOT NULL,
 quanti    INT(5)     NOT NULL,
 prezzo    REAL(6,2)  NOT NULL,
 iva       INT(2)     NOT NULL,
 lotto     TEXT(6)    NOT NULL
);
CREATE TABLE forana (
 idfor     TEXT(5)   PRIMARY KEY,
 fornitore TEXT(30)  NOT NULL,
 via       TEXT(30),
 citta     TEXT(30),
 piva      TEXT(11)  NOT NULL,
 codfis    TEXT(16)
);
 CREATE TABLE giornale (
 data      TEXT(6)  NOT NULL,
 idope     TEXT(4)  NOT NULL,
 idcon     TEXT(10) NOT NULL,
 importo   REAL(12,2),
 nrfat     INT(4),
 idfor     TEXT(6),
 idcli     TEXT(6),
 nota      TEXT(50)
);
CREATE TABLE gioope (
 idope     TEXT(3) PRIMARY KEY,
 operazio  TEXT(25)
);
CREATE TABLE giocon (
 idcon     TEXT(10) PRIMARY KEY,
 conto     TEXT(25)
);
CREATE TABLE magazzino (
 data      TEXT(6),
 idmov     TEXT(4),
 idart     TEXT(6),
 quanti    INT(6),
 prezzo    REAL(10,2),
 nrfat     INT(4),
 lotto     TEXT(6),
 nota      TEXT(50)
);
CREATE TABLE magart (
 idart     TEXT(6) PRIMARY KEY,
 articolo  TEXT(26) NOT NULL ,
 unimis    TEXT(2) NOT NULL,
 aliva     INT(2) NOT NULL,
 costo     REAL(8,2),
 gros1     REAL(8,2),
 gros2     REAL(8,2),
 minuto    REAL(8,2)
);
CREATE TABLE magmov (
 idmov     TEXT(2) PRIMARY KEY,
 movime    TEXT(20) NOT NULL
);"
sqlite3 /home/cnt/cnt.db < /home/cnt/sql

echo "$gn
Definisco l'utente cnt proprietario della directory /home/cnt"
chown -R cnt:cnt /home/cnt/*
echo "$gn
Creo un link simbolico /usr/bin/cnt -> /home/cnt/cnt1.sh"
ln -s /home/cnt/cnt1.sh /usr/bin/cnt
echo "$gn
Fine del processo di installazione del database

Per avviare il programma di contabilita' apri una console xterm, a pieno
schermo, con i poteri dell'utente cnt e digita semplicemente cnt.

premi ora Inv per terminare l'installazione"
echo "$z"
read x
exit
}

ini1