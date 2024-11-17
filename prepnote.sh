#!/bin/bash

# Path to the configuration file - now relative to the script location
CONFIG_FILE="$(dirname "$0")/config.txt"

# Function to read configuration values
read_config() {
    local key=$1
    grep "^$key=" "$CONFIG_FILE" | cut -d'=' -f2 | tr -d '"' | tr -d ' '
}

# Check if config file exists
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Error: Configuration file not found at $CONFIG_FILE"
    exit 1
fi

# Read configuration values
OBSIDIAN_NOTES_PATH=$(read_config "OBSIDIAN_NOTES_PATH")
TEMPLATE_PATH=$(read_config "TEMPLATE_PATH")
EXAM_PATH=$(read_config "EXAM_PATH")
TRAINING_PATH=$(read_config "TRAINING_PATH")
WORKING_DIR=$(read_config "WORKING_DIR")
HTB_PATH=$(read_config "HTB_PATH")
PG_PATH=$(read_config "PG_PATH")
OSCP_PATH=$(read_config "OSCP_PATH")
OSCP_AD_PATH=$(read_config "OSCP_AD_PATH")

# Flags to determine the mode of operation
hackthebox_flag=false
proving_flag=false
oscp_flag=false
ad_flag=false
exam_flag=false
training_flag=false
show_help=false

# Initialize an empty string for the folder name
folder_name=""

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h)
            hackthebox_flag=true
            shift
            ;;
        -p)
            proving_flag=true
            shift
            ;;
        -o)
            oscp_flag=true
            shift
            ;;
        -a)
            ad_flag=true
            shift
            ;;
        -e)
            exam_flag=true
            shift
            ;;
        -t)
            training_flag=true
            shift
            ;;
        --help)
            show_help=true
            shift
            ;;
        *)
            # Assign the first non-flag argument to folder_name
            if [[ -z "$folder_name" ]]; then
                folder_name="$1"
            fi
            shift
            ;;
    esac
done

# Display help message if --help is used
if [[ "$show_help" == true ]]; then


    echo ""
echo ""

echo '      ____                                   _          ____                              __          _____      __            
     / __ \__  ______  ____ _____ ___  ____ ( )_____   / __ \________  ____  ____  ____  / /____     / ___/___  / /___  ______ 
    / / / / / / / __ \/ __ / __ __ \/ __ \|// ___/  / /_/ / ___/ _ \/ __ \/ __ \/ __ \/ __/ _ \    \__ \/ _ \/ __/ / / / __ \
   / /_/ / /_/ / / / / /_/ / / / / / / /_/ / (__  )  / ____/ /  /  __/ /_/ / / / / /_/ / /_/  __/   ___/ /  __/ /_/ /_/ / /_/ /
  /_____/\__, /_/ /_/\__,_/_/ /_/ /_/\____/ /____/  /_/   /_/   \___/ .___/_/ /_/\____/\__/\___/   /____/\___/\__/\__,_/ .___/ 
      /____/                                                     /_/                                                /_/      '

echo ""
echo ""
    echo "Usage: prepnote [OPTIONS] FOLDER_NAME"
    echo "Options:"
    echo "  -h    Copy template to 'HackTheBox' destination."
    echo "  -p    Copy template to 'Proving Grounds' destination."
    echo "  -o    Copy template to 'OSCP - Challenge Labs' destination."
    echo "  -a    Copy template to 'OSCP - AD Challenge Labs' destination (with three machine folders)."
    echo "  -e    Set up an OSCP exam environment with AD and challenge lab machines."
    echo "  -t    Set up an OSCP training environment with AD and challenge lab machines."
    echo "  --help Display this help message."
    exit 0
fi

# Ensure a folder name is provided
if [[ -z "$folder_name" ]]; then
    echo "Error: No folder name provided."
    exit 1
fi

# Format the folder name for display and storage
formatted_folder_name=$(echo "$folder_name" | awk '{print toupper(substr($0,1,1)) tolower(substr($0,2))}')
boxes_folder_name=$(echo "$folder_name" | awk '{print tolower($0)}')

# Initialize variables for destination paths
destination=""
boxes_destination_base=""

# Determine the destination based on the selected flag
if [[ "$exam_flag" == true ]]; then
    destination="$OBSIDIAN_NOTES_PATH/Hacking-Journey/OSCP Exam"
    boxes_destination_base="$EXAM_PATH"
    machine_prefix=("AD_Set" "Challenge1" "Challenge2" "Challenge3")
    ad_subfolders=("Internal1" "Internal2" "Internal3")
elif [[ "$training_flag" == true ]]; then
    destination="$OBSIDIAN_NOTES_PATH/Hacking-Journey/OSCP Training"
    boxes_destination_base="$TRAINING_PATH"
    machine_prefix=("AD_Set" "Challenge1" "Challenge2" "Challenge3")
    ad_subfolders=("Internal1" "Internal2" "Internal3")
