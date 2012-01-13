//
//  HelloWorldLayer.m
//  Super Herbert
//
//  Created by Philip Brechler on 09.01.12.
//   CC-BY-SA Philip Brechler & Peter Amende 2012  
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "SimpleAudioEngine.h"
// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        
        CCSprite *background = [CCSprite spriteWithFile:@"background-menu.png" rect:CGRectMake(0, 0, 320, 480)];
        
        background.position = CGPointMake(160, 240); 
        
        [self addChild:background z:0];
        
		[self addClouds];
        [self schedule:@selector(moveClouds:)];
        
		// ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
        
        CCMenuItemImage *play = [CCMenuItemImage itemFromNormalImage:@"btn_play.png" selectedImage:@"btn_play_over.png" target:self selector:@selector(play:)];
        CCMenuItemImage *blog = [CCMenuItemImage itemFromNormalImage:@"btn_blog.png" selectedImage:@"btn_blog_over.png" target:self selector:@selector(blog:)];
        CCMenuItemImage *pp = [CCMenuItemImage itemFromNormalImage:@"btn_pp.png" selectedImage:@"btn_pp_over.png" target:self selector:@selector(pp:)];
        CCMenuItemImage *wp = [CCMenuItemImage itemFromNormalImage:@"btn_wp.png" selectedImage:@"btn_wp_over.png" target:self selector:@selector(wp:)];
        CCMenuItemImage *settings = [CCMenuItemImage itemFromNormalImage:@"btn_settings.png" selectedImage:@"btn_settings_over.png" target:self selector:@selector(settings:)];
        
        CCMenu *startMenu = [CCMenu menuWithItems:play, blog, pp, wp, settings, nil];
        
        [startMenu alignItemsVerticallyWithPadding:8.0];
        
        startMenu.position = ccp(size.width/2, 160);
        
        [self addChild:startMenu z:3];
        
        CCLabelTTF *credits = [CCLabelTTF labelWithString:@"Coding: Philip Brechler • Graphics: Peter Amende • Code: github.com/plaetzchen\nMusic CC-BY-SA: Ozzed • Effect: CC-BY-SA freesounds.org" dimensions:CGSizeMake(320, 30) alignment:UITextAlignmentCenter fontName:@"Arial" fontSize:8.0];
        credits.position = ccp(160,10);
        
        [self addChild:credits];
        
         if ([[NSUserDefaults standardUserDefaults] integerForKey:@"musicStatus"] == 0) {
                [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"menu.mp3" loop:YES];
        }

	}
	return self;
}

- (void) play: (CCMenuItem  *) menuItem {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[JumpGameScene scene]]];
    
}

- (void) settings: (CCMenuItem  *) menuItem {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFlipX transitionWithDuration:0.5f scene:[SettingsLayer scene]]];
    
}

- (void) blog: (CCMenuItem  *) menuItem {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://www.herbert-foerster.de"]];
}

- (void) pp: (CCMenuItem  *) menuItem {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://www.piratenpartei-frankfurt.de"]];
}

- (void) wp: (CCMenuItem  *) menuItem {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://www.piratenpartei-frankfurt.de/content/wahlprogramm"]];
}

- (void) addClouds {
    
    clouds = [[NSMutableArray alloc]initWithCapacity:8];
    
    for (int i = 0; i < 5; i++){
        CCSprite *cloud;
        switch (arc4random() % 3){
            case 0:
                cloud = [CCSprite spriteWithFile:@"menu-cloud-1.png"];
                cloud.tag = 1;
            break;
            case 1:
                cloud = [CCSprite spriteWithFile:@"menu-cloud-2.png"];
                cloud.tag = 2;
                break;
            case 2:
                cloud = [CCSprite spriteWithFile:@"menu-cloud-3.png"];
                cloud.tag = 3;
            break;
            default:
                cloud = [CCSprite spriteWithFile:@"menu-cloud-1.png"];
                cloud.tag = 1;
            break;
        }
        cloud.position = CGPointMake(arc4random() % 380 +100 , arc4random() % 220 +20);
        [self addChild:cloud z:2];
        [clouds addObject:cloud];
    }
    
}

- (void) moveClouds:(ccTime)dt {
    for (int i = 0; i < clouds.count; i++){
        CCSprite *cloud = [clouds objectAtIndex:i];
        switch (cloud.tag){
            case 1:
                cloud.position = ccp(cloud.position.x+0.5,cloud.position.y); 
                break;
            case 2:
                cloud.position = ccp(cloud.position.x+0.3,cloud.position.y); 
                break;
            case 3:
                cloud.position = ccp(cloud.position.x+0.1,cloud.position.y); 
                break;
        }
        if (cloud.position.x >480+480){
            cloud.position = ccp(-480, arc4random() % 220 +20);
        }
    }
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    
	[super dealloc];
    
}
@end
