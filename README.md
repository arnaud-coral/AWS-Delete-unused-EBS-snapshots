# 🚀 Delete unused AWS AMI Snapshots
Automate the process of listing or deleting AWS EC2 snapshots that aren't linked to any available or pending AMI.

## 📝 Table of Contents
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [License](#license)

## 🧰 Prerequisites
- An AWS Account
- AWS CLI configured with necessary permissions
- Bash environment for executing the script

## 💾 Installation
1. Clone this repository or download the script.
```
git clone https://github.com/arnaud-coral/AWS-Delete-unused-EBS-snapshots
```
2. Navigate to the directory.
```
cd [directory-name]
```
3. Make the script executable.
```
chmod +x delete_unused_snapshots.sh
```

## 🚴 Usage
1. For dry run mode (lists snapshots without deleting):
```
./delete_unused_snapshots.sh -d
```
2. For delete mode (deletes the unlinked snapshots):
```
./delete_unused_snapshots.sh
```

## 📜 License

This script is © 2023 by Arnaud Coral. It's licensed under [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/). Please refer to the license for permissions and restrictions.
