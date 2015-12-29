//
//  LoginViewController.m
//  ToDoList
//
//  Created by kbs on 27/07/15.
//  Copyright (c) 2015 kbs. All rights reserved.
//

#import "LoginViewController.h"
#import "KeychainItemWrapper.h"


@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
   
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)signClicked:(id)sender { NSInteger success = 0;
    @try {
        
        if([[self.txtUser text] isEqualToString:@""] || [[self.txtPassword text] isEqualToString:@""] ) {
            
            [self alertStatus:@"Please enter Email and Password" :@"Sign in Failed!" :0];
            
        }
        
        else if(![self validateEmail:[self.txtUser text]]) {
            [self alertStatus:@"Please enter a valid email" :@"Validation Error!" :0];
            return;
        }
        
        else {
            
            NSString *path = [[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist"];
            NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:path];
            NSString *GlobalURL= [[NSString alloc]initWithFormat:@"%@",[settings objectForKey:@"GlobalURL"]];
            NSString *URLRaw =
            [NSString stringWithFormat:@"%@/%@%@%@%@%",GlobalURL, @"Common.svc/ValidateLogin?UserEmail=",self.txtUser.text,@"&Password=", self.txtPassword.text];
            
            
            URLRaw   =  [URLRaw stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
            
            NSURL *url = [NSURL URLWithString:URLRaw];
            
            
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [NSURLConnection sendAsynchronousRequest:request
                                               queue:[NSOperationQueue mainQueue]
                                   completionHandler:^(NSURLResponse *response,
                                                       NSData *data, NSError *connectionError)
             {
                 if (data.length > 0 && connectionError == nil)
                 {
                     
                     NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                     NSString *JsonDataString;
                     for (id object in jsonArray) {
                         // do something with object
                         JsonDataString = [jsonArray valueForKey:object];
                     }
                     NSData *data = [JsonDataString dataUsingEncoding:NSUTF8StringEncoding];
                     id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                     NSNumber *authFlag = [json objectForKey:@"IsAuthenticated"];
                     
                     if([authFlag boolValue]) {
                         NSLog(@"%@",[json objectForKey:@"Email"]);
                         KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"YourAppLogin" accessGroup:nil];
                         NSString *username = [keychainItem objectForKey:(__bridge id)(kSecAttrAccount)];
                         if(username.length > 0)
                         {
                             [keychainItem resetKeychainItem];
                         }
                         
                         
                         NSString *Email = [json objectForKey:@"Email"] ;
                         NSString *Password = [json objectForKey:@"Password"] ;
                         NSString *FFi_id = [json objectForKey:@"FFi_id"] ;
                         
                         [keychainItem setObject:Email forKey:(__bridge id)(kSecValueData)];
                         [keychainItem setObject:Password forKey:(__bridge id)(kSecAttrAccount)];
                         [keychainItem setObject:FFi_id forKey:(__bridge id)(kSecAttrDescription)];
                         
                         
                         
                         //NSString *username1 = [keychainItem objectForKey:(__bridge id)(kSecValueData)];
                         //NSString *password1 = [keychainItem objectForKey:(__bridge id)(kSecAttrAccount)];
                         //NSString *userid1 = [keychainItem objectForKey:(__bridge id)(kSecAttrDescription)];
                         
                         
                         //[[ToDoListTableViewController alloc] manualLoad];
                         [self performSegueWithIdentifier:@"login_success" sender:self];
                         
                     }
                     else
                     {
                         [self alertStatus:@"Email or password is not correct." :@"Something went wrong!" :0];
                     }                     
                    
                 }
                 else
                 {
                     
                     [self alertStatus:@"Something went wrong! The user is not created." :@"Something went wrong!" :0];
                 }
             }];
        }
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
        [self alertStatus:@"Sign in Failed." :@"Error!" :0];
    }
   
}
- (BOOL)validateEmail:(NSString *)emailStr {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
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


-(BOOL) textFieldShouldReturn:(UITextField*)textField;
{
   
   [textField resignFirstResponder];
    
    return YES;
}




- (IBAction)backgroundTap:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)registerClicked:(id)sender {
    [self performSegueWithIdentifier:@"registration_segue" sender:self];
}
@end

