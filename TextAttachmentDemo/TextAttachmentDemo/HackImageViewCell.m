//
//  HackImageViewCell.m
//  TextAttachmentDemo
//
//  Created by isee15 on 15/4/14.
//  Copyright (c) 2015年 isee15. All rights reserved.
//

#import "HackImageViewCell.h"
#import <objc/runtime.h>
#import <Cocoa/Cocoa.h>

static char charIndexKey;

@implementation HackImageViewCell
+ (void)hackNSImageViewTextAttachmentCell
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class imgAttachClass = NSClassFromString(@"NSImageViewTextAttachmentCell");
        SEL drawSel = NSSelectorFromString(@"drawWithFrame2:inView:characterIndex:");
        SEL drawSelOrigin = NSSelectorFromString(@"drawWithFrame:inView:characterIndex:");

        SEL drawLayoutSel = NSSelectorFromString(@"drawWithFrame2:inView:characterIndex:layoutManager:");
        SEL drawLayoutSelOrigin = NSSelectorFromString(@"drawWithFrame:inView:characterIndex:layoutManager:");

        SEL trackSel = NSSelectorFromString(@"trackMouse2:inRect:ofView:untilMouseUp:");
        SEL trackSelOrigin = NSSelectorFromString(@"trackMouse:inRect:ofView:untilMouseUp:");

        IMP drawIMP = imp_implementationWithBlock(^(id innerSelf, NSRect cellFrame, NSView *controlView,
                NSUInteger charIndex) {
            IMP imp2 = [innerSelf methodForSelector:drawSel];
            ((void (*)(id, SEL, NSRect, NSView *, NSUInteger)) imp2)(innerSelf, drawSel, cellFrame, controlView, charIndex);
            objc_setAssociatedObject(innerSelf, &charIndexKey, @(charIndex), OBJC_ASSOCIATION_COPY);
        });
        IMP drawLayoutIMP = imp_implementationWithBlock(^(id innerSelf, NSRect cellFrame, NSView *controlView,
                NSUInteger charIndex, NSLayoutManager *layoutManager) {
            IMP imp2 = [innerSelf methodForSelector:drawLayoutSel];
            ((void (*)(id, SEL, NSRect, NSView *, NSUInteger, NSLayoutManager *)) imp2)(innerSelf, drawLayoutSel, cellFrame, controlView, charIndex, layoutManager);
            objc_setAssociatedObject(innerSelf, &charIndexKey, @(charIndex), OBJC_ASSOCIATION_COPY);
            if ([controlView isKindOfClass:[NSTextView class]]) {
                NSRange theRange = [[layoutManager firstTextView] selectedRange];
                //	here we draw a highlighted border around the image cell to indicate selection
                if ((charIndex >= theRange.location && theRange.length == 1 && charIndex < theRange.location + theRange.length && theRange.length > 0)) {
                    [[NSColor blackColor] set];
                    NSFrameRectWithWidth(cellFrame, 1);
                }
            }
        });

        IMP trackIMP = imp_implementationWithBlock(^(id innerSelf, NSEvent *theEvent, NSRect cellFrame,
                NSView *aTextView, BOOL flag) {
            if ([aTextView isKindOfClass:[NSTextView class]]) {
                NSNumber *charIndex = objc_getAssociatedObject(innerSelf, &charIndexKey);
                if ([charIndex longLongValue] >= 0 && [charIndex longLongValue] < ((NSTextView *) aTextView).string.length)
                    [(NSTextView *) aTextView setSelectedRange:NSMakeRange([charIndex longLongValue], 1)];
            }
            IMP imp2 = [innerSelf methodForSelector:trackSel];
            return ((BOOL (*)(id, SEL, NSEvent *, NSRect, NSView *, BOOL)) imp2)(innerSelf, trackSel, theEvent, cellFrame, aTextView, flag);
        });

        //replace drawWithFrame:inView:characterIndex:
        class_addMethod(imgAttachClass, drawSel, drawIMP, "v@:{CGRect={CGPoint=dd}{CGSize=dd}}@Q");
        method_exchangeImplementations(class_getInstanceMethod(imgAttachClass, drawSel), class_getInstanceMethod(imgAttachClass, drawSelOrigin));

        //replace drawWithFrame:inView:characterIndex:layoutManager:
        class_addMethod(imgAttachClass, drawLayoutSel, drawLayoutIMP, "v@:{CGRect={CGPoint=dd}{CGSize=dd}}@Q@");
        method_exchangeImplementations(class_getInstanceMethod(imgAttachClass, drawLayoutSel), class_getInstanceMethod(imgAttachClass, drawLayoutSelOrigin));

        //replace trackMouse:inRect:ofView:untilMouseUp:
        class_addMethod(imgAttachClass, trackSel, trackIMP, "c@:@{CGRect={CGPoint=dd}{CGSize=dd}}@c");
        method_exchangeImplementations(class_getInstanceMethod(imgAttachClass, trackSel), class_getInstanceMethod(imgAttachClass, trackSelOrigin));

    });

}
@end
