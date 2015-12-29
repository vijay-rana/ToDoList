//
//  ToDoListTableViewController.m
//  ToDoList
//
//  Created b y kbs on 17/07/15.
//  Copyright (c) 2015 kbs. All rights reserved.
//

#import "ToDoListTableViewController.h"
#import "ToDoItem.h"
#import "AddToDoItemViewController.h"
#import "Common.h"
#import "KeychainItemWrapper.h"

@interface ToDoListTableViewController ()

@property NSMutableArray *toDoItems;

@end

@implementation ToDoListTableViewController



- (IBAction)unwindToList:(UIStoryboardSegue *)segue {
   
    [self viewDidLoad];
    
    // Returning from the child view
    
}

- (IBAction)signoutClicked:(id)sender {
    @try
    {
        KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"YourAppLogin" accessGroup:nil];
        [keychainItem resetKeychainItem];
        [self performSegueWithIdentifier:@"signout_Segue" sender:self];
    }
    
    @catch (NSException *ex) {
        [self alertStatus:@"Something went wrong! Please try again." :@"Something went wrong!" :0];
        
    }
    
    
}

- (void)viewDidLoad {
    @try {
        [super viewDidLoad];
        self.toDoItems = [[NSMutableArray alloc] init];
        [self loadInitialData];
        [self.tableView reloadData];    }
    @catch (NSException *ex) {
        [self alertStatus:@"Something went wrong! Please try again." :@"Something went wrong!" :0];
        
    }
    
}


- (void)manualLoad {
    @try {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success Message"
                                                        message:@"Information save successfully!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        [super viewDidLoad];
        self.toDoItems = [[NSMutableArray alloc] init];
        [self loadInitialData];
        [self.tableView reloadData];
    }
    @catch (NSException *exception) {
         [self alertStatus:@"Something went wrong! Please try again." :@"Something went wrong!" :0];
    }
    @finally {
        
    }
    
}


- (void)loadInitialData {
    
    @try {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist"];
        NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:path];
        NSString *GlobalURL= [[NSString alloc]initWithFormat:@"%@",[settings objectForKey:@"GlobalURL"]];
        KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"YourAppLogin" accessGroup:nil];
        
        NSString *Ffi_id = [keychainItem objectForKey:(__bridge id)(kSecAttrDescription)];
        
        
        //current year, month
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MM"];
        NSString *myMonthString = [df stringFromDate:[NSDate date]];
        
        [df setDateFormat:@"yyyy"];
        NSString *myYearString = [df stringFromDate:[NSDate date]];
        NSString *URLRaw = [NSString stringWithFormat:@"%@/%@%@%s%@%@%@", GlobalURL, @"Common.svc/ListDataForMobileScheduler?dep_Id=1&ffi_id=",Ffi_id,"&month=" , myMonthString, @"&year=",myYearString];
        
        NSArray *data = [[Common alloc] AppSynchronousRequestJSONArray:URLRaw];
        
        
        
        
        NSString *myArrayString = [data description];
        
        NSData *data2 = [myArrayString dataUsingEncoding:NSUTF8StringEncoding];
        
        NSArray *ArrayData = [NSJSONSerialization JSONObjectWithData:data2 options:0 error:nil];
        
        for (NSDictionary *MobileScheduleDTO in ArrayData) {
            NSString *message= [[NSString alloc]initWithFormat:@"%@",[MobileScheduleDTO objectForKey:@"Subject"]];
            NSString *Isactive =[[NSString alloc]initWithFormat:@"%@",[MobileScheduleDTO objectForKey:@"Isactive"]];
            ToDoItem *item4 = [[ToDoItem alloc] init];
            item4.itemName = message;
            if([Isactive isEqualToString:@"0"])
            {
                item4.completed = true;
            }
            [self.toDoItems addObject:item4];
            
        }
    }
    @catch (NSException *exception) {
        [self alertStatus:@"Something went wrong! Please try again." :@"Something went wrong!" :0];
    }
    @finally {
        
    }
    
        
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListPrototypeCell" forIndexPath:indexPath];
    
    // Configure the cell...
    ToDoItem *toDoItem = [self.toDoItems objectAtIndex:indexPath.row];
    cell.textLabel.text = toDoItem.itemName;
    
    if (toDoItem.completed) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {    // Return the number of rows in the section.
    return [self.toDoItems count];
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ToDoItem *tappedItem = [self.toDoItems objectAtIndex:indexPath.row];
    tappedItem.completed = !tappedItem.completed;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void) alertStatus:(NSString *)msg :(NSString *)title :(int) tag
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
    alertView.tag = tag;
    [alertView show];
}

@end
