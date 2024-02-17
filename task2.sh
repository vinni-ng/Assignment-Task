# Navigate to the directory containing the data
cd /mnt/d/Data/

# listing the files within the directory
ls

# unziping and inside this zipped file 
unzip hiriing_task2.zip

# Entering the hiriing_task2 directory
cd hiriing_task2/

# Gunzipping the compressed file
gunzip NC_000913.faa.gz

# Viewing the contents of the file 
cat NC_000913.faa

# Count the number of sequences
num_sequences=$(grep -c '^>' NC_000913.faa)

# Calculate the total number of amino acids
total_aa=$(grep -v '^>' NC_000913.faa | tr -d '\n' | wc -c)

# Calculate the average length
average_length=$(echo "scale=2; $total_aa / $num_sequences" | bc)

echo "The average length of proteins in this strain is $average_length"
