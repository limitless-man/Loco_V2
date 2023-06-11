# This function simplifies the process of running apt-get commands with elevated
# privileges using sudo. It takes two arguments: the first argument `cmd` is the
# apt-get command to run, such as `install`, `remove`, `update`, or `upgrade`.
# The second argument `shift` is used to shift the positional parameters to the left,
# effectively removing the first argument (`cmd`) from the argument list.
# The function then calls `sudo apt-get` with the `cmd` argument and any remaining
# arguments (`"$@"`), with the `-y` option to automatically answer "yes" to any prompts
# and avoid requiring user input during installation or removal.
# This function can be used to simplify the syntax of running `apt-get` commands with sudo,
# allowing the user to just call `run_apt install <package>` or `run_apt remove <package>`
# instead of typing out the entire `sudo apt-get install -y <package>` or
# `sudo apt-get remove -y <package>` command.

function apt_helper() {
    local cmd="$1"
    shift
    sudo apt-get "$cmd" -y "$@"
}