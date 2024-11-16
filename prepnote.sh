#!/bin/bash

# Path to the configuration file
CONFIG_FILE="$(dirname "$0")/config.txt"

# Read configuration file
if [[ -f "$CONFIG_FILE" ]]; then
  source "$CONFIG_FILE"
else
  echo "Error: Configuration file not found at $CONFIG_FILE"
  exit 1
fi

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

# Define the template directory
template_dir="$TEMPLATE_PATH"

# Copy `Template` folder to `vault/template`
if [[ -d "Template" ]]; then
  echo "Ensuring template folder exists in vault/template..."
  mkdir -p "$template_dir"
  cp -r Template/. "$template_dir"
  echo "Template folder copied successfully to $template_dir."
else
  echo "Error: Template directory not found in the root directory."
  exit 1
fi

# Initialize variables for destination paths
destination=""
boxes_destination_base=""

# Determine the destination based on the selected flag
if [[ "$exam_flag" == true ]]; then
  destination="$OBSIDIAN_NOTES_PATH/OSCP Exam"
  boxes_destination_base="$EXAM_PATH"
  machine_prefix=("AD_Machine" "Challenge1" "Challenge2" "Challenge3")
elif [[ "$training_flag" == true ]]; then
  destination="$OBSIDIAN_NOTES_PATH/OSCP Training"
  boxes_destination_base="$TRAINING_PATH"
  machine_prefix=("AD_Main" "Challenge1" "Challenge2" "Challenge3")
elif [[ "$ad_flag" == true ]]; then
  destination="$OBSIDIAN_NOTES_PATH/OSCP - AD Challenge Labs"
  boxes_destination_base="$OSCP_AD_PATH"
  machine_prefix=("Machine1" "Machine2" "Machine3")
elif [[ "$oscp_flag" == true ]]; then
  destination="$OBSIDIAN_NOTES_PATH/OSCP - Challenge Labs"
  boxes_destination_base="$OSCP_PATH"
elif [[ "$proving_flag" == true ]]; then
  destination="$OBSIDIAN_NOTES_PATH/Proving Grounds"
  boxes_destination_base="$PG_PATH"
elif [[ "$hackthebox_flag" == true ]]; then
  destination="$OBSIDIAN_NOTES_PATH/HackTheBox"
  boxes_destination_base="$HTB_PATH"
else
  destination="$OBSIDIAN_NOTES_PATH/Showcase"
  boxes_destination_base="$HTB_PATH"
  echo "No specific flag provided. Defaulting to 'Showcase' for recorded boxes intended for YouTube."
fi

# Copy the template to the notes directory
if [[ "$ad_flag" == true || "$exam_flag" == true || "$training_flag" == true ]]; then
  echo "Copying template multiple times to: $destination/$formatted_folder_name"
  for machine in "${machine_prefix[@]}"; do
    machine_folder="$destination/$formatted_folder_name/$machine"
    mkdir -p "$machine_folder"
    cp -r "$template_dir/." "$machine_folder"
    echo "Template copied to: $machine_folder"
  done
else
  echo "Copying template to: $destination/$formatted_folder_name"
  mkdir -p "$destination/$formatted_folder_name"
  cp -r "$template_dir/." "$destination/$formatted_folder_name"
  echo "Template copied successfully."
fi

# Create the working subfolders in the designated working directory
if [[ "$ad_flag" == true || "$exam_flag" == true || "$training_flag" == true ]]; then
  echo "Preparing to create folders for multiple machines in: $boxes_destination_base/$boxes_folder_name"
  for machine in "${machine_prefix[@]}"; do
    machine_folder="$boxes_destination_base/$boxes_folder_name/$machine"
    subfolders=("enum" "loot" "privesc" "exploit" "enum/internal" "enum/external")
    for folder in "${subfolders[@]}"; do
      mkdir -p "$machine_folder/$folder"
      echo "Created: $machine_folder/$folder"
    done
  done
else
  echo "Preparing to create folders in: $boxes_destination_base/$boxes_folder_name"
  subfolders=("enum" "loot" "privesc" "exploit" "enum/internal" "enum/external")
  for folder in "${subfolders[@]}"; do
    mkdir -p "$boxes_destination_base/$boxes_folder_name/$folder"
    echo "Created: $boxes_destination_base/$boxes_folder_name/$folder"
  done
fi

echo "Folders and subfolders created successfully."
