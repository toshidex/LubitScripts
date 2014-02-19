#!/bin/bash

#Tematica: Elaborazione Dati
#Informazioni sintetiche: Il programma gestisce un database con immissione, modifica ed eleminazioni di campi e record. Inoltre cerca i dati per record e crea codice QR V-Card, sempre per singolo record.
#Nome programma: gestione.sh
#Versione Programma: 2.1
#Autore: Iannoccaro Luigi, Toshidex, Massimo Testa.

QRENCODE="qrencode"


############################################# CREA E CONTROLLA DIRECTORY .GESTIONE #######################
function GESTIONE(){
FICHERO="$HOME/Script/.GESTIONE"
test -d $FICHERO || mkdir -p $FICHERO
}
###########################################################################################################

function CHECKPROG() {

which $QRENCODE
if [ `echo ${PIPESTATUS[*]} | cut -d " " -f 1` -ne 0 ]; then

	zenity --warning --text "Il programma qreconde non e\' installato sul vostro computer. Eseguite questo comando per installarlo: \n \n \n sudo apt-get install qrencode"
	exit 1
	
fi

}


##################################### RICERCA ############################################################
function RICERCA(){
COGNOME=$(zenity --entry \
                  --width=220 \
                  --height=100 \
                  --title="Ricerca" \
                  --text="Digita il cognome dell'utente cercato")

if [ -z $COGNOME ]; then
    COGNOME=mancante
else
    COGNOME=$(echo $COGNOME | tr ' ' '_')
fi


NOME=$(zenity --entry \
                  --width=220 \
                  --height=100 \
                  --title="Ricerca" \
                  --text="Digita il nome dell'utente cercato")

if [ -z $NOME ]; then 
   NOME=mancante
else
   NOME=$(echo $NOME | tr ' ' '_')
fi

#Con Zenity creiamo due variabili al cui interno troviamo il cognome e nome digitato. 
#Ora facciamo fare una scansione a grep sul file lista per constatare se il cognome e nome digitati effettivamente esistano.
#Il risultato della scansione di grep viene assegnato alla variabile RISULTATO.

RISULTATO=$(cat $FICHERO/lista.txt | grep -i "$COGNOME" | grep -i "$NOME")

#Grep non preleva solo il cognome o il nome digitati, che, tra l'altro, potrebbero trovarsi su righe diverse. Perciò chiediamo a 
#awk di stampare solo il primo campo, dove si trovano i cognomi, e il secondo campo, dove si trovano i nomi.

COGNOME1=$(echo "$RISULTATO" | awk -F":" '{print $1}')
NOME1=$(echo "$RISULTATO" | awk -F":" '{print $2}')

}
#########################################################################################################



############################################# IMMISSIONE DI TESTO ########################################

function IMMISSIONE(){


	forms=$(zenity --forms \
		--add-entry=Cognome \
		--add-entry=Nome \
		--add-entry=Protocollo \
		--add-entry=Telefono \
		--add-entry=Cellulare \
		--add-entry=Email 
		)

	cognome=$(echo $forms | awk -F'|' '{print $1}')
	nome=$(echo $forms | awk -F'|' '{print $2}')
	
	if cat $FICHERO/lista.txt | grep -i "$cognome" | grep -i "$nome"; then
                   echo "FOUND" 
                   zenity --info \
                   --width=300 \
                   --height=130 \
                   --title="Informazione" \
                   --text="<b>Questo utente esiste già!</b>"
                   #Reset variabili
                   unset cognome nome forms
	           IMMISSIONE
 	fi                  
	
	echo $forms | awk -F'|' 'BEGIN{OFS=":"}{print $1,$2,$3,$4,$5,$6}' >> $FICHERO/lista.txt


#Sed, prima cancella eventuali righe vuote o che iniziano con "mancante", e poi le righe con soli ":"

     sed -i '/^$/d' $FICHERO/lista.txt
     sed -i '/^mancante/d' $FICHERO/lista.txt
     sed -i '/^:/d' $FICHERO/lista.txt

	
}











##Inseriamo i dati degli utenti nel database, lista.txt, attraverso  ">>"
#function IMMISSIONE(){


#cognome=$(zenity --entry \
#                  --width=300 \
#                  --height=100 \
#                  --title="Cognome" \
#                  --text="Inserisci il cognome. Esempio. Rossi")

##Se salta il cognome o qualsiasi altro dato, il programma aggiunge la stringa "mancante"

