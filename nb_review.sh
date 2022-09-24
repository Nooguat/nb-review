#!/bin/bash
SRC="/home/gsd/.nb/home"
HISTORY_FILE="/home/gsd/Code/Bash/nb_history"
# TODO Setup BASH_SOURCE[0] + dirname
SCRIPT_FILE="/home/gsd/Code/Bash/review-nb/nb_review.sh"
shopt -s extglob
FILE=$(ls $SRC/!(*bookmark*).md | shuf -n 1)
while grep -q "$FILE" "$HISTORY_FILE"; do
  FILE=$(ls $SRC/!(*bookmark*).md | shuf -n 1)
done
# echo "Loading file $FILE...."
# TODO Find the most optimised way between that and cat -> wc pipeline
FILENAME=$(basename ${FILE})
WORDS=$(wc -w "$FILE" | cut -d ' ' -f1)
PARTS=0
HEADERS=$(cat "$FILE" | grep  -Pec '## ')
echo "number of words : $WORDS  / number of titles : $HEADERS"
IN=$(  sed  "s/[_>*\\]//" < "$FILE")
while [[ $WORDS -gt 200 ]]; do
  echo "Part $PARTS spliting to $WORDS words"
  WORDS=$((WORDS / 2))
  PARTS=$((PARTS + 1))
done
if [[ $PARTS -gt 2 ]];then

  echo "Note $FILENAME should be review for atomistic issue..."
  read -r
fi
echo "parts : $PARTS // words : $WORDS"
if [[ $PARTS -eq 0 ]]; then
  TEXT=$IN
else
INDEX=$((  (RANDOM%PARTS)  ))
PART1=$(( WORDS * INDEX ))
PART2=$(( WORDS * (INDEX + 1) ))
echo "Part $INDEX is used with index from $PART1 to $PART2"
TEXT=$(echo "$IN" | choose -f ' ' $PART1:$PART2)
fi
tt -raw -theme nord-light -bold -oneshot -noreport <<< "$TEXT"
tail -n +2 "$HISTORY_FILE" > $HISTORY_FILE
# Avoid to use temp file
echo "$FILE" >> $HISTORY_FILE
shopt -u extglob
read -rp "Continue? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1
bash -c "$SCRIPT_FILE"
