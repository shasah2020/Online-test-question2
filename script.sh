#!/bin/bash

source ./variables.txt

#curl to get metadata
get_data () {
    curl ${URL} | python -m json-tool > ${resp}
}

#help_block
help () {
    level=$1
    echo "Choose from valid options: "
    cat ${resp} |jq -r ".${level}" | jq 'keys[]' | sed 's/"//g' | tee ${record}
}

fetch_data() {
    read -p "Display the full metadata? Y/N" var1
    if [[ $var1 == "Y" || $var1 == "y" ]] ; then
      cat ${resp}
    else
      help
      read -p "Enter your choice:" var2
      isInFile=$( cat $record | grep -c $var2)
      if [ isInFile -eq 0 ] ; then
        echo "Enter valid option"
      else
        cat ${resp} | jq -r ".$var2"
        read -p "Want to extract single metadata? Y/N" var3
        if [[ $var1 == "Y" || $var1 == "y" ]] ; then
          echo "Available options"
          for typ in $(cat $rec) ; do
            help $typ
          done
          read -p "Enter the key1 now: " key1
          read -p "Enter the key2 now: " key2
          cat ${resp} |jq -r ".${key1}.${key2}"
        fi
      fi
    fi
}