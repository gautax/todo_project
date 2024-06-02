#!/bin/bash

# Function to create a task
create_task() {
    echo "Enter id: "
    read -r task_id
    echo "Enter task title:"
    read -r task_title
    echo "Enter task description (optional):"
    read -r task_description
    echo "Enter task location (optional):"
    read -r task_location

    # Save the task details to a file
    echo "id: $task_id" > "task_file"
    echo "title: $task_title" >> "task_file"
    echo "description: $task_description" >> "task_file"
    echo "location: $task_location" >> "task_file"
    echo "completed: false" >> "task_file"

    echo "Task created successfully!"
}

# Function to update a task
update_task() {
    echo "Enter the ID of the task you want to update:"
    read -r task_id

    # Check if the task file exists
    if [[ ! -f "task_file" ]]; then
        echo "Task file not found." >&2
        return 1
    fi

    # Check if the task ID exists in the file
    if ! grep -q "^id: $task_id$" "task_file"; then
        echo "Task with ID $task_id not found." >&2
        return 1
    fi

    echo "Enter new title (leave blank to keep the current title):"
    read -r new_title

    echo "Enter new description (leave blank to keep the current description):"
    read -r new_description

    echo "Enter new location (leave blank to keep the current location):"
    read -r new_location

    # Update task details in the file
    if [[ -n $new_title ]]; then
        sed -i "s/^title: .*/title: $new_title/" "task_file"
    fi

    if [[ -n $new_description ]]; then
        sed -i "s/^description: .*/description: $new_description/" "task_file"
    fi

    if [[ -n $new_location ]]; then
        sed -i "s/^location: .*/location: $new_location/" "task_file"
    fi

    echo "Task with ID $task_id updated successfully!"
}

# Function to delete a task
delete_task() {
    echo "Enter the ID of the task you want to delete:"
    read -r task_id

    # Check if the task file exists
    if [[ ! -f "task_file" ]]; then
        echo "Task file not found." >&2
        return 1
    fi

    # Check if the task ID exists in the file
    if ! grep -q "^id: $task_id$" "task_file"; then
        echo "Task with ID $task_id not found." >&2
        return 1
    fi

    # Delete the task
    sed -i "/^id: $task_id$/d" "task_file"

    echo "Task with ID $task_id deleted successfully!"
}

# Function to show all information about a task
show_task() {
    echo "Enter the ID of the task you want to view:"
    read -r task_id

    # Check if the task file exists
    if [[ ! -f "task_file" ]]; then
        echo "Task file not found." >&2
        return 1
    fi

    # Check if the task ID exists in the file
    if ! grep -q "^id: $task_id$" "task_file"; then
        echo "Task with ID $task_id not found." >&2
        return 1
    fi

    # Display the task with the specified ID
    grep "^id: $task_id$" "task_file"
}

# Function to list tasks of a given day
list_tasks() {
    echo "Enter the date (YYYY-MM-DD) to list tasks for:"
    read -r date_input

    # Check if any task files exist
    if ! ls -A "task_file" &> /dev/null; then
        echo "No tasks found." >&2
        return 1
    fi

    # Loop through each task file
    for file in "task_file"; do
        # Read the due date from the task file
        read -r _ _ due_date _ < "$file"
        due_date=$(date -d "$due_date" +"%Y-%m-%d")

        # Check if the due date matches the input date
        if [[ $due_date == $date_input ]]; then
            echo "Task: $file"
            cat "$file"
            echo
        fi
    done
}

# Function to search for a task by title
search_task() {
    echo "Enter the title of the task you want to search for:"
    read -r task_title

    # Check if any task files exist
    if ! ls -A "task_file" &> /dev/null; then
        echo "No tasks found." >&2
        return 1
    fi

    # Loop through each task file
    for file in "task_file"; do
        # Check if the title exists in the task file
        if grep -q "^title: $task_title$" "$file"; then
            echo "Task: $file"
            cat "$file"
            echo
        fi
    done
}

# If no arguments provided, display tasks of the current day
if [[ $# -eq 0 ]]; then
    list_tasks
    exit 0
fi

# Main script logic
case $1 in
    "create_task") create_task ;;
    "update_task") update_task ;;
    "delete_task") delete_task ;;
    "show_task") show_task ;;
    "list_tasks") list_tasks ;;
    "search_task") search_task ;;
    *) echo "Invalid command. Available commands: create_task, update_task, delete_task, show_task, list_tasks, search_task" >&2 ;;
esac
