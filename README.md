# File Locking Attribute Management and Backup Automation Script for Linux
A powerful Linux script for managing file locks, setting attributes (immutable, append-only), and automating backups with cron. Enhance security and streamline file management effortlessly.


# 📂 **Lock, Attribute, and Backup Management Script** 🗄️

This script provides a simple, user-friendly interface for managing files and directories in Linux. It allows you to set file attributes, lock/unlock files or directories with **`flock`**, and schedule automated backups using **`cron`**.

---

## 🚀 **Features**:

- **Set File Attributes**:
  - Make files immutable (**`+i`**) or append-only (**`+a`**).
  - Remove these attributes when no longer needed.

- **Lock/Unlock Files/Directories**:
  - Lock files or directories using **`flock`** to prevent modifications.
  - Unlock the file or directory when you're done.

- **Schedule Backups**:
  - Automatically back up files/directories to a specified location using **`cron`**.
  - Choose how often to back up (every 10 minutes, 15 minutes, 30 nminutes, hourly, daily, weekly).

---

## ⚙️ **How to Use**:

### 1. **Clone the Repository**:
   Clone this repository to your local machine:
   ```bash
   git clone https://github.com/Curious4Tech/lock-attribute-backup-manager.git
   cd lock-attribute-backup-manager
   ```

### 2. **Make the Script Executable**:
   After cloning, make the script executable by running:
   ```bash
   chmod +x manage.sh
   ```

### 3. **Run the Script**:
   Execute the script with:
   ```bash
   ./manage.sh
   ```

---

## 📝 **Script Walkthrough**:

When you run the script, you will be prompted to enter a **file or directory path** to manage. Based on your input, the script will present three main actions:

1. **Set Attributes**:
   - Make the file or directory immutable or append-only.
   - Remove these attributes as needed.

2. **Lock/Unlock**:
   - Use **`flock`** to lock or unlock the file or directory.
   - **Note**: You will need to press **`Ctrl+C`** to unlock if the file or directory is locked.

3. **Schedule Backup**:
   - Set up an automated backup with `cron`.
   - Choose how frequently the backup should run (every 10 minutes, 30 minutes, hourly, daily, or weekly).

---

## 📅 **Cron Scheduling Example**:

You can schedule backups at different intervals. Here are some options:

- **Every 10 minutes**: `*/10 * * * *`
- **Every 15 minutes**: `*/15 * * * *`
- **Every 30 minutes**: `*/30 * * * *`
- **Hourly**: `0 * * * *`
- **Daily**: `0 0 * * *`
- **Weekly**: `0 0 * * 0`

---

## 🛠️ **Prerequisites**:
Make sure your system has the following installed:

- `bash` (the script is designed to work with Bash)
- `chattr` (for file attributes)
- `flock` (for locking files/directories)
- `cron` (for scheduling backups)
- `rsync` (for backing up files)

---

## 📜 **License**:
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

🎉 **Enjoy the script! Happy managing!** 🎉
