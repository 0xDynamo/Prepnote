I'll incorporate the detail that the `prepnote` script can be added to either `bashrc` or `zshrc` files for convenience. Here's the updated README.md template for GitHub, including this addition:

---

# Project Name: Dynamic PrepNote Script

## Description

The `prepnote` script is a customizable bash utility designed to streamline the setup process for various projects, focusing especially on penetration testing and cybersecurity tasks. It automates the creation of a structured directory layout for showcasing achievements and organizing project efforts efficiently. This script is particularly useful for individuals engaging in platforms like Hack The Box or for any project requiring an organized file structure. It assumes that the Showcase directory is a duplicate of the Local Notes folder from Obsidian, facilitating seamless integration with your knowledge management practices.

## Requirements

- Bash or Zsh shell environment
- Standard Unix utilities (`cp`, `mkdir`, `echo`, `awk`)

## Installation

To make the `prepnote` function available in your shell environment, add it to your `.bashrc` or `.zshrc` file. This makes the function accessible anytime you open a terminal.

1. Open your `.bashrc` or `.zshrc` file in a text editor. For example:
   ```bash
   nano ~/.bashrc
   ```
   or
   ```zsh
   nano ~/.zshrc
   ```

2. Copy and paste the `prepnote` function into the file.

3. Save the file and exit the editor.

4. Apply the changes by sourcing your `.bashrc` or `.zshrc` file:
   ```bash
   source ~/.bashrc
   ```
   or
   ```zsh
   source ~/.zshrc
   ```

## Usage

### How to Use

Invoke the `prepnote` script by calling it with the desired project name as an argument:

```bash
prepnote <project_name>
```

The script performs the following actions:

- Creates a new project folder in two specified locations with adaptable naming conventions: one for showcasing (with the first letter capitalized) and another for project files (in lowercase).
- Duplicates a template directory (your Local Notes from Obsidian for the Showcase part) into the showcase directory.
- Establishes a structured set of directories within the project files location, catering to various project needs.

### Function Template

Here's a customizable template of the `prepnote` function:

```bash
prepnote() {
  # Define your template and destination directories
  local template_dir="<path_to_template>"
  local showcase_destination="<path_to_showcase_dir>"
  local project_destination="<path_to_project_dir>"
  
  local new_folder_name="$1"
  # Customize the naming convention here
  local showcase_folder_name=$(echo "$new_folder_name" | awk '{customize this part}')
  local project_folder_name=$(echo "$new_folder_name" | awk '{customize this part}')
  
  # Operations for the Showcase directory
  cp -r "$template_dir" "$showcase_destination/$showcase_folder_name"
  
  # Operations for the project files directory
  mkdir -p "$project_destination/$project_folder_name"
  # Add subdirectories as needed
  mkdir -p "$project_destination/$project_folder_name/subdirectory1"
  # Continue for other subdirectories...
  
  echo "Setup completed for $showcase_destination/$showcase_folder_name"
  echo "Setup completed for $project_destination/$project_folder_name"
}
```

Adjust `<path_to_template>`, `<path_to_showcase_dir>`, and `<path_to_project_dir>` with the actual paths on your system. Customize the `awk` commands to format your folder names according to your preferences.

## Contributing

You should of course adapt this to your liking and environment. This is a template
---
