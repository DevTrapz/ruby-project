# Import Generation

This tool is used to automate the 
importing of schema and data from a CSV file.

### Setup
This tool uses a couple of new gems. So make sure to run:
`$ bundle install`

### Importing Schema from a CSV
The tool expects field names in the first row and field types in the second row. If a field name starts with a four digit number the tool will assume its a date and convert the column as such: 2024-03-10 will become Mar2024. 

All other rows should contain data. Possible field types can be found [here](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SchemaStatements.html#method-i-add_column).

TODO: Implement indexes as and adon to the second row or add a third row for indexes and foreign keys.

There is an example CSV file here: ./rails/lib/tasks/import/Metro_sales_count_now_uc_sfrcondo_month.csv

``` bash 
$ rake import:model_from_csv <filename> <modelname>
```

If successful the raek task will create a migration file and run the migration. The result will be a new model and a new table in the database. Stub tests and fixtures will be created as a convenience as well.

### Importing Data from a CSV
Once the model is created then the data importer can be run. The same csv filename and modelname used in the model importer must be used as well. A batch importer will be used with a max batch threshold of 1000 records per batch. The tool will handle all the details. Just run the following:

``` bash 
$ rake import:data_from_csv <filename> <modelname>
```
