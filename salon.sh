#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -t --tuples-only -c"

echo -e "\n~~~~ Salon Shop ~~~~\n"

MAIN_MENU() {

  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo -e "Welcome to my salon, how can I help you?\n"
  SERVICES=$($PSQL "select * from services")
  echo "$SERVICES" | while read service_id bar service
  do
    echo "$service_id) $service"
  done

  read SERVICE_ID_SELECTED
  echo $SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
  1) SERVICES cut;;
  2) SERVICES color;;
  3) SERVICES perm;;
  4) SERVICES style;;
  5) SERVICES trim;;
  *) MAIN_MENU "Please enter valid service number :)";;
  esac
}

EXIT() {
  echo -e "Thanks for stopping in...."
}

SERVICES() {
  #set service id
  SERVICE_ID=$($PSQL "select service_id from services where name='$1'")
  #get phone number
  echo "What's your number?"
  read CUSTOMER_PHONE

  #get customer id
  CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")

  #if not in db get name
  if [[ -z $CUSTOMER_ID ]]
  then
    #get customer name
    echo "What is you name?"
    read CUSTOMER_NAME

    #insert into customers
    INSERTED_INTO_CUSTOMERS=$($PSQL "insert into customers(phone, name) values('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
    echo $INSERTED_INTO_CUSTOMERS
  fi

  #get customer id
  CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")

  #get time for appointment
  echo "At what time would you like to $CuSTOMER_ID, $CUSTOMER_NAME?"
  read SERVICE_TIME

   #insert into appointment with time
   INSERTED_INTO_APPMT=$($PSQL "insert into appointments(customer_id, service_id, time) values($CUSTOMER_ID, $SERVICE_ID, '$SERVICE_TIME')")
   if [[ $INSERTED_INTO_APPMT ]]
   then
    echo "I have put you down for a $1 at $SERVICE_TIME, $CUSTOMER_NAME." 
   fi

   EXIT
}

MAIN_MENU

