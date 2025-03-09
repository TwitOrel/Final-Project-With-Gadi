#!/bin/bash

# Variable to store the CSV file name
CSV_FILE="plants.csv"

# Function to create a CSV file
create_csv() {
    echo "Enter the name of the new CSV file (including .csv extension):"
    read CSV_FILE
    echo "Plant,Height,Leaf Count,Dry Weight" > "$CSV_FILE"
    echo "CSV file '$CSV_FILE' created successfully."
}

# Function to choose a CSV file
choose_csv() {
    echo "Enter the name of the CSV file you want to use:"
    read tmp
    if [ -f "$tmp" ]; then
        CSV_FILE=$tmp 
        echo "Current file set to: $CSV_FILE"
    else
        echo "file not exist."
    fi
}

# Function to display the CSV file
view_csv() {
    cat "$CSV_FILE"
}

# Function to add a new row for a specific plant
add_entry() {
    echo "Enter plant name:"
    read plant
    echo "Enter heights separated by spaces:"
    read height
    echo "Enter leaf counts separated by spaces:"
    read leaf_count
    echo "Enter dry weights separated by spaces:"
    read dry_weight
    echo "$plant,$height,$leaf_count,$dry_weight" >> "$CSV_FILE"
    echo "Row added successfully."
}

# Function to run Python analysis
run_python_analysis() {
    if [ -z "$CSV_FILE" ]; then
        echo "No CSV file selected. Please choose a CSV file first."
        return
    fi

    echo "Enter the plant name:"
    read plant_name

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
}

# Function to update values in a row by plant name
update_entry() {
    echo "Enter the plant name to update:"
    read plant

    data=$(awk -F',' -v plant="$plant" '$1 == plant {print}' "$CSV_FILE")
    if [ -z "$data" ]; then
        echo "Plant not found in CSV file."
        return
    fi

    echo "Current data: $data"
    echo "Enter new heights separated by spaces:"
    read height
    echo "Enter new leaf counts separated by spaces:"
    read leaf_count
    echo "Enter new dry weights separated by spaces:"
    read dry_weight

    grep -v "^$plant," "$CSV_FILE" > temp.csv
    echo "$plant,\"$height\",\"$leaf_count\",\"$dry_weight\"" >> temp.csv
    mv temp.csv "$CSV_FILE"

    echo "Plant data updated successfully."
}

# Function to remove a row by index or plant name
remove_entry() {
    echo "Enter row index to delete or plant name:"
    read value
    if [[ "$value" =~ ^[0-9]+$ ]]; then
        sed -i "${value}d" "$CSV_FILE"
    else
        grep -v "^$value," "$CSV_FILE" > temp.csv && mv temp.csv "$CSV_FILE"
    fi
    echo "Row deleted successfully."
}

# Function to display the plant with the highest average leaf count
highest_avg_leaves() {
    awk -F',' '{
        if (NR > 1) {
            split($3, leaves, " ");
            total = 0; count = 0;
            for (i in leaves) {
                total += leaves[i]; count++;
            }
            avg = total / count;
            if (avg > max_avg) {
                max_avg = avg;
                max_plant = $1;
            }
        }
    } END { print "The plant with the highest average leaf count is: " max_plant }' "$CSV_FILE"
}

# Menu
while true; do
    echo "Choose an action:"
    echo "1) Create CSV file"
    echo "2) Choose current CSV file"
    echo "3) Display the current CSV file"
    echo "4) Add a new row for a specific plant"
    echo "5) Run the improved Python code with parameters for a specific plant to generate diagrams"
    echo "6) Update values in a row by plant name"
    echo "7) Delete a row by index or plant name"
    echo "8) Display the plant with the highest average leaf count"
    echo "9) Exit"
    read choice
    case $choice in
        1) create_csv ;;
        2) choose_csv ;;
        3) view_csv ;;
        4) add_entry ;;
        5) run_python_analysis ;;
        6) update_entry ;;
        7) remove_entry ;;
        8) highest_avg_leaves ;;
        9) exit 0 ;;
        *) echo "Invalid choice, please try again." ;;
    esac
done
