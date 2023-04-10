#!/bin/bash

echo -n "Enter date (example: 2023március): "
read dateToAppend

declare -a invoices=()
declare -a tickets=()
declare params=""

# iterate over pdf files in the folder and collect invoices and tickets
readarray -d '' entries < <(printf '%s\0' *.pdf | sort -zV)
for entry in "${entries[@]}"; do
  if [[ $entry == SZAMLA* ]] ;
    then
      invoices+=($entry)
  fi
  if [[ $entry == JEGY* ]] ;
    then
      tickets+=($entry)
  fi
done

invoicesLength=${#invoices[@]}
ticketsLength=${#tickets[@]}

# collect tickets for each invoices
for (( i=0; i<${invoicesLength}; i++ ));
  do 
    params+="${invoices[$i]} "
    for (( j=i*2; j<=i*2+1; j++ ));
      do 
        params+="${tickets[$j]} "
    done
done

# echo ${params}
pdftk ${params} output torma_szabolcs_vonatjegy_${dateToAppend}.pdf
