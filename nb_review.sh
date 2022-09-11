#!/bin/bash
SRC="/home/gsd/.nb/home"
HISTORY_FILE="/home/gsd/Code/Bash/nb_history"
SCRIPT_FILE="/home/gsd/Code/Bash/nb_review.sh"
shopt -s extglob
FILE=$(ls $SRC/!(*bookmark*).md | shuf -n 1)
while grep -q $FILE "$HISTORY_FILE"; do
  FILE=$(ls $SRC/!(*bookmark*).md | shuf -n 1)
done
# echo "Loading file $FILE...."
# TODO Find the most optimised way between that and cat -> wc pipeline
FILENAME=$(basename ${FILE})
WORDS=$(wc -w "$FILE" | cut -d ' ' -f1)
PARTS=1
HEADERS=$(cat "$FILE" | grep  -Pe'## ' | wc -l)
#echo "number of words : $WORDS  / number of titles : $HEADERS"
IN=$(cat "$FILE" | sed  "s/[_>*\\]//")
#printf "%s\n" "$IN"
while [[ $WORDS -gt 200 ]]; do
  WORDS=$((WORDS / 2))
  PARTS=$((PARTS + 1))
  echo $WORDS
done
if [[ $PARTS -gt 2 ]];then

  echo "Note $FILENAME should be review for atomistic issue..."
  read
fi
echo "parts : $PARTS // words : $WORDS"
if [[ $PARTS -eq 1 ]]; then
  TEXT=$IN
else
INDEX=$((  ($RANDOM%$PARTS) + 1  ))
PART1=$(( $WORDS * $INDEX ))
PART2=$(( $WORDS * ($INDEX + 1) ))
echo "part 1 : $PART1 // part 2 : $PART2"

TEXT=$(echo "$IN" | cut -d ' ' -f $PART1-$PART2)
fi
tt <<< $TEXT
#echo $IN
#arrIN=(${IN//##/})
#echo ${arrIN[@]}
#tt <<< ${arrIN[@]}
echo "$(tail -n +2 $HISTORY_FILE)" > $HISTORY_FILE
# Avoid to use temp file
echo "$FILE" >> $HISTORY_FILE
shopt -u extglob
read -p "Continue? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1
bash -c $SCRIPT_FILE
