//
//  AddToDoItemViewController.h
//  ToDoList
//
//  Created by kbs on 17/07/15.
//  Copyright (c) 2015 kbs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToDoItem.h"

@interface AddToDoItemViewController : UIViewController <UITextFieldDelegate>
@property ToDoItem *toDoItem;

- (IBAction)backgroudTap:(id)sender;
@property (weak, nonatomic) IBOutlet UIDatePicker *Start;

@end
