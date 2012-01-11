//
//  JumpGameScene.m
//  Super Herbert
//
//  Created by Philip Brechler on 09.01.12.
//  Copyright 2012 Hoccer GmbH. All rights reserved.
//

#import "JumpGameScene.h"
#import "HighscoreLayer.h"
#import "SimpleAudioEngine.h"

#define kPlatformStartTag 200
#define kBonusStartTag 300

#define kPlatformNumber 25
#define kMinPlatformStep	50
#define kMaxPlatformStep	320
#define kPlatformTopPadding 5

#define kMinBonusStep		30
#define kMaxBonusStep		50
#define kHerbertTag 4

enum {
kBonus5 = 0,
kBonus10,
kBonus50,
kBonus100,
kNumBonuses
};

@implementation JumpGameScene

@synthesize accelerometer,herbert,herbertFlying;
+(id)scene {
    CCScene *scene = [CCScene node];
    
    JumpGameScene *layer = [JumpGameScene node];
    
    [scene addChild:layer];
    
    return scene;
}

- (id)init {
    if( (self= [super init])) {
        gameSuspended = YES;
        CCSprite *background = [CCSprite spriteWithFile:@"background.png" rect:CGRectMake(0, 0, 320, 480)];
        
        background.position = CGPointMake(160, 240); 
        
        [self addChild:background z:0];
        
        [self initPlatforms];
        
        scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",score] dimensions:CGSizeMake(300, 50) alignment:UITextAlignmentRight fontName:@"Arial" fontSize:22.0];
        scoreLabel.position = ccp(150,440);
        
        [self addChild:scoreLabel z:4];
        
        for(int i=0; i<kNumBonuses; i++) {
            CCSprite *bonus = [CCSprite spriteWithFile:@"coin.png"];
            [self addChild:bonus z:2 tag:kBonusStartTag+i];
            bonus.visible = NO;
        }
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"dude-anim_default.plist"];
        
        CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"dude-anim_default.png"];
        
        [self addChild:spriteSheet z:3 tag:kHerbertTag];
        
        NSMutableArray *flyAnimFrames = [NSMutableArray array];
        
        for (int i = 1; i <= 4; i++) {
            [flyAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"herbert%d.png", i]]];
        }
        
        CCAnimation *flyAnim = [CCAnimation animationWithFrames:flyAnimFrames delay:0.1f];
        
        self.herbert = [CCSprite spriteWithSpriteFrameName:@"herbert1.png"];
        
        self.herbertFlying = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:flyAnim restoreOriginalFrame:NO]];
        [self.herbert runAction:self.herbertFlying];
        [spriteSheet addChild:self.herbert];
        
        CCSprite *highScoreLabel = [CCSprite spriteWithFile:@"highscore.png"];
        highScoreLabel.position = ccp(250,470);
        highScoreLabel.visible = NO;
        [self addChild:highScoreLabel z:2 tag:999];
        
        [self resetPlatforms];
        [self resetHerbert];
        [self resetBonus];
        [self schedule:@selector(step:)];
        
        self.accelerometer = [UIAccelerometer sharedAccelerometer];
        [self.accelerometer setUpdateInterval:(1.0 / 60)];
        self.accelerometer.delegate = self;
        
        gameSuspended = NO;
        
        //highScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"highScore"];
        
        bestHight = [[NSUserDefaults standardUserDefaults]integerForKey:@"bestHight"];
        
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"musicStatus"] == 0) {
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"background.mp3" loop:YES];
        }
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        

    }
    return self;
}

- (void)initPlatforms {
    currentPlatformTag = kPlatformStartTag;
    while (currentPlatformTag < kPlatformStartTag + kPlatformNumber){
        [self initPlatform];
        currentPlatformTag++;
    }
}

- (void)initPlatform {
    CCSprite *platform;
    switch (arc4random()%3){
        case 0:
            platform = [CCSprite spriteWithFile:@"cloud-small.png"]; 
            platform.tag = currentPlatformTag;
        break;
        case 1:
            platform = [CCSprite spriteWithFile:@"cloud-medium.png"]; 
            platform.tag = currentPlatformTag;
        break;
        case 2:
            platform = [CCSprite spriteWithFile:@"cloud-big.png"]; 
            platform.tag = currentPlatformTag;
        break;
    }
    [self addChild:platform z:1];
}

