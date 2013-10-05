SQLiteDatabase class for iOS Objective-C , sqlite3 .

Features :
<ul>
    <li>Single connection to the database ( using Singleton pattern ) .</li>
	<li>Dynamic named parameter binding ( does not support parameter with only ? mark , you must provide parameter name as in examples )</li>
</ul>
Usage :
first of all , you should already have a sqlite database file , you can create your database with several tools : [https://addons.mozilla.org/en-US/firefox/addon/sqlite-manager/](https://addons.mozilla.org/en-US/firefox/addon/sqlite-manager/), [http://sourceforge.net/projects/sqlitebrowser/](http://sourceforge.net/projects/sqlitebrowser/) , [http://www.sqliteexpert.com/](http://www.sqliteexpert.com/) , [http://www.razorsql.com/features/sqlite_table_editor.html](http://www.razorsql.com/features/sqlite_table_editor.html) .

if you already have one , open SQLiteDatabase.h and change @"database_file.sqlite" to your file name
<pre>#define DATABASE_FILE_NAME @"database_file.sqlite"</pre>
SQLiteDatabase has 2 main methods ,
one for select (qin:withParams) ,
second for update/delete/insert (qout:withParams) ,
both of them return SQLiteResult object , first you should check if it succeeded or not , it has @property success , if it failed you can see error message in @property errorMessage , if it succeeded you can get each SQLiteRow ,
you can get a column data from SQLiteRow with several methods ( please see SQLiteRow.h ) ,

Examples are below :

SELECT without parameters
<pre>        SQLiteResult *result = [SQLiteDatabase qin:@"SELECT * FROM table " withParams:nil];
        if(result.success) {
            NSLog(@"Result count %d",result.count);

            for(SQLiteRow *row in result) {
                for(NSString *columnName in row.columnNames) {
                    NSLog(@"%@ => %@",columnName,[row objectForColumnName:columnName]);
                }
            }

        } else {
            NSLog(@"Error => %@",result.errorMessage);
        }</pre>
SELECT with parameters
<pre>        NSDictionary *params = @{
                                 @"id" : [NSNumber numberWithInt:3]
                                 };
        SQLiteResult *result = [SQLiteDatabase qin:@"SELECT * FROM table WHERE id = :id " withParams:params];
        if(result.success) {
            NSLog(@"Result count %d",result.count);

            for(SQLiteRow *row in result) {
                for(NSString *columnName in row.columnNames) {
                    NSLog(@"%@ => %@",columnName,[row objectForColumnName:columnName]);
                }
            }

        } else {
            NSLog(@"Error => %@",result.errorMessage);
        }</pre>
UPDATE with PARAMETERS
<pre>        NSDictionary *params = @{
                                 @"id" : [NSNumber numberWithInt:3],
                                 @"is_active" : [NSNumber numberWithInt:9]
                                 };
        SQLiteResult *result = [SQLiteDatabase qout:@"UPDATE table SET is_active = :is_active WHERE id = :id " withParams:params];
        if(result.success) {
            NSLog(@"Done");
        } else {
            NSLog(@"Error => %@",result.errorMessage);
        }</pre>