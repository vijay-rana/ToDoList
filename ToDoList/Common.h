//
//  Common.h
//  ToDoList
//
//  Created by kbs on 21/07/15.
//  Copyright (c) 2015 kbs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Common : NSObject
- (NSArray *)AppSynchronousRequestXMLArray:(NSString *)URL;
- (NSArray *)AppSynchronousRequestJSONArray:(NSString *)URL;
@property NSString *GlobalCloudURL;
@end