- (void)resetPlatforms {
    //	NSLog(@"resetPlatforms");
	
	currentPlatformY = -1;
	currentPlatformTag = kPlatformStartTag;
	currentMaxPlatformStep = 60.0f;
	currentBonusPlatformIndex = 0;
	currentBonusType = 0;
	platformCount = 0;
    
	while(currentPlatformTag < kPlatformStartTag + kPlatformNumber) {
		[self resetPlatform];
		currentPlatformTag++;
	}
}

- (void)resetPlatform {
	
	if(currentPlatformY < 0) {
		currentPlatformY = 30.0f;
	} else {
		currentPlatformY += random() % (int)(currentMaxPlatformStep - kMinPlatformStep) + kMinPlatformStep;
		if(currentMaxPlatformStep < kMaxPlatformStep) {
			currentMaxPlatformStep += 0.5f;
		}
	}
	
	CCSprite *platform = (CCSprite*)[self getChildByTag:currentPlatformTag];
	
	if(random()%2==1) platform.scaleX = -1.0f;
	
	float x;
	CGSize size = platform.contentSize;
	if(currentPlatformY == 30.0f) {
		x = 160.0f;
	} else {
		x = random() % (320-(int)size.width) + size.width/2;
	}
	
	platform.position = ccp(x,currentPlatformY);
	platformCount++;
    //	NSLog(@"platformCount = %d",platformCount);
	
	if(platformCount == currentBonusPlatformIndex) {
        		NSLog(@"platformCount == currentBonusPlatformIndex");
		CCSprite *bonus = (CCSprite*)[self getChildByTag:kBonusStartTag+currentBonusType];
		bonus.position = ccp(x,currentPlatformY+30);
		bonus.visible = YES;
	}
     
}

-(void) resetHerbert {
    CCSprite *spriteHerbert = (CCSprite*)[self getChildByTag:kHerbertTag];
    
	herbert_pos.x = 160;
	herbert_pos.y = 160;
	spriteHerbert.position = herbert_pos;
	
    herbert_vel.x = 0;
	herbert_vel.y = 0;
	
	herbert_acc.x = 0;
	herbert_acc.y = -550.0f;
    
    herbert.scaleX = 1.0f;

}

- (void)resetBonus {
    //	NSLog(@"resetBonus");
	
	CCSprite *bonus = (CCSprite*)[self getChildByTag:kBonusStartTag+currentBonusType];
    
	bonus.visible = NO;
	currentBonusPlatformIndex += arc4random() % (kMaxBonusStep - kMinBonusStep) + kMinBonusStep;

    
	if(score < 1000) {
		currentBonusType = 0;
	} else if(score < 5000) {
		currentBonusType = random() % 2;
	} else if(score < 10000) {
		currentBonusType = random() % 3;
	} else {
		currentBonusType = random() % 2 + 2;
	}
}

