//
//  AppDelegate.m
//  TextAttachmentDemo
//
//  Created by isee15 on 15/4/14.
//  Copyright (c) 2015年 isee15. All rights reserved.
//

#import "AppDelegate.h"
#import "HackImageViewCell.h"

@interface AppDelegate ()

@property(weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [HackImageViewCell hackNSImageViewTextAttachmentCell];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    // Insert code here to tear down your application
}

@end
