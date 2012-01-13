//
//  HighscoreLayer.h
//  Super Herbert
//
//  Created by Philip Brechler on 09.01.12.
//  Copyright 2012 CC-BY-SA Philip Brechler & Peter Amende 2012 GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface HighscoreLayer : CCLayer {
    int score;
    BOOL newHighScore;
}

+(id)scene;

@end
