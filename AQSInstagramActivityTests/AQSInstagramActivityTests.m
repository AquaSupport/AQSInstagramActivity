//
//  AQSInstagramActivityTests.m
//  AQSInstagramActivityTests
//
//  Created by kaiinui on 2014/11/08.
//  Copyright (c) 2014年 Aquamarine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock.h>

#import "AQSInstagramActivity.h"

@interface AQSInstagramActivity (Test) <UIDocumentInteractionControllerDelegate>

- (BOOL)isInstagramInstalled;
- (NSURL *)nilOrFileURLWithImageDataTemporary:(NSData *)data;
- (UIDocumentInteractionController *)documentInteractionControllerForInstagramWithFileURL:(NSURL *)URL withCaptionText:(NSString *)textOrNil;

@end

@interface AQSInstagramActivityTests : XCTestCase

@property AQSInstagramActivity *activity;

@end

@implementation AQSInstagramActivityTests

- (void)setUp {
    [super setUp];
    _activity = [[AQSInstagramActivity alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testItsActivityCategoryIsShare {
    XCTAssertTrue(AQSInstagramActivity.activityCategory == UIActivityCategoryShare);
}

- (void)testItReturnsItsImage {
    XCTAssertNotNil(_activity.activityImage);
}

- (void)testItReturnsItsType {
    XCTAssertTrue([_activity.activityType isEqualToString:@"org.openaquamarine.instagram"]);
}

- (void)testItReturnsItsTitle {
    XCTAssertTrue([_activity.activityTitle isEqualToString:@"Instagram"]);
}

- (void)testItCanPerformActivityWithImage {
    id activity = [OCMockObject partialMockForObject:_activity];
    OCMStub([activity isInstagramInstalled]).andReturn(YES);
    
    NSArray *activityItems = @[@"hoge", [UIImage imageNamed:@"test.jpg"]];
    XCTAssertTrue([activity canPerformWithActivityItems:activityItems]);
}

- (void)testItCannotPerformActivityWithoutImage {
    id activity = [OCMockObject partialMockForObject:_activity];
    OCMStub([activity isInstagramInstalled]).andReturn(YES);
    
    NSArray *activityItems = @[@"hoge", [NSURL URLWithString:@"http://google.com/"]];
    XCTAssertFalse([activity canPerformWithActivityItems:activityItems]);
}

- (void)testItCannotPerformActivityWithoutAppWithImage {
    id activity = [OCMockObject partialMockForObject:_activity];
    OCMStub([activity isInstagramInstalled]).andReturn(NO);
    
    NSArray *activityItems = @[@"hoge", [UIImage imageNamed:@"test.jpg"]];
    XCTAssertFalse([activity canPerformWithActivityItems:activityItems]);
}

- (void)testItCannotPerformActivityWithoutAppWithoutImage {
    id activity = [OCMockObject partialMockForObject:_activity];
    OCMStub([activity isInstagramInstalled]).andReturn(NO);
    
    NSArray *activityItems = @[@"hoge", [NSURL URLWithString:@"http://google.com/"]];
    XCTAssertFalse([activity canPerformWithActivityItems:activityItems]);
}

- (void)testItReturnsFileURLForWritingImageDataTemporary {
    NSData *data = UIImageJPEGRepresentation([UIImage imageNamed:@"test.jpg"], 0.9);
    XCTAssertNotNil([_activity nilOrFileURLWithImageDataTemporary:data]);
}

- (void)testItReturnsDocumentInteractionControllerForInstagramSharing {
    NSData *data = UIImageJPEGRepresentation([UIImage imageNamed:@"test.jpg"], 0.9);
    NSURL *URL = [_activity nilOrFileURLWithImageDataTemporary:data];
    
    UIDocumentInteractionController *controller = [_activity documentInteractionControllerForInstagramWithFileURL:URL withCaptionText:@"Whoa"];
    
    XCTAssertTrue([controller.UTI isEqualToString:@"com.instagram.exclusivegram"]);
    XCTAssertTrue([controller.annotation[@"InstagramCaption"] isEqualToString:@"Whoa"]);
    XCTAssertEqual(controller.URL, URL);
}

- (void)testItInvokeDidFinishWithYESWhenThePressedAppIsInstagram {
    id activity = [OCMockObject partialMockForObject:_activity];
    [[activity expect] activityDidFinish:YES];
    
    [activity documentInteractionController:nil willBeginSendingToApplication:@"com.burbn.instagram"];
    [activity documentInteractionControllerDidDismissOpenInMenu:nil];
    
    [activity verify];
}

- (void)testItInvokeDidFinishWithNOIfThePressedAppIsNotInstagram {
    id activity = [OCMockObject partialMockForObject:_activity];
    [[activity expect] activityDidFinish:NO];
    
    [activity documentInteractionController:nil willBeginSendingToApplication:@"com.example.app"];
    [activity documentInteractionControllerDidDismissOpenInMenu:nil];
    
    [activity verify];
}

- (void)testItInvokeDidFinishWithNOIfTheMenuDismissed {
    id activity = [OCMockObject partialMockForObject:_activity];
    [[activity expect] activityDidFinish:NO];
    
    [activity documentInteractionControllerDidDismissOpenInMenu:nil];
    
    [activity verify];
}

@end
