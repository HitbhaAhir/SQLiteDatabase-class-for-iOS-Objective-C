//
//  ViewController.m
//  SQLiteExample
//
//  Created by Sergo Beruashvili on 10/5/15.
//  Copyright © 2015 ogres. All rights reserved.
//

#import "ViewController.h"
#import "SQLiteDatabase.h"

@interface ViewController () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textFieldName;
@property (weak, nonatomic) IBOutlet UIButton *buttonInsert;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSMutableArray *tableViewData;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Setup database and set it as shared
    [[SQLiteDatabase databaseWithFileName:@"test"] setAsSharedInstance];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *sqliteDB = [documentsDirectory stringByAppendingPathComponent:@"test.sqlite"];
    NSLog(@"File location %@",sqliteDB);
    
    [self refreshData];
}


- (IBAction)actionInsert:(id)sender {
    if(self.textFieldName.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter name" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        return;
    }
    
    // Id will be auto-incremented
    NSString *query = @"INSERT INTO test_table (name) VALUES (:name)";
    [[SQLiteDatabase sharedInstance] executeUpdate:query withParams:@{@"name" : self.textFieldName.text } success:^(SQLiteResult *result) {
        [self refreshData];
    } failure:^(NSString *errorMessage) {
        NSLog(@"Could not insert new row , %@",errorMessage);
    }];
    NSLog(@"Query %@ , with params %@",query,@{@"name" : self.textFieldName.text });
}

- (void)refreshData {
    NSString *query = @"SELECT id,name FROM test_table ORDER BY id DESC";
    [[SQLiteDatabase sharedInstance] executeQuery:query withParams:nil success:^(SQLiteResult *result) {
        self.tableViewData = result.rows;
        [self.tableView reloadData];
    } failure:^(NSString *errorMessage) {
        NSLog(@"Could not fetch rows , %@",errorMessage);
    }];
    NSLog(@"Query %@ ",query);
}

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableViewData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    SQLiteRow *object = self.tableViewData[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"Name - %@",[object stringForColumnName:@"name"]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"ID - %@",[object numberForColumnName:@"id"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        SQLiteRow *object = self.tableViewData[indexPath.row];
        NSString *query = @"DELETE FROM test_table WHERE id = :id";
        [[SQLiteDatabase sharedInstance] executeUpdate:query withParams:@{@"id" : [object numberForColumnName:@"id"] } success:^(SQLiteResult *result) {
            NSLog(@"Object was deleted");
            [self refreshData];
        } failure:^(NSString *errorMessage) {
            NSLog(@"Could not delete because of %@",errorMessage);
        }];
        NSLog(@"Query %@ , with params %@",query,@{@"id" : [object numberForColumnName:@"id"] });
    }
}

@end
