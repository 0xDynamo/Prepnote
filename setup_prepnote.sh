#!/bin/bash

CONFIG_FILE="$(dirname "$0")/config.txt"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DEFAULT_TEMPLATE_DIR="$SCRIPT_DIR/Template"  # Path to the Template folder in the current directory

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

# Inform the user about the config.txt file
echo ""
echo "Note: The setup will be quicker if you fill out the 'config.txt' file with your paths beforehand."
read -p "Do you wish to continue with the interactive setup? (Y/n) [Y]: " continue_choice
continue_choice=${continue_choice:-Y}

if [[ ! "$continue_choice" =~ ^[Yy]$ ]]; then
  echo "Exiting the setup. You can edit 'config.txt' manually and run this script again."
  exit 0
fi

# Function to prompt for path input and create it if it doesn't exist
prompt_for_path() {
  local prompt_message="$1"
  local current_value="$2"
  local path_variable

  while true; do
    read -p "$prompt_message (current: ${current_value:-not set}): " path_variable
    path_variable=${path_variable:-$current_value}  # Use the current value if Enter is pressed
    if [[ -z "$path_variable" ]]; then
      echo "Error: Path cannot be empty. Please enter a valid path."
    elif [[ -d "$path_variable" ]]; then
      echo "$path_variable"
      break
    else
      read -p "The path '$path_variable' does not exist. Would you like to create it? (y/n) [Y]: " create_choice
      create_choice=${create_choice:-Y}  # Default to 'Y' if Enter is pressed
      if [[ "$create_choice" == "y" || "$create_choice" == "Y" ]]; then
        mkdir -p "$path_variable"
        if [[ $? -eq 0 ]]; then
          echo "$path_variable"
          break  # Directory successfully created
        else
          echo "Error: Failed to create directory '$path_variable'. Please check permissions."
          exit 1
        fi
      else
        echo "Please enter a valid path or choose to create it."
      fi
    fi
  done
}

# Interactive prompts for setting up paths
echo "Please provide the paths for your setup. Press Enter to keep the current/suggested value."
echo ""

# Read current values from config file if it exists
if [[ -f "$CONFIG_FILE" ]]; then
  source "$CONFIG_FILE"
fi

# Prompt for paths and assign them to variables
obsidian_notes_path=$(prompt_for_path "Enter the path to your Obsidian notes vault" "$OBSIDIAN_NOTES_PATH")
template_path=$(prompt_for_path "Enter the path where you want to store the template folder within your notes vault" "$TEMPLATE_PATH")
working_dir=$(prompt_for_path "Enter the path for your general working directory" "$WORKING_DIR")
exam_path=$(prompt_for_path "Enter the path for your OSCP Exam working folder" "$EXAM_PATH")
training_path=$(prompt_for_path "Enter the path for your OSCP Training working folder" "$TRAINING_PATH")
htb_path=$(prompt_for_path "Enter the path for your HackTheBox working folder" "$HTB_PATH")
pg_path=$(prompt_for_path "Enter the path for your Proving Grounds working folder" "$PG_PATH")
oscp_path=$(prompt_for_path "Enter the path for your OSCP Challenge Labs working folder" "$OSCP_PATH")
oscp_ad_path=$(prompt_for_path "Enter the path for your OSCP AD Challenge Labs working folder" "$OSCP_AD_PATH")


# Copy the default template to the designated location if needed
if [[ -d "$DEFAULT_TEMPLATE_DIR" ]]; then
  echo "Default template directory found at $DEFAULT_TEMPLATE_DIR."
  if [[ ! -d "$template_path" || -z "$(ls -A "$template_path" 2>/dev/null)" ]]; then
    echo "Copying the default template folder to: $template_path"
    cp -r "$DEFAULT_TEMPLATE_DIR"/* "$template_path"
    if [[ $? -eq 0 ]]; then
      echo "Default template successfully copied to $template_path."
    else
      echo "Error: Failed to copy the default template. Please check the paths and permissions."
      exit 1
    fi
  else
    echo "The template folder at $template_path already contains files. Skipping template copy."
  fi
else
  echo "Error: The default template folder at $DEFAULT_TEMPLATE_DIR was not found. Please ensure it exists in the current directory."
  exit 1
fi


# Debugging statements to ensure variables are set correctly
echo ""
echo "Debug: OBSIDIAN_NOTES_PATH='$obsidian_notes_path'"
echo "Debug: TEMPLATE_PATH='$template_path'"
echo "Debug: EXAM_PATH='$exam_path'"
echo "Debug: TRAINING_PATH='$training_path'"
echo "Debug: WORKING_DIR='$working_dir'"
echo "Debug: HTB_PATH='$htb_path'"
echo "Debug: PG_PATH='$pg_path'"
echo "Debug: OSCP_PATH='$oscp_path'"
echo "Debug: OSCP_AD_PATH='$oscp_ad_path'"
echo ""

# Save paths to the configuration file
cat <<EOL > "$CONFIG_FILE"
# Configuration for the prepnote setup script

# Path to your Obsidian notes vault where your notes are stored.
OBSIDIAN_NOTES_PATH="$obsidian_notes_path"

# Path where you want to store the template folder within your notes vault.
TEMPLATE_PATH="$template_path"

# Path for your OSCP Exam working folder.
EXAM_PATH="$exam_path"

# Path for your OSCP Training working folder.
TRAINING_PATH="$training_path"

# General working directory path.
WORKING_DIR="$working_dir"

# Path for your HackTheBox working folder.
HTB_PATH="$htb_path"

# Path for your Proving Grounds working folder.
PG_PATH="$pg_path"

# Path for your OSCP Challenge Labs working folder.
OSCP_PATH="$oscp_path"

# Path for your OSCP AD Challenge Labs working folder.
OSCP_AD_PATH="$oscp_ad_path"
EOL

# Check if the paths were written correctly
if [[ $? -eq 0 ]]; then
  echo ""
  echo "Setup completed. Configuration saved to $CONFIG_FILE."
else
  echo "Error: Failed to write to $CONFIG_FILE. Please check permissions and try again."
  exit 1
fi

echo ""
echo ""
echo "You can run this script again to modify paths or manually edit $CONFIG_FILE if needed."

# Prompt the user to create a symlink to /usr/local/bin
read -p "Would you like to create a symlink for 'prepnote.sh' and 'config.txt' in /usr/local/bin for easier access? (y/n) [N]: " symlink_choice
symlink_choice=${symlink_choice:-N}
if [[ "$symlink_choice" =~ ^[Yy]$ ]]; then
  sudo ln -s "$SCRIPT_DIR/prepnote.sh" /usr/local/bin/prepnote
  sudo cp "$(dirname "$0")/config.txt" /usr/local/bin/config.txt
  if [[ $? -eq 0 ]]; then
    echo "Symlinks created successfully. You can now run 'prepnote' from anywhere."
  else
    echo "Error: Failed to create the symlink. Please check permissions or try again."
  fi
fi