- (void)step:(ccTime)dt {
	
	if(gameSuspended) return;
    
	CCSprite *spriteHerbert = (CCSprite*)[self getChildByTag:kHerbertTag];
	
	herbert_pos.x += herbert_vel.x * dt;
	
	if(herbert_vel.x < -30.0f && herbertLookingRight) {
		herbertLookingRight = NO;
		spriteHerbert.scaleX = -1.0f;
	} else if (herbert_vel.x > 30.0f && !herbertLookingRight) {
		herbertLookingRight = YES;
		spriteHerbert.scaleX = 1.0f;
	}
    
	CGSize herbert_size = herbert.contentSize;
	float max_x = 320-herbert_size.width/2;
	float min_x = 0+herbert_size.width/2;
	
	if(herbert_pos.x>max_x) herbert_pos.x = max_x;
	if(herbert_pos.x<min_x) herbert_pos.x = min_x;
	
	herbert_vel.y += herbert_acc.y * dt;
	herbert_pos.y += herbert_vel.y * dt;
	
    
	CCSprite *bonus = (CCSprite*)[self getChildByTag:kBonusStartTag+currentBonusType];
	if(bonus.visible) {
		CGPoint bonus_pos = bonus.position;
		float range = 30.0f;
		if(herbert_pos.x > bonus_pos.x - range &&
		   herbert_pos.x < bonus_pos.x + range &&
		   herbert_pos.y > bonus_pos.y - range &&
		   herbert_pos.y < bonus_pos.y + range ) {
			switch(currentBonusType) {
				case kBonus5:   score += 5000;   break;
				case kBonus10:  score += 10000;  break;
				case kBonus50:  score += 50000;  break;
				case kBonus100: score += 100000; break;
			}
			NSString *scoreStr = [NSString stringWithFormat:@"%d",score];
			[scoreLabel setString:scoreStr];
            [self playEffect:@"smb_coin.wav"];
			[self resetBonus];
		}
	}
	
	int t;
	
	if(herbert_vel.y < 0) {
		
		t = kPlatformStartTag;
		for(t; t < kPlatformStartTag + kPlatformNumber; t++) {
			CCSprite *platform = (CCSprite*)[self getChildByTag:t];
            
			CGSize platform_size = platform.contentSize;
			CGPoint platform_pos = platform.position;
			
			max_x = platform_pos.x - platform_size.width/2;
			min_x = platform_pos.x + platform_size.width/2;
			float min_y = platform_pos.y + (platform_size.height+herbert_size.height)/2 - kPlatformTopPadding;
			
			if(herbert_pos.x > max_x &&
			   herbert_pos.x < min_x &&
			   herbert_pos.y > platform_pos.y &&
			   herbert_pos.y < min_y) {
				[self jump];
			}
		}
		
		if(herbert_pos.y < -herbert_size.height/2) {
			[self gameOver];
		}
		
	} else if(herbert_pos.y > 240) {
		
		float delta = herbert_pos.y - 240;
		herbert_pos.y = 240;
        
		currentPlatformY -= delta;
        
        CCSprite *highScoreLabel = (CCSprite *)[self getChildByTag:999];
        
        if (hight > bestHight){
            highScoreLabel.visible = YES;
            highScoreLabel.position = ccp(highScoreLabel.position.x,highScoreLabel.position.y-delta);
        }
        
        if (highScoreLabel.position.y < 0)
            [self removeChild:highScoreLabel cleanup:YES];
        
		t = kPlatformStartTag;
		for(t; t < kPlatformStartTag + kPlatformNumber; t++) {
			CCSprite *platform = (CCSprite*)[self getChildByTag:t];
			CGPoint pos = platform.position;
			pos = ccp(pos.x,pos.y-delta);
			if(pos.y < -platform.contentSize.height/2) {
				currentPlatformTag = t;
				[self resetPlatform];
			} else {
				platform.position = pos;
			}
		}
		 
		if(bonus.visible) {
			CGPoint pos = bonus.position;
			pos.y -= delta;
			if(pos.y < -bonus.contentSize.height/2) {
				[self resetBonus];
			} else {
				bonus.position = pos;
			}
		}
		
		score += (int)delta;
        hight += (int)delta;
		NSString *scoreStr = [NSString stringWithFormat:@"%d",score];
        
		[scoreLabel setString:scoreStr];
	}
    CCSprite *highScoreLabel = (CCSprite *)[self getChildByTag:999];

    if (hight == bestHight){
        highScoreLabel.visible = YES;
	}
	spriteHerbert.position = herbert_pos;

}

- (void)jump {
    [self playEffect:@"smb_jumpsmall.wav"];
	herbert_vel.y = 350.0f + fabsf(herbert_vel.x);
}

- (void)gameOver {
    gameSuspended = YES;
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    [self playEffect:@"smb_mariodie.wav"];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [[NSUserDefaults standardUserDefaults]setInteger:score forKey:@"newHighScore"];
    if (hight > bestHight)
        [[NSUserDefaults standardUserDefaults]setInteger:hight forKey:@"bestHight"];

    [[NSUserDefaults standardUserDefaults] synchronize];
    sleep(3);
    [self.herbert stopAction:herbertFlying];
    [accelerometer setDelegate:nil];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInT transitionWithDuration:0.5f scene:[HighscoreLayer scene]]];
    
}

- (void)playEffect:(NSString *)sound{
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"effectStatus"] == 0) {
        [[SimpleAudioEngine sharedEngine]playEffect:sound];
    }
}


- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration {
	if(gameSuspended) return;
	float accel_filter = 0.1f;
	herbert_vel.x = herbert_vel.x * accel_filter + acceleration.x * (1.0f - accel_filter) * 500.0f;
}

- (void) dealloc {
    [super dealloc];
    
    [accelerometer release];
    [herbert release];
    [herbertFlying release];
    
}
@end
