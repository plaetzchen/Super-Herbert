//
//  SettingsLayer.m
//  Super Herbert
//
//  Created by Philip Brechler on 10.01.12.
//  Copyright 2012 CC-BY-SA Philip Brechler & Peter Amende 2012 GmbH. All rights reserved.
//

#import "SettingsLayer.h"
#import "SimpleAudioEngine.h"

@implementation SettingsLayer

+(id)scene {
    CCScene *scene = [CCScene node];
    
    SettingsLayer *layer = [SettingsLayer node];
    
    [scene addChild:layer];
    
    return scene;
}

- (id)init {
    if( (self= [super init])) {
        CCSprite *background = [CCSprite spriteWithFile:@"background-menu.png" rect:CGRectMake(0, 0, 320, 480)];
        
        background.position = CGPointMake(160, 240); 
        
        [self addChild:background z:0];
        
        CCMenuItem *onMusic = [CCMenuItemImage itemFromNormalImage:@"opt_music_on.png" selectedImage:@"opt_music_on.png" target:nil selector:nil];
        CCMenuItem *offMusic = [CCMenuItemImage itemFromNormalImage:@"opt_music_off.png" selectedImage:@"opt_music_off.png" target:nil selector:nil];

        
        musicSwitch = [CCMenuItemToggle itemWithTarget:self selector:@selector(musicSwitch:) items:
                                     onMusic,
                                     offMusic,
                                     nil];
        
        
        CCMenuItem *onEffects = [CCMenuItemImage itemFromNormalImage:@"opt_effects_on.png" selectedImage:@"opt_effects_on.png" target:nil selector:nil];
        CCMenuItem *offEffects = [CCMenuItemImage itemFromNormalImage:@"opt_effects_off.png" selectedImage:@"opt_effects_off.png" target:nil selector:nil];
        
        
        effectSwitch = [CCMenuItemToggle itemWithTarget:self selector:@selector(effectSwitch:) items:
                                         onEffects,
                                         offEffects,
                                         nil];
        
        
        CCMenuItemImage *back = [CCMenuItemImage itemFromNormalImage:@"btn_done.png" selectedImage:@"btn_done.png" target:self selector:@selector(back:)];
        
        CCMenu *menu = [CCMenu menuWithItems:musicSwitch, effectSwitch, back, nil];
        
        [menu alignItemsVerticallyWithPadding:25.0];
        
        menu.position = ccp(160,100);
        
        [self addChild:menu];
        
        [self updateSwitches];
    }
    return self;
}

- (void)onEnterTransitionDidFinish {
    [self updateSwitches];
}
- (void)musicSwitch:(CCMenuItemToggle *)item {
    switch (item.selectedIndex) {
        case 0:
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"musicStatus"];
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"menu.mp3" loop:YES];
            break;
        case 1:
            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"musicStatus"];
            [[SimpleAudioEngine sharedEngine]stopBackgroundMusic];
            break;
        default:
            break;
    }
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)effectSwitch:(CCMenuItemToggle *)item {
    switch (item.selectedIndex) {
        case 0:
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"effectStatus"];
            break;
        case 1:
            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"effectStatus"];
            break;
        default:
            break;
    }
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)back:(CCMenuItem *)item {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFlipX transitionWithDuration:0.5f scene:[HelloWorldLayer scene]]];
}

- (void)updateSwitches {
    int musicSetting = [[NSUserDefaults standardUserDefaults]integerForKey:@"musicStatus"];
    NSLog(@"musicSetting: %d",musicSetting);
    [musicSwitch setSelectedIndex: musicSetting];
    
    int effectSetting = [[NSUserDefaults standardUserDefaults]integerForKey:@"effectStatus"];
    
    [effectSwitch setSelectedIndex: effectSetting]; 
    
}
@end
