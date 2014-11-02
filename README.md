SQLiteDatabase class for iOS Objective-C , sqlite3 .

Features :
  
  Dynamic named parameter binding ( does not support parameter with only ? mark , you must provide parameter name as in examples )



Usage :

you must add "sqlite3 framework" to your project, 

you should already have a sqlite database file , you can create your database with several tools : [https://addons.mozilla.org/en-US/firefox/addon/sqlite-manager/](https://addons.mozilla.org/en-US/firefox/addon/sqlite-manager/), [http://sourceforge.net/projects/sqlitebrowser/](http://sourceforge.net/projects/sqlitebrowser/) , [http://www.sqliteexpert.com/](http://www.sqliteexpert.com/) , [http://www.razorsql.com/features/sqlite_table_editor.html](http://www.razorsql.com/features/sqlite_table_editor.html) .

if you already have one , open SQLiteDatabase.h and change @"database_file.sqlite" to your file name
```objective-c
#define DATABASE_FILE_NAME @"database_file.sqlite"
```
add 
```objective-c
#import "SQLiteDatabase.h"
``` 
to your class/file

SQLiteDatabase has 2 main methods ,

one for select (executeQuery:withParams) ,

second for update/delete/insert (executeUpdate:withParams) ,

both of them execute asynchronously , function takes **success** and **failure** bloks , if query succeeds , it will invoce *success* block and pass **SQLiteResult** object to it , otherwise *failure* block will be invoked and **errorMessage** will be passed to it ,

**executeQuery** has higher queue priority than executeUpdate .

Examples :

SELECT without parameters
```objective-c
NSString *query = @"SELECT id,name,image FROM TABLE_NAME ORDER BY name ASC";
[[SQLiteDatabase sharedInstance] executeQuery:query
                                   withParams:nil
                                      success:^(SQLiteResult *result) {
                                          NSLog(@"Result count %d",result.count);
                                          
                                          for(SQLiteRow *row in result) {
                                              for(NSString *columnName in row.columnNames) {
                                                  NSLog(@"%@ => %@",columnName,[row objectForColumnName:columnName]);
                                              }
                                          }
                                      }
                                      failure:^(NSString *errorMessage) {
                                          NSLog(@"Query failed with error - %@",errorMessage);
                                     }];
``` 


SELECT with parameters
```objective-c
NSString *query = @"SELECT id,name,image FROM TABLE_NAME WHERE id = :id";
NSDictionary *params = @{ @"id" : @(155) };
[[SQLiteDatabase sharedInstance] executeQuery:query
                                   withParams:params
                                      success:^(SQLiteResult *result) {
                                          NSLog(@"Result count %d",result.count);
                                          
                                          for(SQLiteRow *row in result) {
                                              for(NSString *columnName in row.columnNames) {
                                                  NSLog(@"%@ => %@",columnName,[row objectForColumnName:columnName]);
                                              }
                                          }
                                      }
                                      failure:^(NSString *errorMessage) {
                                          NSLog(@"Query failed with error - %@",errorMessage);
                                      }];
```         
        
        
UPDATE with PARAMETERS
```objective-c
NSString *updateQuery = @"UPDATE TABLE_NAME set name = :name where id = :id";
NSDictionary *updateParams = @{ @"id" : @(155)  };
[[SQLiteDatabase sharedInstance] executeUpdate:updateQuery
                                    withParams:updateParams
                                       success:^(SQLiteResult *result) {
                                           NSLog(@"success");
                                       }
                                       failure:^(NSString *errorMessage) {
                                           NSLog(@"Update Query failed with error - %@",errorMessage);
                                       }];
```            