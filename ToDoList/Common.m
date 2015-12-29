//
//  Common.m
//  ToDoList
//
//  Created by kbs on 21/07/15.
//  Copyright (c) 2015 kbs. All rights reserved.
//

#import "Common.h"
#import "XMLReader.h"

@implementation Common




- (NSArray *)AppSynchronousRequestJSONArray:(NSString *)URL
{
    // We're not doing an explicit alloc/init here, so...
    __block NSArray *ArrayData= nil;
    
    if (URL.length > 0) {
        NSError *connectionError = nil;
        NSHTTPURLResponse *response = nil;
        NSURLRequest *request = [NSURLRequest
                                 requestWithURL:[NSURL URLWithString:URL]
                                 cachePolicy:NSURLRequestReloadIgnoringCacheData
                                 timeoutInterval:5.0];
        NSData *data = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&connectionError];
        {
            if (data.length > 0 && connectionError == nil)
            {
                NSDictionary *DictionaryData = [NSJSONSerialization JSONObjectWithData:data
                                                                               options:0
                                                                                 error:NULL];
                ArrayData = [DictionaryData objectForKey:@"d"] ;
            }
        };
    }
    return ArrayData;
}

- (NSArray *)AppSynchronousRequestXMLArray:(NSString *)URL
{
    // We're not doing an explicit alloc/init here, so...
    __block NSArray *ArrayData= nil;
    
    if (URL.length > 0) {
        NSError *connectionError = nil;
        NSHTTPURLResponse *response = nil;
        NSURLRequest *request = [NSURLRequest
                                 requestWithURL:[NSURL URLWithString:URL]
                                 cachePolicy:NSURLRequestReloadIgnoringCacheData
                                 timeoutInterval:5.0];
        NSData *data = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&connectionError];
        {
            if (data.length > 0 && connectionError == nil)
            {
                
                //NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                NSError *error = nil;
                NSDictionary *DictionaryData = [XMLReader dictionaryForXMLData:data
                                                             options:XMLReaderOptionsProcessNamespaces
                                                               error:&error];              
                
                
                ArrayData =  [DictionaryData allValues];
                
           }
        };
    }
    return ArrayData;
}


@end
