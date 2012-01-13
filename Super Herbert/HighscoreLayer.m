//
//  HighscoreLayer.m
//  Super Herbert
//
//  Created by Philip Brechler on 09.01.12.
//  Copyright 2012 CC-BY-SA Philip Brechler & Peter Amende 2012 GmbH. All rights reserved.
//

#import "HighscoreLayer.h"
#import "SimpleAudioEngine.h"
#import "JumpGameScene.h"
#import "HelloWorldLayer.h"

@implementation HighscoreLayer


+(id)scene {
    CCScene *scene = [CCScene node];
    
    HighscoreLayer *layer = [HighscoreLayer node];
    
    [scene addChild:layer];
    
    return scene;
}

- (id)init {
    if( (self= [super init])) {
        
        if([[NSUserDefaults standardUserDefaults] integerForKey:@"highScore"]<[[NSUserDefaults standardUserDefaults] integerForKey:@"newHighScore"]){
            newHighScore = YES;
            [[NSUserDefaults standardUserDefaults]setInteger:[[NSUserDefaults standardUserDefaults] integerForKey:@"newHighScore"] forKey:@"highScore"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        else {
            newHighScore = NO;
        }
        score = [[NSUserDefaults standardUserDefaults] integerForKey:@"newHighScore"];
        
        CCSprite *hsbackground = [CCSprite spriteWithFile:@"background_gameover.png" rect:CGRectMake(0, 0, 320, 480)];
        
        hsbackground.position = ccp(160, 240); 
        
        [self addChild:hsbackground];
        
        NSString *scoreString = [NSString stringWithFormat:@"Du hast %d Punkte erreicht.", score];
        if (newHighScore)
            scoreString = [scoreString stringByAppendingString:@" Das ist eine neue Bestmarke!"];
        
        CCLabelTTF *scoreView = [CCLabelTTF labelWithString:scoreString dimensions:CGSizeMake(300, 200) alignment:UITextAlignmentCenter fontName:@"Arial" fontSize:16.0];
        scoreView.position = ccp(160,130);
        
        [self addChild:scoreView];
        CCMenuItemImage *again = [CCMenuItemImage itemFromNormalImage:@"btn_repeat.png" selectedImage:@"btn_repeat_over.png" target:self selector:@selector(repeat:)];
        CCMenuItemImage *menu = [CCMenuItemImage itemFromNormalImage:@"btn_menu.png" selectedImage:@"btn_menu_over.png" target:self selector:@selector(menu:)];
        
        CCMenu *hsMenu = [CCMenu menuWithItems:again,menu, nil];
        
        [hsMenu alignItemsVerticallyWithPadding:8.0];
        
        hsMenu.position = ccp(160, 100);
        
        [self addChild:hsMenu z:3];
         
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"musicStatus"] == 0) {
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"menu.mp3" loop:YES];
        }

    }
    return self;
}

-(void)repeat:(CCMenuItem  *) menuItem {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInT transitionWithDuration:0.5f scene:[JumpGameScene scene]]];
}

-(void)menu:(CCMenuItem  *) menuItem {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFlipAngular transitionWithDuration:0.5f scene:[HelloWorldLayer scene]]];
}

- (void)dealloc {
    [super dealloc];
}
 
@end
