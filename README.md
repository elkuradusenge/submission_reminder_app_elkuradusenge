# 📘 Submission Reminder Application 

This manual provides a step-by-step explanation of how the Submission Reminder System works, what each script does, and how to use it.

---

## 🔧 System Components

### 1. `create_environment.sh`

* Purpose: Sets up your working environment.
* What it does:

  * Prompts you to enter your name.
  * Creates a directory named: `submission_reminder_{yourName}`.
  * Inside the directory, it creates:

    * A `students.txt` file with a list of student names.
    * An `assignment.txt` file with the current assignment name.
    * A `submissions/` directory to store submitted student files.
    * A `startup.sh` script to simulate the monitoring process.

---

### 2. `submission_reminder_{yourName}/startup.sh`

* Purpose: Simulates checking student submissions.
* What it does:

  * Reads the list of students from `students.txt`.
  * Checks which students have submitted by matching files in the `submissions/` folder.
  * Prints a list of students who have **not** submitted the assignment.

---

### 3. `copilot_shell_script.sh`

* Purpose: Lets you switch to a new assignment easily.
* What it does:

  * Prompts you for a new assignment name.
  * Updates the `assignment.txt` file with the new name.
  * Restarts the `startup.sh` script to check submissions for the new assignment.

---

## 🚀 How to Run the System (Step-by-Step)

### ✅ Step 1: Set up the Environment

Run the environment creation script:

```bash
./create_environment.sh
```

* You will be asked to enter your name.
* A new folder `submission_reminder_{yourName}` will be created.
* Navigate into the new directory:

```bash
cd submission_reminder_{yourName}
```

---

### ▶️ Step 2: Run the Submission Monitor

To check which students have not submitted the current assignment:

```bash
./startup.sh
```

* The script will read the list of students.
* It checks the `submissions/` folder for submitted assignments.
* It displays which students **have not** submitted.

---

### �� Step 3: Change the Assignment (Optional)

To monitor a different assignment:

```bash
./copilot_shell_script.sh
```

* You’ll be asked to enter a new assignment name.
* The system updates the `assignment.txt` file.
* The `startup.sh` script automatically re-runs using the new assignment name.

---

## 📁 Example Directory Structure

After running the setup, you will see:

```
submission_reminder_{userName}/
├── config/
│   └── config.env
├── modules/
│   └── functions.sh
├── assets/
│   └── submissions.txt
├── reminder.sh
└── startup.sh

```

---

## ✅ Summary

| Script                    | Description                                |
| ------------------------- | ------------------------------------------ |
| `create_environment.sh`   | Creates the initial folder and setup files |
| `submission_reminder_{userName}/startup.sh`              | Checks and shows who has not submitted     |
| `copilot_shell_script.sh` | Switches assignment and reruns the checker |