elif [[ "$ad_flag" == true ]]; then
    destination="$OBSIDIAN_NOTES_PATH/Hacking-Journey/OSCP - AD Challenge Labs"
    boxes_destination_base="$OSCP_AD_PATH"
    machine_prefix=("Machine1" "Machine2" "Machine3")
elif [[ "$oscp_flag" == true ]]; then
    destination="$OBSIDIAN_NOTES_PATH/Hacking-Journey/OSCP - Challenge Labs"
    boxes_destination_base="$OSCP_PATH"
elif [[ "$proving_flag" == true ]]; then
    destination="$OBSIDIAN_NOTES_PATH/Hacking-Journey/Proving Grounds"
    boxes_destination_base="$PG_PATH"
elif [[ "$hackthebox_flag" == true ]]; then
    destination="$OBSIDIAN_NOTES_PATH/Hacking-Journey/HackTheBox"
    boxes_destination_base="$HTB_PATH"
else
    destination="$OBSIDIAN_NOTES_PATH/Hacking-Journey/Showcase"
    boxes_destination_base="$HTB_PATH"
    echo "No specific flag provided. Defaulting to 'Showcase' for recorded boxes intended for YouTube."
fi

# Create base directories if they don't exist
mkdir -p "$destination"
mkdir -p "$boxes_destination_base"

# Copy the template to the notes directory
if [[ "$ad_flag" == true || "$exam_flag" == true || "$training_flag" == true ]]; then
    echo "Creating folder structure in: $destination/$formatted_folder_name"
    
    for machine in "${machine_prefix[@]}"; do
        if [[ "$machine" == "AD_Set" && ("$exam_flag" == true || "$training_flag" == true) ]]; then
            # For AD_Set in exam/training mode:
            machine_folder="$destination/$formatted_folder_name/$machine"
            mkdir -p "$machine_folder"
            
            # Create domain-enum.md file in AD_Set
            echo "# Recon" > "$machine_folder/Domain-Enum.md"
            echo "Created Domain-Enum.md file in: $machine_folder"
            
            # Create and populate Internal1, Internal2, Internal3 with templates
            for internal in "${ad_subfolders[@]}"; do
                internal_folder="$machine_folder/$internal"
                mkdir -p "$internal_folder"
                cp -r "$TEMPLATE_PATH/." "$internal_folder"
                echo "Template copied to: $internal_folder"
            done
        else
            # Normal machine folder creation
            machine_folder="$destination/$formatted_folder_name/$machine"
            mkdir -p "$machine_folder"
            cp -r "$TEMPLATE_PATH/." "$machine_folder"
            echo "Template copied to: $machine_folder"
        fi
    done
else
    # Single folder creation for non-AD cases
    echo "Copying template to: $destination/$formatted_folder_name"
    mkdir -p "$destination/$formatted_folder_name"
    cp -r "$TEMPLATE_PATH/." "$destination/$formatted_folder_name"
    echo "Template copied successfully."
fi

# Create the working subfolders in the designated working directory
if [[ "$ad_flag" == true || "$exam_flag" == true || "$training_flag" == true ]]; then
    echo "Preparing to create folders for multiple machines in: $boxes_destination_base/$boxes_folder_name"
    for machine in "${machine_prefix[@]}"; do
        machine_folder="$boxes_destination_base/$boxes_folder_name/$machine"
        subfolders=("enum" "loot" "privesc" "exploit" "enum/internal" "enum/external")
        mkdir -p "$machine_folder"
        
        if [[ "$machine" == "AD_Set" && ("$exam_flag" == true || "$training_flag" == true || "$ad_flag" == true) ]]; then
            # Create domain-enum folder in working directory for AD_Set
            mkdir -p "$machine_folder/domain-enum"
            echo "Created domain-enum folder in working directory: $machine_folder/domain-enum"
            
            # Special handling for AD_Set in exam/training mode
            if [[ "$exam_flag" == true || "$training_flag" == true ]]; then
                for ad_subfolder in "${ad_subfolders[@]}"; do
                    ad_subfolder_path="$machine_folder/$ad_subfolder"
                    mkdir -p "$ad_subfolder_path"
                    for folder in "${subfolders[@]}"; do
                        mkdir -p "$ad_subfolder_path/$folder"
                        echo "Created: $ad_subfolder_path/$folder"
                    done
                done
            fi
        else
            for folder in "${subfolders[@]}"; do
                mkdir -p "$machine_folder/$folder"
                echo "Created: $machine_folder/$folder"
            done
        fi
    done
else
    echo "Preparing to create folders in: $boxes_destination_base/$boxes_folder_name"
    subfolders=("enum" "loot" "privesc" "exploit" "enum/internal" "enum/external")
    mkdir -p "$boxes_destination_base/$boxes_folder_name"
    for folder in "${subfolders[@]}"; do
        mkdir -p "$boxes_destination_base/$boxes_folder_name/$folder"
        echo "Created: $boxes_destination_base/$boxes_folder_name/$folder"
    done
fi

echo "Folders and subfolders created successfully."