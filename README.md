
# Prepnote

Prepnote is a setup script designed to streamline the organization of notes and project folders for individuals practicing penetration testing on vulnerable boxes provided by platforms like HackTheBox, Proving Grounds, or OSCP labs. While not essential, it simplifies the setup process, making it easier to manage notes, templates, and project directories efficiently. Perfect for aspiring ethical hackers, red teamers, or anyone looking to enhance their workflow.

## Features
- Interactive setup script (`setup_prepnote.sh`) to configure project paths.
- Automated copying of a template folder to a specified location.
- Creation of directories for specific pentesting projects, including Exam and Training environments.
- Option to create a symlink for easier script access.

## Prerequisites
- Bash shell environment.
- Appropriate permissions for creating directories and copying files.
- The `setup_prepnote.sh` and `prepnote.sh` scripts, along with a `Template` folder.

## Installation
1. Clone the repository:
    ```bash
    git clone https://github.com/yourusername/prepnote.git
    cd prepnote
    ```

2. Copy and rename the provided `template_config.txt` file:
    ```bash
    cp template_config.txt config.txt
    ```

3. Edit `config.txt` to pre-fill the paths for your setup:
    ```bash
    nano config.txt
    ```
   **Note:** Filling out `config.txt` beforehand can expedite the interactive setup process.

## Usage

### Running `setup_prepnote.sh`
Run the `setup_prepnote.sh` script to configure your setup interactively:
```bash
./setup_prepnote.sh
```
- The script will guide you through setting paths for your Obsidian notes, template storage, and project directories.
- If a path does not exist, the script will prompt you to create it.
- The script copies the template folder to your designated template path if not already present.

### Running `prepnote.sh`
After completing the setup, use `prepnote.sh` to create new project folders:
```bash
./prepnote.sh [OPTIONS] FOLDER_NAME
```

#### Options:
- `-h` : Create a project folder under HackTheBox.
- `-p` : Create a project folder under Proving Grounds.
- `-o` : Create a project folder under OSCP Challenge Labs.
- `-a` : Create a project folder under OSCP AD Challenge Labs.
- `-e` : Create a project folder under OSCP Exam environment with AD and challenge lab machines.
- `-t` : Create a project folder under OSCP Training environment with AD and challenge lab machines.
- `--help` : Display usage information.

**The ```-t``` Flag doesn't like the Practice Boxes A,B and C from Pen200! Minor Bug. Call them -A-, or anything but a single Capital Letter or it will break**

### Example
To create a new HackTheBox project folder:
```bash
./prepnote.sh -h NewMachineName
```

To create a new OSCP Training environment:
```bash
./prepnote.sh -t TrainingSession
```

## Optional Step: Create a Symlink
To make `prepnote` accessible from any directory, create a symlink:
```bash
sudo ln -s /path/to/your/prepnote.sh /usr/local/bin/prepnote
```
Now, you can run:
```bash
prepnote -h NewMachineName
```

## Template Directory
Ensure that your `Template` folder is in the root directory of the project. This folder should contain any files or structures you want to copy when creating a new project folder.

## Debugging & Troubleshooting
- If the script outputs an error regarding missing paths, ensure the `config.txt` file is correctly filled out.
- Check the permissions if there are issues with creating directories or copying templates.

## License
This project is licensed under the MIT License.

## Contributions
Contributions are welcome! Feel free to fork the repository and submit a pull request with improvements.

## Contact
For any questions or support, contact BytesizedSecurity@proton.me or reach out on Youtube!
