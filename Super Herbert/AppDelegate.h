//
//  AppDelegate.h
//  Super Herbert
//
//  Created by Philip Brechler on 09.01.12.
//  CC-BY-SA Philip Brechler & Peter Amende 2012  
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
