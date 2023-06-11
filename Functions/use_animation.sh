# Runs a command with a loading animation and error checking.
# $1: The message to display before executing the command.
# $2: The command to execute.
# $3: The error message to display if the command fails.
function runWithLoading() {
    local message="$1"
    local command="$2"
    local error_message="$3"
    local delay=0.75

    # Display the loading animation before executing the command.
    loadingAnimation "$message"

    # Execute the command in the background and redirect its output to /dev/null
    eval "$command" > /dev/null 2>&1 &

    # Display a spinner animation while the command is running.
    spinner() {
        local pid=$!
        local spinstr='|/-\'
        while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
            local temp=${spinstr#?}
            printf " [%c]  " "$spinstr"
            local spinstr=$temp${spinstr%"$temp"}
            sleep $delay
            printf "\b\b\b\b\b\b"
        done
        printf "    \b\b\b\b"
    }
    spinner

    # Check the exit status of the command.
    if [ $? -ne 0 ]; then
        # Display the error message and return an error status.
        echo -e "\n$error_message\n"
        return 1
    fi

    # Return a success status.
    return 0
}