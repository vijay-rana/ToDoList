//
//  AddToDoItemViewController.m
//  ToDoList
//
//  Created by kbs on 17/07/15.
//  Copyright (c) 2015 kbs. All rights reserved.
//

#import "AddToDoItemViewController.h"
#import "ToDoListTableViewController.h"
#import "KeychainItemWrapper.h"
#import "Common.h"


@interface AddToDoItemViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textCreateEvent;
@property (weak, nonatomic) IBOutlet UITextField *textCost;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@end

@implementation AddToDoItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) textFieldShouldReturn:(UITextField*)textField;
{
    
    [textField resignFirstResponder];
    
    return YES;
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if (sender != self.saveButton) return;
    
    if([[self.textCreateEvent text] isEqualToString:@""] || [[self.textCost text] isEqualToString:@""]  ) {
        [self alertStatus:@"All fields are required" :@"Validation Error!" :0];
        return;
    }
    
    @try {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *startDate = [dateFormatter stringFromDate:self.Start.date];
        
        NSString *endDate = [dateFormatter stringFromDate:[self.Start.date dateByAddingTimeInterval:60]];
        
        
        KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"YourAppLogin" accessGroup:nil];
        
        
        NSString *Ffi_id = [keychainItem objectForKey:(__bridge id)(kSecAttrDescription)];
        //NSString *endDate;
        //[NSString endDate:@"%@/%@", startDate, @":01"];
        
        
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist"];
        NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:path];
        NSString *GlobalURL= [[NSString alloc]initWithFormat:@"%@",[settings objectForKey:@"GlobalURL"]];
        NSString *URLRaw = [NSString stringWithFormat:@"%@/%@%@%@%@%@%@%s%@", GlobalURL, @"Common.svc/SaveSchedule?scheduleId=0&start=" , startDate,  @"&end=",endDate, @"&recurrenceRuleText=&recid=0&dep_id=1&ffi_id=",Ffi_id,"&subject=", self.textCreateEvent.text, "&isTemSchedule=false&typeId=1&locId=1319120&posId=1&staionId=1&dayOfMonth=0&dayOrdinal=0&daysOfweek=None&endBy=9999-01-01T00:00&frequency=None&interval=0&maxOccurences=0&month=0&isSeriesEditing=false"];
        
        
        URLRaw   =  [URLRaw stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
        
        //NSArray *data = [[Common alloc] AppSynchronousRequestJSONArray:URLRaw];
        NSError *connectionError = nil;
        NSHTTPURLResponse *response = nil;
        NSURLRequest *request = [NSURLRequest
                                 requestWithURL:[NSURL URLWithString:URLRaw]
                                 cachePolicy:NSURLRequestReloadIgnoringCacheData
                                 timeoutInterval:5.0];
        NSData *data = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&connectionError];
        {
            if (data.length > 0 && connectionError == nil)
            {
                
                [[ToDoListTableViewController alloc] manualLoad];
            }
            else
            {
                [self alertStatus:@"Something went wrong! The event is not saved." :@"Error Message" :0];
               
            }
            
        };
    }
    @catch (NSException *exception) {
        [self alertStatus:@"Something went wrong! The event is not saved." :@"Error Message" :0];
    }
    @finally {
        
    }
   
    
      }


- (IBAction)backgroudTap:(id)sender {
    [self.view endEditing:YES];
}
@end
