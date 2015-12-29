//
//  RegisterViewController.h
//  ToDoList
//
//  Created by kbs on 27/07/15.
//  Copyright (c) 2015 kbs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassWord;
@property (weak, nonatomic) IBOutlet UITextField *txtRetypePassword;
- (IBAction)registerClicked:(id)sender;

- (IBAction)cancelClicked:(id)sender;


- (IBAction)backgroudTap:(id)sender;


@end
