//
//  MainViewController.m
//  TextAttachmentDemo
//
//  Created by isee15 on 15/4/14.
//  Copyright (c) 2015年 isee15. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()
@property(unsafe_unretained) IBOutlet NSTextView *textView;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do view setup here.
    self.textView.string = @"text";
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *path = [resourcePath stringByAppendingPathComponent:@"in.gif"];
    NSFileWrapper *fileWrapper = [[NSFileWrapper alloc] initRegularFileWithContents:[NSData dataWithContentsOfFile:path]];
    [fileWrapper setPreferredFilename:[path lastPathComponent]];

    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] initWithFileWrapper:fileWrapper];
    NSAttributedString *fileAttString = [NSAttributedString attributedStringWithAttachment:textAttachment];
    [self.textView insertText:fileAttString];

    textAttachment = [[NSTextAttachment alloc] initWithFileWrapper:fileWrapper];
    fileAttString = [NSAttributedString attributedStringWithAttachment:textAttachment];
    [self.textView insertText:fileAttString];
    [self.textView insertNewline:nil];
    [self.textView deleteBackward:nil];
    [self.textView scrollRangeToVisible:NSMakeRange(self.textView.string.length, 0)];
}

@end
