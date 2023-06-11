# Call a function if it exists
# Usage: call_function function_name [args...]
function call_function {
    # Get the function name and args from the command line
    local func_name=$1
    shift
    local args=("$@")

    # Check if the function exists
    if ! declare -f "$func_name" > /dev/null; then
        echo "Function '$func_name' not found"
        return 1
    fi

    # Call the function with the provided args
    $func_name "${args[@]}"
}

# check if a function is specified as a command-line argument
if [ $# -eq 0 ]; then
    echo "No function specified. Usage: ./script.sh <function_name>"
    exit 1
fi

# Call the specified function with any arguments
#call_function "$@"