#if [ -z $cognome ]; then
#    cognome=mancante
#else
#    cognome=$(echo $cognome | tr ' ' '_')
#fi


#nome=$(zenity --entry \
#                  --width=300 \
#                  --height=100 \
#                  --title="Nome" \
#                  --text="Inserisci il nome. Esempio. Mario")

#if [ -z $nome ]; then 
#   nome=mancante
#else
#   nome=$(echo $nome | tr ' ' '_')
#fi




#protocollo=$(zenity --entry \
#                  --width=300 \
#                  --height=100 \
#                  --title="Protocollo" \
#                  --text="Inserisci il numero di protocollo. Esempio. 56890")

#if [ -z $protocollo ]; then 
#   protocollo=mancante 
#else
#   protocollo=$(echo $protocollo | tr ' ' '_')
#fi


#telefono=$(zenity --entry \
#                  --width=300 \
#                  --height=100 \
#                  --title="Telefono" \
#                  --text="Inserisci il numero di telefono. Esempio 098094949X")

#if [ -z $telefono ]; then 
#    telefono=mancante
#else
#    telefono=$(echo $telefono | tr ' ' '_')
#fi

#cellulare=$(zenity --entry \
#                  --width=300 \
#                  --height=100 \
#                  --title="Cellulare" \
#                  --text="Inserisci il numero di cellulare. Esempio. 444546543")

#if [ -z $cellulare ]; then 
#   cellulare=mancante
#else
#   cellulare=$(echo $cellulare | tr ' ' '_')
#fi

#email=$(zenity --entry \
#                  --width=300 \
#                  --height=100 \
#                  --title="E-mail" \
#                  --text="Inserisci l'indirizzo e-mail. Esempio. mariorossi@cot.it")

#if [ -z $email ]; then 
#   email=mancante
#else
#   email=$(echo $email | tr ' ' '_') 
#fi

#controlla se l'utente con quel nome e cognome è presente già nella list

#if cat $FICHERO/lista.txt | grep -i "$cognome" | grep -i "$nome"; then
#                   echo "FOUND" 
#                   zenity --info \
#                   --width=300 \
#                   --height=130 \
#                   --title="Informazione" \
#                   --text="<b>Questo utente esiste già!</b>"
#                   #Reset variabili
#                   unset cognome nome protocollo telefono cellulare email
#                   
#else 
#    echo "NOT FOUND"
#fi
#
#nome_array=( "$cognome" "$nome" "$protocollo" "$telefono" "$cellulare" "$email" )
#
#
#
#echo ${nome_array[@]} | awk 'BEGIN{OFS=":"}{print $1,$2,$3,$4,$5,$6}' >> $FICHERO/lista.txt
#
#
##Sed, prima cancella eventuali righe vuote o che iniziano con "mancante", e poi le righe con soli ":"
#
#     sed -i '/^$/d' $FICHERO/lista.txt
#     sed -i '/^mancante/d' $FICHERO/lista.txt
#     sed -i '/^:/d' $FICHERO/lista.txt
#
#
#}
###################################### FINE SEZIONE IMMISSIONE ###########################################



########################################### CERCA DATI ###################################################

function TROVA() {
#RICERCA


DATO=$(zenity --entry \
                  --width=220 \
                  --height=100 \
                  --title="Ricerca" \
                  --text="Digita un dato dell'utente")

cat $FICHERO/lista.txt | grep -i "$DATO" | awk 'BEGIN {
            FS=":"
            OFS="\n"
            ORS=" "
}
{ 
  i=1;
  while (i<=NF) {
      i+=$i;
      i++
 }
  print "\n""Cognome: " $1,"Nome: "$2,"Protocollo: " $3,"Telefono: "$4,"Cellulare: " $5,"E-mail: "$6, "\n"
}'> $FICHERO/ricerca

zenity --text-info \
       --width=300 \
       --height=400 \
       --filename="$FICHERO/ricerca"
}
######################################## FINE SEZIONE CERCA ##################################################



######################################### REPORT #########################################################
#Questa funzione, List appunto, crea un file, elenco.txt. In questo file si trovano tutti i record del database. 

