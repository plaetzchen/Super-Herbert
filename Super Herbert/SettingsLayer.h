//
//  SettingsLayer.h
//  Super Herbert
//
//  Created by Philip Brechler on 10.01.12.
//  Copyright 2012 Hoccer GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "HelloWorldLayer.h"

@interface SettingsLayer : CCLayer {
    CCMenuItemToggle *musicSwitch;
    CCMenuItemToggle *effectSwitch;
}

+(id)scene;

- (void)updateSwitches;

@end
