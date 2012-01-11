//
//  HighscoreLayer.h
//  Super Herbert
//
//  Created by Philip Brechler on 09.01.12.
//  Copyright 2012 Hoccer GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface HighscoreLayer : CCLayer {
    int score;
    BOOL newHighScore;
}

+(id)scene;

@end
