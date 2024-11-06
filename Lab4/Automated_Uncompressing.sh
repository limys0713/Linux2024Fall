#!/bin/bash

# Define directories
compressed_dir="compressed_files"
student_id_file="student_id"
missing_list="missing_list"
wrong_list="wrong_list"

# Create file
# > filename : To create or empty a file in Bash
> "$missing_list"
> "$wrong_list"

# Create directories for classifying the files
mkdir -p "$compressed_dir/zip" "$compressed_dir/rar" "$compressed_dir/tar.gz" "$compressed_dir/unknown"

# Check for missing files and wrong file format
### mapfile array_variable_name < file_name : A built-in command in Bash that reads lines from standard input or a file
### -t : To remove \n character at the end of each line
mapfile -t student_ids < "$student_id_file"

for student_id in "${student_ids[@]}"
do
	# Find files with the student ID prefix in compressed_files
	### Use -maxdepth 1 if there are subdirectories inside the files
	### $() : Command substitution: Allow you to run a command ans substitute its output in place, storing it directly in a variable
	### () : For Array Initialization
	### find: Command used to search for files and directories
	file=$(find "$compressed_dir" -name "${student_id}.*")

	# Check if any files were found
	### ${#array[@]} returns the number of elements in the array
	### number1 -eq number2 : Check whether number1 is same as number2
	### -z "$file" : Check if the file variable is empty(zero length)
	if [ -z "$file" ]; then
		echo "$student_id" >> "$missing_list"
	else
		# Check the file format
		case "$file" in
			*.zip)
				mv "$file" "$compressed_dir/zip/"
				;;
			*.tar.gz)
				mv "$file" "$compressed_dir/tar.gz/"
				;;
			*.rar)
				mv "$file" "$compressed_dir/rar/"
				;;
			*)
				echo "$student_id" >> "$wrong_list" ;
				mv "$file" "$compressed_dir/unknown/"
				;;
		esac
	fi
done

# Uncompress files
echo "UnCompressing files..."

# Uncompress all .zip files in the zip directory
for zip_file in "$compressed_dir/zip/"*.zip;
do
	### unzip -d destination_directory zip_file
	[ -e "$zip_file" ] && unzip -d "$compressed_dir/zip" "$zip_file"
done

# Uncompress all .rar files in the rar directory
for rar_file in "$compressed_dir/rar/"*.rar;
do
	### unrar x : Mode for extraction with full paths(preserve the original directory structure
	[ -e "$rar_file" ] && unrar x "$rar_file" "$compressed_dir/rar"
done

# Uncompress all .tar.gz files in the tar.gz directory
for tar_gz_file in "$compressed_dir/tar.gz/"*.tar.gz;
do
	### -x : extract, -z : decompress using gzip, -v : verbose option inorder to display the names of files being extracted, -f "$file" : specifes the file to operate on, -C dest directory
	[ -e "$tar_gz_file" ] && tar -xzvf "$tar_gz_file" -C "$compressed_dir/tar.gz"
done

echo "Processing complete."
