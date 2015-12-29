//
//  RegisterViewController.m
//  ToDoList
//
//  Created by kbs on 27/07/15.
//  Copyright (c) 2015 kbs. All rights reserved.
//

#import "RegisterViewController.h"
#import "KeychainItemWrapper.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

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

- (IBAction)registerClicked:(id)sender {
    
    
     if([[self.txtFirstName text] isEqualToString:@""] || [[self.txtLastName text] isEqualToString:@""] || [[self.txtEmail text] isEqualToString:@""] || [[self.txtPassWord text] isEqualToString:@""] || [[self.txtRetypePassword text] isEqualToString:@""] ) {
         [self alertStatus:@"All fields are required" :@"Validation Error!" :0];
         return;
     }    
    else if(![self validateEmail:[self.txtEmail text]]) {
        [self alertStatus:@"Please enter a valid email" :@"Validation Error!" :0];
        return;
    }
    else if(![self.txtPassWord.text isEqualToString: self.txtRetypePassword.text]) {
        NSLog(@"self.txtPassWord.text: %@", self.txtPassWord.text);
        NSLog(@"self.txtRetypePassword.text %@", self.txtRetypePassword.text);
        [self alertStatus:@"Password and retype password must be same" :@"Validation Error!" :0];
        return;
    }
    else {
        // user entered valid email address
        
        
        @try {
            
            NSString *path = [[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist"];
            NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:path];
            NSString *GlobalURL= [[NSString alloc]initWithFormat:@"%@",[settings objectForKey:@"GlobalURL"]];
            NSString *URLRaw = [NSString stringWithFormat:@"%@/%@%@%@%@%@%@%@%@", GlobalURL, @"Common.svc/CreateUser?first_name=",self.txtFirstName.text, @"&last_name=", self.txtLastName.text ,@"&email=", self.txtEmail.text, @"&password=", self.txtPassWord.text];
            
            
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
                     
                     
                     
                     
                     [self alertStatus:@"User is created successfully!." :@"Success!" :0];
                     //[[ToDoListTableViewController alloc] manualLoad];
                     [self performSegueWithIdentifier:@"register_success" sender:self];
                 }
                 else
                 {
                     
                     [self alertStatus:@"Something went wrong! The user is not created." :@"Something went wrong!" :0];
                 }
             }];
        }
        @catch (NSException *exception) {
            [self alertStatus:@"Something went wrong! The user is not created." :@"Something went wrong!" :0];
        }
        @finally {
            
        }
       
        
    }
    
    
    
    
    
    
}

- (IBAction)cancelClicked:(id)sender {
    
    [self performSegueWithIdentifier:@"back_register_login" sender:self];
    
}

- (IBAction)backgroudTap:(id)sender {
    
           [self.view endEditing:YES];
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


- (BOOL)validateEmail:(NSString *)emailStr {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}

-(BOOL) textFieldShouldReturn:(UITextField*)textField;
{
    
    [textField resignFirstResponder];
    
    return YES;
}

@end
