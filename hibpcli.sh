# Simple impplementation of new haveibeenpwned.com API for querying passwords
# v1.1

function banner {
echo " "
echo "- HaveIBeenPwned-cli"
echo "- github.com/amshar21"
echo " "
}

function usage {
    echo "Usage: $0 [password-file] [tasks]"
    echo "password-file : File containing passwords to query (required)"
    echo "tasks : tasks count (need to put atleast 1)(required)"
    echo " "
}

banner

if [[ -z $1 ]]; then
    usage
    exit
fi

if [[ -z $2 ]]; then
    usage
    exit
fi

if [[ -z $(which sha1sum) ]]; then
    echo "- sha1sum not found on your PATH. You can : apt-get install sh1sum"
    exit
fi

# convert windows/dos style newline \r\n to uni-style newline \n
dos2unix "$1"

#Main function to fetch hashes

function coregethash(){
while IFS='' read -r mpasswd || [[ -n "$mpasswd" ]]; do
    mhash=$(echo -n $mpasswd|sha1sum|cut -d" " -f1)
    prefxhash=${mhash:0:5}
    postfxhash=${mhash:5:35}
    response_line=$(curl --user-agent HIBP-CLI -s https://api.pwnedpasswords.com/range/$prefxhash | grep -i $postfxhash|cut -d: -f2)
    if [[ -z $response_line ]]; then
        echo -e "- '$mpasswd' was not found"
    else
        response_line=${response_line::-1}
        echo -e "- '$mpasswd' was found $response_line times"
    fi
done < "$1"
rm -f $1

#echo DEBUG: - Current file is "$1"
#echo DEBUG: - Last file is "${filesArray[-1]}"

#
#if [ "$1" == "${filesArray[-1]}" ]; then
#   echo - Task completed
#fi


}


# Setup parallelizm

threads=$2
#count wordlist lines
lines_count=$(grep . $1|wc -l)
echo - Total passwords: $lines_count
echo - Total tasks: $2
perthread=$(($lines_count/$threads))

if (( $threads > $lines_count )); then
   echo "- Tasks cannot exceed passwords count"
   exit
fi

if (( $threads < 1 )); then
   echo "- Tasks cannot be < 1"
   exit
fi

subzr=$(($perthread*$threads))
if [ "$subzr" -ne "$lines_count" ]; then
   expnt=$(($lines_count-$subzr))
   echo - Remainder password count: $expnt
fi

echo - Password per task: $perthread
#splitting files
echo - Splitting files...
echo " "
split -a 4 -l $perthread $1
splitfiles=$(ls|grep xa|tr '\n' ' ')
filesArray=($splitfiles)
#filesArraycount=${#filesArray[@]}

for fni in "${filesArray[@]}"
do

coregethash "$fni" &
# echo DEBUG: Task f0r $fni created .............................
sleep 0.5 > /dev/null

done

wait
echo " "
echo - Task completed
echo " "
