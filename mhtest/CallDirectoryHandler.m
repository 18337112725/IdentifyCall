//
//  CallDirectoryHandler.m
//  mhtest
//
//  Created by 王梦辉 on 2016/12/27.
//  Copyright © 2016年 王梦辉. All rights reserved.
//

#import "CallDirectoryHandler.h"

@interface CallDirectoryHandler () <CXCallDirectoryExtensionContextDelegate>
@end

@implementation CallDirectoryHandler

- (void)beginRequestWithExtensionContext:(CXCallDirectoryExtensionContext *)context {
    context.delegate = self;

    if (![self addBlockingPhoneNumbersToContext:context]) {
        NSLog(@"Unable to add blocking phone numbers");
        NSError *error = [NSError errorWithDomain:@"CallDirectoryHandler" code:1 userInfo:nil];
        [context cancelRequestWithError:error];
        return;
    }
    
    if (![self addIdentificationPhoneNumbersToContext:context]) {
        NSLog(@"Unable to add identification phone numbers");
        NSError *error = [NSError errorWithDomain:@"CallDirectoryHandler" code:2 userInfo:nil];
        [context cancelRequestWithError:error];
        return;
    }
    
    [context completeRequestWithCompletionHandler:nil];
}

- (BOOL)addBlockingPhoneNumbersToContext:(CXCallDirectoryExtensionContext *)context {
    // Retrieve phone numbers to block from data store. For optimal performance and memory usage when there are many phone numbers,
    // consider only loading a subset of numbers at a given time and using autorelease pool(s) to release objects allocated during each batch of numbers which are loaded.
    //
    // Numbers must be provided in numerically ascending order.
    CXCallDirectoryPhoneNumber phoneNumbers[] = { 8613800138000, 8618665710271 };
    NSUInteger count = (sizeof(phoneNumbers) / sizeof(CXCallDirectoryPhoneNumber));

    for (NSUInteger index = 0; index < count; index += 1) {
        CXCallDirectoryPhoneNumber phoneNumber = phoneNumbers[index];
        [context addBlockingEntryWithNextSequentialPhoneNumber:phoneNumber];
    }

    return YES;
}

- (BOOL)addIdentificationPhoneNumbersToContext:(CXCallDirectoryExtensionContext *)context {
    // Retrieve phone numbers to identify and their identification labels from data store. For optimal performance and memory usage when there are many phone numbers,
    // consider only loading a subset of numbers at a given time and using autorelease pool(s) to release objects allocated during each batch of numbers which are loaded.
    //
    // Numbers must be provided in numerically ascending order.
    NSDictionary *peopledic = [[[NSUserDefaults alloc] initWithSuiteName:@"group.com.mh.calltest.w"] valueForKey:@"phone"];
    
    NSArray *phone = [[peopledic allKeys]  sortedArrayUsingSelector:@selector(compare:)];
    for (NSInteger i = 0 ;i <phone.count; i++) {
        CXCallDirectoryPhoneNumber phoneNumber = [phone[i] integerValue];
        NSString *name  = [peopledic objectForKey:phone[i]];
        [context addIdentificationEntryWithNextSequentialPhoneNumber:phoneNumber label:name];
    }
    return YES;
}

#pragma mark - CXCallDirectoryExtensionContextDelegate

- (void)requestFailedForExtensionContext:(CXCallDirectoryExtensionContext *)extensionContext withError:(NSError *)error {
    // An error occurred while adding blocking or identification entries, check the NSError for details.
    // For Call Directory error codes, see the CXErrorCodeCallDirectoryManagerError enum in <CallKit/CXError.h>.
    //
    // This may be used to store the error details in a location accessible by the extension's containing app, so that the
    // app may be notified about errors which occured while loading data even if the request to load data was initiated by
    // the user in Settings instead of via the app itself.
}

@end
