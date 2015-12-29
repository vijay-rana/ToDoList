//
//  ToDoItem.h
//  ToDoList
//
//  Created by kbs on 17/07/15.
//  Copyright (c) 2015 kbs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToDoItem : NSObject
@property NSString *itemName;
@property BOOL completed;
@property(readonly) NSDate *creationDate;

@end
