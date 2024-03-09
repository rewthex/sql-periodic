#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  case $1 in
    [1-9]*) TARGET_ELEMENT=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = '$1'") ;;
    [a-zA-Z]|[a-zA-Z][a-zA-Z]) TARGET_ELEMENT=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1'") ;;
    *) TARGET_ELEMENT=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$1'") ;;
  esac

  if [[ -z $TARGET_ELEMENT ]]
  then
    echo "I could not find that element in the database."
  else
    ELEMENT_PROPERTIES=$($PSQL "SELECT properties.atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, \
    boiling_point_celsius FROM properties JOIN elements ON properties.atomic_number = elements.atomic_number JOIN types ON \
    properties.type_id = types.type_id WHERE properties.atomic_number = '$TARGET_ELEMENT'")
    
    IFS='|' read -r NUMBER NAME SYMBOL TYPE MASS MELTING BOILING <<< "$ELEMENT_PROPERTIES"

    echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu." \
    "$NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
  fi
fi

