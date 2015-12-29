//
//  AppDelegate.m
//  ToDoList
//
//  Created by kbs on 17/07/15.
//  Copyright (c) 2015 kbs. All rights reserved.
//

#import "AppDelegate.h"
#import "KeychainItemWrapper.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    @try {
        KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"YourAppLogin" accessGroup:nil];
        NSData *username = [keychainItem objectForKey:(__bridge id)(kSecValueData)];
        NSData *passwordStr = [keychainItem objectForKey:(__bridge id)(kSecAttrAccount)];
        NSData *userid = [keychainItem objectForKey:(__bridge id)(kSecAttrDescription)];
        
        NSString *usernameStr = [[NSString alloc] initWithBytes:[username bytes] length:[username length] encoding:NSUTF8StringEncoding];
        
        
        if(usernameStr.length > 0 )
        {
            if( passwordStr.length > 0 )
            {                
                if(userid > 0)
                {
                    UIViewController* rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"To-do-list"];
                    UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:rootController];
                    
                    self.window.rootViewController = navigation;
                }
            }
        }
        else
        {
            self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
        }
    }
    @catch (NSException *exception) {
         self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
    }
    @finally {
        //<#Code that gets executed whether or not an exception is thrown#>
    }    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
