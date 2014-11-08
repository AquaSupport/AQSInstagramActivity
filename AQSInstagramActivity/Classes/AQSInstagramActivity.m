//
//  AQSInstagramActivity.m
//  AQSInstagramActivity
//
//  Created by kaiinui on 2014/11/08.
//  Copyright (c) 2014年 Aquamarine. All rights reserved.
//

#import "AQSInstagramActivity.h"

NSString *const kAQSInstagramURLScheme = @"instagram://app";

@interface AQSInstagramActivity () <UIDocumentInteractionControllerDelegate>

@property (nonatomic, strong) NSArray *activityItems;
@property (nonatomic, strong) UIDocumentInteractionController *controller;
@property (nonatomic, assign) BOOL isPerformed;

@end

@implementation AQSInstagramActivity

- (void)prepareWithActivityItems:(NSArray *)activityItems {
    [super prepareWithActivityItems:activityItems];
    
    self.activityItems = activityItems;
}

+ (UIActivityCategory)activityCategory {
    return UIActivityCategoryShare;
}

- (NSString *)activityType {
    return @"org.openaquamarine.instagram";
}

- (NSString *)activityTitle {
    return @"Instagram";
}

- (UIImage *)activityImage {
    if ([[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue] >= 8) {
        return [UIImage imageNamed:[NSString stringWithFormat:@"color_%@", NSStringFromClass([self class])]];
    } else {
        return [UIImage imageNamed:NSStringFromClass([self class])];
    }
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    return [self isInstagramInstalled] && [self nilOrFirstImageFromArray:activityItems] != nil;
}

- (void)performActivity {
    NSString *text = [self firstStringOrEmptyStringFromArray:_activityItems];
    UIImage *image = [self nilOrFirstImageFromArray:_activityItems];
    NSURL *URL = [self nilOrFileURLWithImageDataTemporary:UIImageJPEGRepresentation(image, 0.9)];
    self.controller = [self documentInteractionControllerForInstagramWithFileURL:URL withCaptionText:text];
    
    UIView *currentView = [self currentView];
    [self.controller presentOpenInMenuFromRect:CGRectMake(0, 0, currentView.bounds.size.width, currentView.bounds.size.width) inView:currentView animated:YES];
}

# pragma mark - Helpers (Instagram)

- (BOOL)isInstagramInstalled {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:kAQSInstagramURLScheme]];
}

# pragma mark - Helpers (UIDocumentInteractionController)

- (NSURL *)nilOrFileURLWithImageDataTemporary:(NSData *)data {
    NSString *writePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"instagram.igo"];
    if (![data writeToFile:writePath atomically:YES]) {
        [self activityDidFinish:NO];
        return nil;
    }
    
    return [NSURL fileURLWithPath:writePath];
}

- (UIDocumentInteractionController *)documentInteractionControllerForInstagramWithFileURL:(NSURL *)URL withCaptionText:(NSString *)textOrNil {
    UIDocumentInteractionController *controller = [UIDocumentInteractionController interactionControllerWithURL:URL];
    [controller setUTI:@"com.instagram.exclusivegram"];
    if (textOrNil == nil) {
        textOrNil = @"";
    }
    controller.delegate = self;
    [controller setAnnotation:@{
                                @"InstagramCaption": textOrNil
                                }];
    return controller;
}

# pragma mark - Helpers (View)

- (UIView *)currentView {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    return window.rootViewController.view;
}

# pragma mark - Helpers (UIActivity)

- (NSString *)firstStringOrEmptyStringFromArray:(NSArray *)array {
    for (id item in array) {
        if ([item isKindOfClass:[NSString class]]) {
            return item;
        }
    }
    return @"";
}

- (UIImage *)nilOrFirstImageFromArray:(NSArray *)array {
    for (id item in array) {
        if ([item isKindOfClass:[UIImage class]]) {
            return item;
        }
    }
    return nil;
}

# pragma mark - UIDocumentInteractionControllerDelegate

- (void)documentInteractionController:(UIDocumentInteractionController *)controller willBeginSendingToApplication:(NSString *)application {
    if ([application isEqualToString:@"com.burbn.instagram"]) {
        self.isPerformed = YES;
    }
}

- (void)documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController *)controller {
    [self activityDidFinish:self.isPerformed];
}

@end
