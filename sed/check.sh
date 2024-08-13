#!/usr/bin/env bash

usage() {
    echo "Usage: $0 <exercise-number> <sed-command>"
    echo "Arguments:"
    echo "  <exercise-number>  Number of exercise you're checking. i.e. '2'"
    echo "  <sed-command>  Command passed to sed to emulate result for checking"
    exit 1
}

get_date() {
    date +"%d-%m-%Y %H:%M:%S"
}

if [ "$#" -ne 2 ]; then
    echo >&2 "Error: Incorrect number of arguments"
    usage
fi

exercise_number=$1
sed_command=$2
exercise_directory="ex/${exercise_number}"
input_file="${exercise_directory}/in"
expected_output_file="${exercise_directory}/out"
success_file="${exercise_directory}/successes"
attempt_file="${exercise_directory}/attempts"

formatted_command="\$ cat in| sed \"${sed_command}\""

# Setup checks
if [ ! -d "${exercise_directory}" ]; then
    echo >&2 "Error: Exercise ${exercise_number} does not exist"
    usage
fi

# Transform input using command
transformation_output=$(cat "${input_file}"| sed "${sed_command}" 2>&1)
if [ $? -ne 0 ]; then
    echo >&2 -e "Uh oh, there was an error when sed used your command '${sed_command}'\n\n\t${transformation_output}"
    exit 1
fi

# Attempt the exercise
comparison_output=$(diff "${expected_output_file}" <(echo "${transformation_output}"))
if [ $? -eq 0 ]; then
    echo -e "Congrats, your command correctly transforms the input to the output\n\n\t${transformation_output}"

    if [ ! -f "${success_file}" ]; then
        echo -e "Successes:\n" > "${success_file}"
    fi
    get_date >> "${success_file}"
    echo "" >> "${success_file}"
    echo -e "\t${formatted_command}\n" >> "${success_file}"
    exit 0
else
    echo -e "Not quite. Theres a difference between the input and your transformation\n"

    expected=$(cat "${expected_output_file}")
    actual=${transformation_output}

    if [ ! -f "${attempt_file}" ]; then
        echo -e "Unsuccessful attempts:\n" > "${attempt_file}"
    fi

    get_date >> "${attempt_file}"
    echo "" >> "${attempt_file}"
    echo -e "\t\$ cat in| sed \"${sed_command}\"\n" >> "${attempt_file}"

    echo -e "\texpected output: ${expected}" | tee -a "${attempt_file}"
    echo -e "\t  actual output: ${actual}\n" | tee -a "${attempt_file}"

    exit 1
fi
