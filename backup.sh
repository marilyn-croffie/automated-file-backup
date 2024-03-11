#! /bin/bash

# This checks if the number of arguments is correct
# If the number of arguments is incorrect ( $# != 2) print error message and exit
if [[ $# != 2 ]]
then
  echo "backup.sh target_directory_name destination_directory_name"
  exit
fi

# This checks if argument 1 and argument 2 are valid directory paths
if [[ ! -d $1 ]] || [[ ! -d $2 ]]
then
  echo "Invalid directory path provided"
  exit
fi

# This sets directory variables to respective script argument paths
targetDirectory=$(echo $1)
destinationDirectory=$(echo $2)

# This validates input and assignments
echo -e "The directory to be backed up is $targetDirectory"
echo -e "The directory to store the backed up files is $destinationDirectory"

# This gets the current timestamp in seconds for backup filename identifier
currentTS=$(date +%s)
backupFileName=$(echo -e "backup-$currentTS.tar.gz")

# This defines relevant navigation variables and goes to the target directory
origAbsPath=`echo $(pwd)`

cd $destinationDirectory
destDirAbsPath=`echo $(pwd)`

cd $origAbsPath
cd $targetDirectory


# This gets the timestamp in seconds for the previous 24-hours
yesterdayTS=$(($currentTS - (24 * 60 * 60))


# This creates an empty array which will contain names of files to be backed up
declare -a toBackup

for file in $(ls $targetDirectory); 
do
  last_modified=`date -r $file +%s` 
  if [[ $last_modified > $yesterdayTS ]]
  then
    toBackup+=($file) 
  fi
done

# This creates the backup file
tar -czvf $backupFileName ${toBackup[@]}

# This moves the backup file to the desired directory
mv $backupFileName $destDirAbsPath