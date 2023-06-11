function source_functions {
    local script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
    local default_function_dir="/home/${SUDO_USER}/Loco_V2/functions"
    local root_function_dir="/root/Loco_V2/functions"
    local function_dir="${default_function_dir}"
    
    if [[ $EUID -eq 0 ]] && [[ "${SUDO_USER}" != "" ]]; then
        function_dir="${default_function_dir}"
    elif [[ $EUID -eq 0 ]]; then
        function_dir="${root_function_dir}"
    fi

    if [ $# -gt 0 ]; then
        # Check if the first argument is a directory
        if [ -d "$1" ]; then
            function_dir="$1"
            shift
        fi
    fi

    if [ -z "$function_dir" ]; then
        echo "No function directory specified"
        return 1
    fi
    
    while [ ! -d "${function_dir}" ]; do
        echo "Could not find function directory at '${function_dir}'"
        read -p "Please enter the location of the 'functions' directory: " function_dir
    done

    # Source all .sh files in the directory
    for file in "${function_dir}"/*.sh; do
        if [ -f "$file" ]; then
            source "$file"
        fi
    done
}

function source_additional_scripts {
    local base_dir=""
    if [[ $EUID -eq 0 ]] && [[ "${SUDO_USER}" != "" ]]; then
        base_dir="/home/${SUDO_USER}/Loco_V2/"
    elif [[ $EUID -eq 0 ]]; then
        base_dir="/root/Loco_V2/"
    fi
    
    if [ $# -eq 0 ]; then
        echo "No additional folders specified"
        return
    fi

    for folder in "$@"; do
        local folder_path="${base_dir}${folder}"
        if [ -d "${folder_path}" ]; then
            source_functions "${folder_path}"
        else
            echo "Folder '${folder}' not found"
        fi
    done
}

function source_category_scripts {
    local base_dir=""
    if [[ $EUID -eq 0 ]] && [[ "${SUDO_USER}" != "" ]]; then
        base_dir="/home/${SUDO_USER}/Loco_V2/"
    elif [[ $EUID -eq 0 ]]; then
        base_dir="/root/Loco_V2/"
    fi
    
    if [ $# -eq 0 ]; then
        echo "No categories specified"
        return
    fi

    for category in "$@"; do
        local category_path="${base_dir}categories/${category}"
        if [ -d "${category_path}" ]; then
            for script in "${category_path}"/*.sh; do
                if [ -f "$script" ]; then
                    source "$script"
                fi
            done
        else
            echo "Category '${category}' not found"
        fi
    done
}

