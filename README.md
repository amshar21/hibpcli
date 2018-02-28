# hibpcli
Search password in bulk from haveibeenpwned.com API

Simple implementation of the new haveibeenpwned.com (using range)
API which send only the first 5 characters of the password's SHA1 sum to the server.
The response will return 500 hashes that starts with the 5 characters & how many times it is found on the DB

- Fix all caveats & bugs
- Added support for parallelism through background tasks
- First commit

``
Caveats
``
- All bugs/caveats are fixed


Sample output :

```
root@pwnbx:~/hibpcli# ./hibpcli.sh password.lst 4
 
- HaveIBeenPwned-cli
- github.com/Codeshift3r
 
- Total passwords: 11
- Total tasks: 4
- Remainder password count: 3
- Password per task: 2
- Splitting files...
 
- 'password' was found 3303003 times
- 'winter' was found 76330 times
- 'the' was found 37103 times
- 'test' was found 68340 times
- 'is' was found 1334 times
- 'nobody-woulD-hav3-THIS-p4ssw00000rDDD' was not found
- 'down' was found 2045 times
- 'sun' was found 11236 times
- 'all' was found 7919 times
- 'setting' was found 1798 times
- 'on us' was not found
 
- Task completed
 
root@pwnbx:~/hibpcli# 

```
