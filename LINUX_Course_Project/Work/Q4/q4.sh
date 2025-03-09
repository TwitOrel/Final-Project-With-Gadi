#!/bin/bash

# Set default CSV file
CSV_FILE=""
VENV_DIR="venv"
DIAGRAMS_DIR="Diagrams"
BACKUP_DIR="../../BACKUPS"
BACKUP_FILE="$BACKUP_DIR/backup_$(date +%Y%m%d%H%M%S).tar.gz"

# Function to find or receive a CSV file
find_csv_file() {
    if [ -n "$1" ]; then
        CSV_FILE=$1
    else
        CSV_FILE=$(find . -maxdepth 1 -type f -name "*.csv" | head -n 1)
    fi
    if [ -z "$CSV_FILE" ]; then
        echo "No CSV file found or provided. Exiting."
        exit 1
    fi
    echo "Using CSV file: $CSV_FILE"
}

# Function to create and activate virtual environment
setup_venv() {
    if [ ! -d "$VENV_DIR" ]; then
        echo "Creating virtual environment..."
        python3 -m venv "$VENV_DIR"
        if [ $? -ne 0 ]; then
            echo "Failed to create venv, exiting";
            exit 1;
        fi
    fi
    
    source "$VENV_DIR/bin/activate"
    echo "Virtual environment activated."
    
    if [ -f "../Q2/requirements.txt" ]; then
        echo "Installing dependencies..."
        pip install -r ../Q2/requirements.txt
        if [ $? -ne 0 ]; then
            echo "Failed to install dependencies, exiting";
            exit 1;
        fi
    else
        echo "Failed to install dependencies, exiting";
        exit 1;
    fi
}

# Function to process CSV file
process_csv() {
    mkdir -p "$DIAGRAMS_DIR"
    if [ $? -ne 0 ]; then
        echo "Failed to create diagrams directory, exiting";
        exit 1;
    fi
    echo "Processing CSV file..."
    while IFS=, read -r plant_name height leaf_count dry_weight; do
        echo "Running script for: $plant_name"
        data=$(awk -F',' -v plant="$plant_name" '$1 == plant {print $2","$3","$4}' "$CSV_FILE")
        if [ -z "$data" ]; then
            echo "Plant not found in CSV file."
            return
        fi
        clean_data=$(echo "$data" | tr -d '"' | tr -d '\r')
        heights=$(echo "$clean_data" | cut -d',' -f1)
        leaf_counts=$(echo "$clean_data" | cut -d',' -f2)
        dry_weights=$(echo "$clean_data" | cut -d',' -f3)
        python3 ../Q2/plant-improved.py --plant "$plant_name" --height $heights --leaf_count $leaf_counts --dry_weight $dry_weights
        if [ $? -ne 0 ]; then
            echo "Failed to run the script, exiting";
            exit 1;
        fi
        mv *.png Diagrams
    done < <(tail -n +2 "$CSV_FILE")
    if [ $? -ne 0 ]; then
        echo "Failed to create venv, exiting";
        exit 1;
    fi
    echo "CSV processing completed."
}

# Function to create a backup
create_backup() {
    mkdir -p "$BACKUP_DIR"
    if [ $? -ne 0 ]; then
        echo "Failed to create backup directory, exiting";
        exit 1;
    fi
    tar -czf "$BACKUP_FILE" "$DIAGRAMS_DIR"
    if [ $? -ne 0 ]; then
        echo "Failed to create backup archive, exiting";
        exit 1;
    fi
    echo "Backup created: $BACKUP_FILE"
}

# Main Execution
find_csv_file "$1"
setup_venv
process_csv
create_backup

echo "Script execution completed successfully."