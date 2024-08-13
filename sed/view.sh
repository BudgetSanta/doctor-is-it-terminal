#!/usr/bin/env bash

usage() {
    echo "Usage: $0 <exercise-number>"
    echo "Arguments:"
    echo "  <exercise-number>  Number of exercise you're looking at. i.e. '2'"
    exit 1
}

if [ "$#" -ne 1 ]; then
    echo >&2 "Error: Incorrect number of arguments"
    usage
fi

exercise_number=$1
exercise_directory="ex/${exercise_number}"
input_file="${exercise_directory}/in"
expected_output_file="${exercise_directory}/out"

# Setup checks
if [ ! -d "${exercise_directory}" ]; then
    echo >&2 "Error: Exercise ${exercise_number} does not exist"
    usage
fi

# Show the exercise
echo -e "Exercise ${exercise_number}."
echo -e "You need to transform the following input to the output using a sed command.\n"
echo -e "\t Input: $(cat ${input_file})"
echo -e "\tOutput: $(cat ${expected_output_file})\n"
echo -e "You can run the following command to attempt the exercise:\n"
echo -e "\t./check.sh ${exercise_number} <your-sed-command>\n"
echo -e "Example: ./check.sh ${exercise_number} \"s/foo/bar/pig\"\n"
