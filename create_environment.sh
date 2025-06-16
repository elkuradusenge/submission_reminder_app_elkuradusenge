#!/bin/bash

# Submission Reminder Environment Setup Script

# Color codes for output
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
BLUE="\e[34m"
RESET="\e[0m"



echo -e "${BLUE}Welcome to the Submission Reminder App Environment Setup!${RESET}"
echo "Hi, I am your assignment reminder to get started. let's start with the basics"

# Prompt for username
read -p "Please enter your name: " userName
userName=$(echo "$userName" | xargs)

# Validate input
if [[ -z "$userName" ]]; then
    echo -e "${RED}Error: Username cannot be empty. Exiting setup.${RESET}"
    exit 1
fi

main_dir="submission_reminder_${userName}"

# Check if directory exists
if [[ -d "$main_dir" ]]; then
    echo -e "${YELLOW}Directory '$main_dir' already exists. Setup will proceed safely.${RESET}"
else
    echo -e "${GREEN}Creating main directory: $main_dir...${RESET}"
    mkdir "$main_dir" || { echo -e "${RED}Failed to create main directory. Exiting.${RESET}"; exit 1; }
fi

# Directory structure
echo -e "${BLUE}Creating directory structure...${RESET}"
mkdir -p "$main_dir/config"
mkdir -p "$main_dir/modules"
mkdir -p "$main_dir/assets"

# Create config.env
echo -e "${GREEN}Creating config/config.env...${RESET}"
cat <<EOF > "$main_dir/config/config.env"
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOF

# Create modules/functions.sh
echo -e "${GREEN}Creating modules/functions.sh...${RESET}"
cat <<'EOF' > "$main_dir/modules/functions.sh"
#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}
EOF

# Create assets/submissions.txt
echo -e "${GREEN}Creating assets/submissions.txt...${RESET}"
cat <<EOF > "$main_dir/assets/submissions.txt"
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
Ifeanyi, Shell Navigation, submitted
Amaka, Git, not submitted
Blessing, Shell Basics, submitted
Tolu, Shell Navigation, not submitted
Emeka, Shell Basics, submitted
EOF

# Create reminder.sh
echo -e "${GREEN}Creating reminder.sh...${RESET}"
cat <<'EOF' > "$main_dir/reminder.sh"
#!/bin/bash

# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file
EOF

# Create startup.sh
echo -e "${GREEN}Creating startup.sh...${RESET}"
cat <<'EOF' > "$main_dir/startup.sh"
#!/bin/bash

echo "Launching the Submission Reminder App..."

# Check required files
required_files=("config/config.env" "modules/functions.sh" "assets/submissions.txt" "reminder.sh")

for file in "${required_files[@]}"; do
    if [[ ! -f "$file" ]]; then
        echo "Error: Required file '$file' not found!"
        exit 1
    fi
done

# Make sure reminder.sh is executable
chmod +x reminder.sh

# Start the reminder application
./reminder.sh
EOF

# Set permissions
echo -e "${BLUE}Setting file permissions...${RESET}"
chmod +x "$main_dir/"*.sh
chmod +x "$main_dir/modules/functions.sh"
chmod 644 "$main_dir/config/config.env"
chmod 644 "$main_dir/assets/submissions.txt"

# Summary
echo -e "${GREEN}Setup Complete!${RESET}"
echo "--------------------------------------------"
echo -e "${BLUE}Directory created:${RESET} $(realpath "$main_dir")"
echo -e "${BLUE}Next Steps:${RESET}"
echo "1. Navigate to your environment directory:"
echo -e "   ${YELLOW}cd $main_dir${RESET}"
echo "2. Run the application:"
echo -e "   ${YELLOW}./startup.sh${RESET}"

echo "--------------------------------------------"
echo -e "${GREEN}All files are ready and configured. Happy coding!${RESET}"

