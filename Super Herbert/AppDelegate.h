//
//  AppDelegate.h
//  Super Herbert
//
//  Created by Philip Brechler on 09.01.12.
//  Copyright Hoccer GmbH 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
