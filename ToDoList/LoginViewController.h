//
//  LoginViewController.h
//  ToDoList
//
//  Created by kbs on 27/07/15.
//  Copyright (c) 2015 kbs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtUser;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

- (IBAction)signClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *backgroundTap;
- (IBAction)backgroundTap:(id)sender;
- (IBAction)registerClicked:(id)sender;

@end
