//
//  Wall.m
//  maze
//
//  Created by Andrew Boryk on 12/20/16.
//  Copyright © 2016 Andrew Boryk. All rights reserved.
//

#import "Space.h"

@implementation Space

- (instancetype) init {
    self = [super init];
    
    if (self) {
        self.type = SpaceTypeEmpty;
    }
    
    return self;
}

- (instancetype) initWithType: (SpaceType) type position: (CGPoint)position {
    self = [self init];
    
    if (self) {
        
        self.type = type;
        self.position = position;
        
    }
    
    return self;
}

+ (BOOL) canPass:(Space *)space direction:(DirectionType)direction alliance: (BOOL) friendly {
    if (friendly) {
        if (space.type == SpaceTypeFriendlyHome || space.type == SpaceTypeCapturedFriendly || space.type == SpaceTypeCapturedFriendlyFlag) {
            return YES;
        }
    }
    else {
        if (space.type == SpaceTypeEnemyHome || space.type == SpaceTypeCapturedEnemy || space.type == SpaceTypeCapturedEnemyFlag) {
            return YES;
        }
    }
    
   
    
    return NO;
}

@end
