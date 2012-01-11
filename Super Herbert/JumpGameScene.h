//
//  JumpGameScene.h
//  Super Herbert
//
//  Created by Philip Brechler on 09.01.12.
//  Copyright 2012 Hoccer GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface JumpGameScene : CCLayer <UIAccelerometerDelegate>{
    CGPoint herbert_pos;
	ccVertex2F herbert_vel;
	ccVertex2F herbert_acc;
    
    float currentPlatformY;
	int currentPlatformTag;
	float currentMaxPlatformStep;
	int currentBonusPlatformIndex;
	int currentBonusType;
	int platformCount;
    
    BOOL gameSuspended;
    BOOL herbertLookingRight;
    
    CCSprite *herbert;
    CCAction *herbertFlying;
    CCLabelTTF *scoreLabel;
    
    UIAccelerometer *accelerometer;
    
    int score;
    int highScore;
    int hight;
    int bestHight;
}

@property (nonatomic, retain) CCSprite *herbert;
@property (nonatomic, retain) CCAction *herbertFlying;

@property (nonatomic, retain) UIAccelerometer *accelerometer;

+(id)scene;

- (void)initPlatforms;
- (void)initPlatform;
- (void)resetPlatforms;
- (void)resetPlatform;
- (void)resetHerbert;
- (void)resetBonus;
- (void)step:(ccTime)dt;

- (void)playEffect:(NSString *)sound;
- (void)jump;
- (void)gameOver;
@end
