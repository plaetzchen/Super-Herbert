//
//  HelloWorldLayer.h
//  Super Herbert
//
//  Created by Philip Brechler on 09.01.12.
//   CC-BY-SA Philip Brechler & Peter Amende 2012  
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
