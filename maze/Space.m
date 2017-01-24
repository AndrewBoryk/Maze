//
//  Wall.m
//  maze
//
//  Created by Andrew Boryk on 12/20/16.
//  Copyright © 2016 Andrew Boryk. All rights reserved.
//

#import "Space.h"
#import "Board.h"

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

+ (BOOL) canPass:(CGPoint )point inBoard: (Board *)board playerType:(PlayerType)playerType {
    
    Space *space = [board spaceForPoint:point];
    if ([Utils notNull:space]) {
        if (playerType == PlayerTypeFriendly) {
            if (space.type == SpaceTypeFriendlyHome || space.type == SpaceTypeCapturedFriendly || space.type == SpaceTypeCapturedFriendlyFlag || space.type == SpaceTypeEmpty) {
                return YES;
            }
        }
        else if (playerType == PlayerTypeEnemy) {
            if (space.type == SpaceTypeEnemyHome || space.type == SpaceTypeCapturedEnemy || space.type == SpaceTypeCapturedEnemyFlag || space.type == SpaceTypeEmpty) {
                return YES;
            }
        }
    }
    
    
   
    
    return NO;
}

@end
