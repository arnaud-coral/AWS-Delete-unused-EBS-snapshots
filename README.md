# AWS Delete unused EBS snapshots

A little bash script to delete unused AWS Elastic Block Store snapshots (not linked to any volume)

## Licence

![License: CC0-1.0](https://licensebuttons.net/l/zero/1.0/80x15.png) Creative Commons Zero v1.0 Universal

## Prerequisites

- Install AWS CLI
- Configure AWS CLI with access key ID, Access secret key and default region

## Usage

- Dry run mode:
```bash
./delete_unused_snapshots.sh -d
```

- Delete mode:
```bash
./delete_unused_snapshots.sh
```
