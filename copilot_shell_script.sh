#!/bin/bash
# Assignment Copilot Manager

GREEN="\e[32m"; YELLOW="\e[33m"; RED="\e[31m"; BLUE="\e[34m"; RESET="\e[0m"

echo -e "${BLUE}\n=== Assignment Copilot Manager ===${RESET}"



shopt -s nullglob
dirs=(submission_reminder_*/)
shopt -u nullglob

if [[ ${#dirs[@]} -eq 0 ]]; then
    echo -e "${RED}Error: No submission_reminder_* directory found. Exiting.${RESET}"
    exit 1
elif [[ ${#dirs[@]} -gt 1 ]]; then
    echo -e "${RED}Error: Multiple submission_reminder directories found. Keep only one.${RESET}"
    exit 1
fi

main_dir="${dirs[0]%/}"
CONFIG_FILE="$main_dir/config/config.env"
STARTUP_SCRIPT="$main_dir/startup.sh"
BACKUP_FILE="$CONFIG_FILE.bkp.$(date +%s)"


[[ -f "$CONFIG_FILE" ]] || { echo -e "${RED}Config not found at $CONFIG_FILE${RESET}"; exit 1; }
[[ -x "$STARTUP_SCRIPT" ]] || { echo -e "${RED}$STARTUP_SCRIPT is not executable${RESET}"; exit 1; }

current_assignment=$(grep '^ASSIGNMENT=' "$CONFIG_FILE" | sed -E 's/ASSIGNMENT="(.*)"/\1/')
[[ -n "$current_assignment" ]] || { echo -e "${RED}Cannot read ASSIGNMENT from config.${RESET}"; exit 1; }

echo -e "Current assignment: ${YELLOW}$current_assignment${RESET}"


read -p "Enter the new assignment name: " new_assignment
new_assignment=$(echo "$new_assignment" | xargs)   
[[ -n "$new_assignment" ]] || { echo -e "${RED}Assignment name cannot be empty.${RESET}"; exit 1; }


escaped=$(printf '%s\n' "$new_assignment" | sed 's/[\/&]/\\&/g')
cp "$CONFIG_FILE" "$BACKUP_FILE"


if sed --version >/dev/null 2>&1; then
    sed -i -E "s|^ASSIGNMENT=\".*\"|ASSIGNMENT=\"${escaped}\"|" "$CONFIG_FILE"
else
    sed -i '' -E "s|^ASSIGNMENT=\".*\"|ASSIGNMENT=\"${escaped}\"|" "$CONFIG_FILE"
fi

updated_assignment=$(grep '^ASSIGNMENT=' "$CONFIG_FILE" | sed -E 's/ASSIGNMENT="(.*)"/\1/')
if [[ "$updated_assignment" != "$new_assignment" ]]; then
    echo -e "${RED}✗ Update failed – restoring backup.${RESET}"
    cp "$BACKUP_FILE" "$CONFIG_FILE"; exit 1;
fi
echo -e "${GREEN}✓ ASSIGNMENT updated to \"$updated_assignment\"${RESET}"


echo -e "\n${BLUE}Restarting submission reminder system...${RESET}"
echo "--------------------------------------------"
pushd "$main_dir" >/dev/null
./startup.sh
status=$?
popd >/dev/null

if [[ $status -ne 0 ]]; then
    echo -e "${RED}✗ Reminder system exited with errors.${RESET}"
    exit $status
fi

echo -e "${GREEN}\n=== Update Complete ===${RESET}"

