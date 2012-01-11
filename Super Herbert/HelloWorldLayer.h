//
//  HelloWorldLayer.h
//  Super Herbert
//
//  Created by Philip Brechler on 09.01.12.
//  Copyright Hoccer GmbH 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "JumpGameScene.h"
#import "SettingsLayer.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
    NSMutableArray *clouds;
    
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

- (void) addClouds;
- (void) moveClouds:(ccTime)dt;

@end
