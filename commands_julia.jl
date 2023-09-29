path = "./file1.parquet"
# Write the Parquet file
Parquet.write_parquet(path, df)
# Read the Parquet file into a DataFrame
df2 = DataFrame(Parquet.Table(path))