function LIST(){


cat $FICHERO/lista.txt | sort | uniq > $FICHERO/lista1.txt

NOW=$(date +"%d-%m-%Y. "Ore:"  %R")

echo ""

echo "Report del " $NOW > $FICHERO/report.txt

numero_record=$(wc -l $FICHERO/lista1.txt | awk '{print $1}')

echo "numero degli utenti registrati: $numero_record" >> $FICHERO/report.txt

echo ""

echo "Il file report.txt lo trovi nella seguente cartella: $FICHERO" >> $FICHERO/report.txt

for linea in $(cat $FICHERO/lista1.txt)  
      
   do

       echo "$linea" | awk -F":" 'BEGIN{
            FS=":"
            OFS="\n"
            ORS=" "

    }

  END{ 
        print "\n""Cognome: " $1,"Nome: "$2,"Protocollo: " $3,"Telefono: "$4,"Cellulare: " $5,"E-mail: "$6, "\n"
   
    }' >> $FICHERO/report.txt

  done

zenity --text-info \
       --width=300 \
       --height=400 \
       --filename="$FICHERO/report.txt"

}
############################################# FINE REPORT #################################################################



############################################ MODIFICA CAMPO #####################################################################
#Modifichiamo un campo di un record. Prima troviamo la stringa da modificare, poi chiediamo quale campo della stringa deve essere
#modificato. Ancora con quale nuova stringa deve essere sostituito. Infine facciamo la sostituzione con sed. 

function MODIFICA() {
RICERCA



#A questo punto facciamo confrontare contemporaneamente il cognome trovato da grep, nel file lista.txt, con il cognome digitato da noi 
#mediante zenity. La stessa cosa facciamo fare per il nome. Se cognome e nomi corrispondo, allora si stampa il risultato, diversamente,
#una finestra di dialogo ci avviserà che l'utente con cognome e nome da noi digitati non esiste nella lista.txt. 

if [[ -z "$COGNOME1" && -z "$NOME1" ]]; then
            
       zenity --info \
                   --width=300 \
                   --height=130 \
                   --title="Controllo" \
                   --text="<b>Uno o entrambi i dati cercati non esistono!</b>"
else

     MOD=$(zenity --title="Modifica Dati" \
                  --width=270 \
                  --height=250 \
                  --list --radiolist \
                  --text "Quale dato dell'utente scelto vuoi modificare?" \
                  --column 'Seleziona' \
                  --column 'Preferenza' FALSE "Protocollo" FALSE "Telefono" FALSE "Cellulare" FALSE "E-mail")

#In base alla riposta contenuta nella variabile $MOD ci si colloca nella giusta sezione e si chiede di digitare il vecchio dato e il nuovo. Questa operazione viene ripetuta per tutte le scelte possibili. 

             case $MOD in
 
  
                    "Protocollo")

                           PROTOCOLLO1=$(zenity --entry \
                                                --width=220 \
                                                --height=100 \
                                                --title="Modificare protocollo" \
                                                --text="digita il nuovo numero di protocollo.")

#Echo espande il contenuto della variabile $RESULT, l'intera riga prescelta e, all'interno di questa, viene sostituito il vecchio dato
#con il nuovo attraverso sed. Questa procedura viene ripetuta per tutte le voci di questa sezione.

                           vecchio_dato1=$(echo $RISULTATO | awk -F":" '{print $3}') 
                           sed -i s/$vecchio_dato1/$PROTOCOLLO1/g $FICHERO/lista.txt 
                   ;;
                    "Telefono")

                       TELEFONO1=$(zenity --entry \
                                          --width=220 \
                                          --height=100 \
                                          --title="Modificare telefono" \
                                          --text="digita il nuovo num. di telefono.")

                       vecchio_dato2=$(echo $RISULTATO | awk -F":" '{print $4}') 
                       sed -i s/$vecchio_dato2/$TELEFONO1/g $FICHERO/lista.txt 
                 ;;
                 "Cellulare")

                   CELLULARE1=$(zenity --entry \
                                       --width=220 \
                                       --height=100 \
                                       --title="Modificare num. cellulare" \
                                       --text="digita il nuovo numero di cellulare.")

                    vecchio_dato3=$(echo $RISULTATO | awk -F":" '{print $5}') 
                    sed -i s/$vecchio_dato3/$CELLULARE1/g $FICHERO/lista.txt 
               ;;
               "E-mail")

                  EMAIL1=$(zenity --entry \
                                  --width=220 \
                                  --height=100 \
                                  --title="Modificare e-mail" \
                                  --text="digita il nuovo indirizzo e-mail.")

                 vecchio_dato4=$(echo $RISULTATO | awk -F":" '{print $6}') 
                 sed -i s/$vecchio_dato4/$EMAIL1/g $FICHERO/lista.txt
              ;;
 
              *)
             printf "Non è hai effettuato alcuna scelta.\n" ;;
        esac
