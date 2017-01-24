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
        self.type = ItemTypeEmpty;
    }
    
    return self;
}

- (instancetype) initWithType: (ItemType) type position: (CGPoint)position {
    self = [self init];
    
    if (self) {
        
        self.type = type;
        self.position = position;
        self.friendlyPercentage = 0;
        self.enemyPercentage = 0;
        
        if (self.type == ItemTypeFriendly) {
            self.friendlyPercentage = 1;
            self.enemyPercentage = 0;
            
        }
        else if (self.type == ItemTypeEnemy) {
            self.friendlyPercentage = 0;
            self.enemyPercentage = 1;
        }
    }
    
    return self;
}

+ (BOOL) canPass:(CGPoint )point playerType:(ItemType)playerType {
    
    Space *space = [[Board currentBoard] spaceForPoint:point];
    if ([Utils notNull:space]) {
        if (playerType == space.type) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL) space:(Space *)spaceOne isSameAsSpace:(Space *)spaceTwo {
    if ([Utils notNull:spaceOne] && [Utils notNull:spaceTwo]) {
        if ((spaceOne.position.x == spaceTwo.position.x) && (spaceOne.position.y == spaceTwo.position.y)) {
            return YES;
        }
    }
    
    return NO;
}

@end
