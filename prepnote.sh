#!/bin/bash

CONFIG_FILE="$(dirname "$0")/config.txt"

# Ensure the configuration file exists and is sourced
if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "Error: Configuration file not found. Please run 'setup_prepnote.sh' to set up your paths."
  exit 1
fi

source "$CONFIG_FILE"

# Validate paths from the configuration file
paths_to_check=(
  "$OBSIDIAN_NOTES_PATH"
  "$TEMPLATE_PATH"
  "$HTB_PATH"
  "$PG_PATH"
  "$OSCP_PATH"
  "$OSCP_AD_PATH"
)

for path in "${paths_to_check[@]}"; do
  if [[ -z "$path" ]]; then
    echo "Error: One of the paths in the configuration file is not set. Please run 'setup_prepnote.sh' to update your configuration."
    exit 1
  elif [[ ! -d "$path" ]]; then
    echo "Error: The path '$path' from the configuration file does not exist. Please check or run 'setup_prepnote.sh' to update your paths."
    exit 1
  fi
done

# Script logic starts here
hackthebox_flag=false
proving_flag=false
oscp_flag=false
ad_flag=false
show_help=false

# Initialize an empty string for the folder name
folder_name=""

# Parse through all arguments
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
    --help)
      show_help=true
      shift
      ;;
    *)
      # The first non-flag argument is assumed to be the folder name
      if [[ -z "$folder_name" ]]; then
        folder_name="$1"
      fi
      shift
      ;;
  esac
done

if [[ "$show_help" == true ]]; then
  echo "Usage: prepnote [OPTIONS] FOLDER_NAME"
  echo "Options:"
  echo "  -h    Copy template to 'HackTheBox' destination."
  echo "  -p    Copy template to 'Proving Grounds' destination."
  echo "  -o    Copy template to 'OSCP - Challenge Labs' destination."
  echo "  -a    Copy template to 'OSCP - AD Challenge Labs' destination."
  echo "  --help Display this help message."
  exit 0
fi

# Check if the folder name is empty
if [[ -z "$folder_name" ]]; then
  echo "Error: No folder name provided."
  exit 1
fi

formatted_folder_name=$(echo "$folder_name" | awk '{print toupper(substr($0,1,1)) tolower(substr($0,2))}')
boxes_folder_name=$(echo "$folder_name" | awk '{print tolower($0)}')

destination=""
boxes_destination_base=""

# Set destination and boxes folder based on the selected flag
if [[ "$ad_flag" == true ]]; then
  destination="$OBSIDIAN_NOTES_PATH/OSCP - AD Challenge Labs"
  boxes_destination_base="$OSCP_AD_PATH"
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

# Create the destination directory if it doesn't exist
if [[ ! -d "$destination/$formatted_folder_name" ]]; then
  echo "Creating destination directory: $destination/$formatted_folder_name"
  mkdir -p "$destination/$formatted_folder_name" || {
    echo "Error: Failed to create the directory '$destination/$formatted_folder_name'."
    exit 1
  }
fi

# Check if the template directory exists before copying
if [[ ! -d "$TEMPLATE_PATH" ]]; then
  echo "Error: The template directory '$TEMPLATE_PATH' does not exist."
  exit 1
fi

# Copy the template to the destination folder for notes
echo "Copying template to: $destination/$formatted_folder_name"
cp -r "$TEMPLATE_PATH"/* "$destination/$formatted_folder_name" || {
  echo "Error: Failed to copy the template. Please check the paths and try again."
  exit 1
}
echo "Template copied successfully."

# Create the working subfolders in the designated boxes directory
echo "Preparing to create folders in: $boxes_destination_base/$boxes_folder_name"
echo "Folder name to use for boxes: '$boxes_folder_name'"
subfolders=("enum" "loot" "privesc" "exploit" "enum/internal" "enum/external")
for folder in "${subfolders[@]}"; do
  mkdir -p "$boxes_destination_base/$boxes_folder_name/$folder" || {
    echo "Error: Failed to create folder '$boxes_destination_base/$boxes_folder_name/$folder'."
    exit 1
  }
  echo "Created: $boxes_destination_base/$boxes_folder_name/$folder"
done

# Final message
echo "Folders and subfolders created successfully."
echo "prepnote script completed."
