function loadingAnimation() {
    local message="$1"
    local cmd="$2"
    local duration=0
    local c=0
    local s=""

    # Run the command in the background
    $cmd > /dev/null 2>&1 &
    local cmd_pid=$!

    while kill -0 $cmd_pid 2>/dev/null; do
        if [ "$c" -eq 0 ]
        then
            s="[    ]"
        elif [ "$c" -eq 1 ]
        then
            s="[/   ]"
        elif [ "$c" -eq 2 ]
        then
            s="[-   ]"
        elif [ "$c" -eq 3 ]
        then
            s="[\\   ]"
        elif [ "$c" -eq 4 ]
        then
            s="[|   ]"
        elif [ "$c" -eq 5 ]
        then
            s="[|/  ]"
        elif [ "$c" -eq 6 ]
        then
            s="[|-  ]"
        elif [ "$c" -eq 7 ]
        then
            s="[|\\  ]"
        fi

        printf "\r%s %s" "$message" "$s"
        sleep 0.1

        ((c++))
        if [ "$c" -gt 7 ]
        then
            c=0
        fi

        ((duration++))
    done

    # Wait for the command to finish and get the exit status
    wait $cmd_pid
    local exit_status=$?

    # Print the final message based on the exit status
    if [ $exit_status -eq 0 ]
    then
        printf "\r%s [Done]\n" "$message"
    else
        printf "\r%s [Failed]\n" "$message"
    fi

    return $exit_status
}