fi
}
##########################################FINE SEZIONE MODIFICA DATI###################################################



########################################## CANCELLA UN RECORD #################################################################
#Cancellare un record con sed

function CANCELLA(){
RICERCA


# IF Controlla se le parola cercate esistono. Devono esistere entrambi, altrimenti esce una finestra di messaggio. 

if [[ -z "$COGNOME1" && -z "$NOME1" ]]; then
            zenity --info \
                   --width=300 \
                   --height=130 \
                   --title="Avviso" \
                   --text="<b>Uno o entrambi i dati cercati non esistono!</b>"
            OPZIONE
fi
#SED cancella l'intera riga che inizia con un determinato nome e cognome. 

sed -i /$RISULTATO/d $FICHERO/lista.txt

            zenity --info \
                   --width=300 \
                   --height=130 \
                   --title="Informazione" \
                   --text="<b>L'operazione è andata a buon fine!</b>"


}
###############################################FINE SEZIONE CANCELLA UN RECORD #########################################################



###################################### CREARE QRV-CARD ###################################################################

#Troviamo un record e creamo un codice QR con qrencode

function CODICEQR(){
RICERCA

FICHERO1=$HOME/Script/ImmaginiQR
test -d $FICHERO1 || mkdir -p $FICHERO1

#Controlla se le parole cercate esistano. Basta che una delle due parole non è stata trovata, che esce una finestra di messaggio. 

if [[ -z "$COGNOME1" && -z "$NOME1" ]]; then
            zenity --info \
                   --width=300 \
                   --height=130 \
                   --title="ATTENZIONE" \
                   --text="<b>Uno o entrambi i dati cercati non esistono!</b>"
            OPZIONE
 else   


#Formatta la finestra di risposta.

RISULTATO1=$(echo "$RISULTATO" | awk -F":" 'BEGIN{
                                                ORS="\n";
                                                OFS="";
  }

END{

    print "Cognome:", $1,"\n","Nome:",$2,"\n", "Protocollo:",$3,"\n","Telefono:",$4,"\n","Cellulare:",$5,"\n","E-mail:",$6,"\n"

 }')

    echo "$RISULTATO1" > $FICHERO/lista3.txt

#Viene richiamato il tool qrencode, che crea il codice QRVcard e lo ripone nella cartella apposita.

    qrencode -o $FICHERO1/QRVcard.png < $FICHERO/lista3.txt
    rm $FICHERO/lista3.txt
    zenity --info \
         --width=300 \
         --height=130 \
         --title="Codice QRVcard creato" \
         --text="<b>Il file QRVcard.png lo trovi nella seguente cartella: $FICHERO1</b>"

fi

}
##################################### FINE SEZIONE CREA QRV-CARD ###############################################################



######################################### SEZIONE PRIMARIA ######################################################################
function OPZIONE(){

       opzione=$(zenity --title="Gestione Dati" \
              --width=350 \
              --height=300 \
              --list --radiolist \
              --text 'Gestione Dati' \
              --column 'Seleziona' \
              --column 'Menu' --column "Opzioni"  FALSE "1" "Immissione Dati" FALSE "2" "Cerca Dati" FALSE "3" "Elenco Dati" \
                FALSE "4" "Modifica Dati" FALSE "5" "Cancella Dati" FALSE "6" "Crea QRVcard" FALSE "7" "Esci dal Programma") 
 
            case $opzione in 

                 1)IMMISSIONE 
  
                 ;;       
         
                 2)TROVA

                 ;;

                 3)LIST

                 ;;

                 4)MODIFICA

                 ;;
      
                 5)CANCELLA

                 ;;

                 6)CODICEQR

                 ;;

                 7)echo "Esci" 
 
                 ;;

                 *)
			if [[ $? -eq 0 ]]; then
				zenity --warning --text "Non è hai effettuato alcuna scelta.\n"
				OPZIONE
			else
				exit 1
			fi
          esac

}


#Il programma parte da qui. Dalla funzione OPZIONE.

CHECKPROG  #Controlla se il programma qrencode è installato
GESTIONE
OPZIONE

