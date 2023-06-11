# Function to remove exited/dead containers
function cleanup_containers() {
    # Check if Docker is installed
    if ! command -v docker &> /dev/null
    then
        echo "Docker is not installed. Aborting."
        exit 1
    fi

    # Check if Docker swarm is active
    if docker node ls &> /dev/null
    then
        # Remove exited/dead containers in Swarm mode
        if docker ps -aq --filter status=dead --filter status=exited | xargs -r docker rm -v
        then
            echo "Removed exited/dead containers."
        else
            echo "No exited/dead containers to remove."
        fi
    else
        # Remove exited/dead containers in non-Swarm mode
        if docker ps -aq --filter status=dead --filter status=exited | xargs -r docker rm -v
        then
            echo "Removed exited/dead containers."
        else
            echo "No exited/dead containers to remove."
        fi
    fi
}
