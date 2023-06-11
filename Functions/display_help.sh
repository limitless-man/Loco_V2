display_help() {
    echo "Loco_V2.sh - Available Commands:"
    echo

    # Iterate over the functions in the Functions folder
    for file in functions/*.sh; do
        # Extract the function names from the files
        function_names=$(grep -o '^[^ ()]\+' "$file")

        # Print the function names as commands with descriptions
        while read -r function_name; do
            # Extract the description from the function
            description=$(grep -A1 "^function $function_name" "$file" | tail -n1 | cut -d'#' -f2-)

            # Print the command and its description
            echo "$function_name: $description"
        done <<< "$function_names"

        echo
    done

    # You can also provide a general description of the script and how to use it
    echo
    echo "Usage: Loco_V2.sh [command]"
    echo
    echo "Run './Loco_V2.sh -h' to display the list of available commands."
    echo
}
