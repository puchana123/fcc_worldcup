#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
  echo -e "\n~~TESTSERVER~~\n"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# CLEAR DATABASE
# echo $($PSQL "TRUNCATE teams, games")

echo -e "\n~~Insert Data~~\n|"

# CHOOSE FILE
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINGOAL OPPGOAL
do
  # ADD TEAM STATEMENT
  # CHECK TITLE != winner AND opponent
  if [[ $WINNER != 'winner' && $OPPONENT != 'opponent' ]]
  then
    # Get team_id
    WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    # IF not have in DB 
    # WINNER
    if [[ -z $WIN_ID ]]
    then
      # INSERT INTO teams
      INSERT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_RESULT == "INSERT 0 1" ]]
      then  echo "INSERTED Team: $WINNER"
      fi
      # GET NEW WIN ID
      WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi
    # OPPONENT
    if [[ -z $OPP_ID ]]
    then
      # INSERT INTO teams
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
      then  echo "INSERTED Team: $OPPONENT"
      fi
      # GET NEW OPP ID
       OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi
    # IF have Skip
    # INSERT INTO GAMES TABLE
    INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR,'$ROUND',$WIN_ID,$OPP_ID,$WINGOAL,$OPPGOAL)")
  fi  
done

COUNT1=$($PSQL "SELECT COUNT(*) FROM teams")
COUNT2=$($PSQL "SELECT COUNT(*) FROM games")
echo "TEAMS Count = $COUNT1"
echo "GAMES Count = $COUNT2"