# Using Functions from Other Scripts


🅻🅾🅲🅾 🅵🆄🅽🅲🆃🅸🅾🅽🆂


If you want to use a function from another script, you can do so by sourcing that script into your own script. Sourcing a script means that all of the commands in the script will be executed in the current shell environment, rather than creating a new shell environment.

To source a script, use the `source` command or its shorthand equivalent, the `.` (dot) command, followed by the path to the script:

```bash
source /path/to/other/script.sh

or

. /path/to/other/script.sh


Once the script is sourced, you can call any of its functions in your own script just as you would call any other function. For example, if the other script contains a function called my_function, you can call it in your own script like this:

my_function arg1 arg2 arg3


Note that if the function you are trying to call depends on other functions or variables defined in the other script, you will need to source the script that defines those dependencies as well.

If the other script is in a different directory than your own script, you will need to provide the full path to the script, or change the working directory to the directory containing the script before sourcing it.

Finally, make sure that the other script has the appropriate permissions to be executed, either by making it executable (chmod +x /path/to/other/script.sh) or by running it with the appropriate interpreter (bash /path/to/other/script.sh).

