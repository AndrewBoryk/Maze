//
//  Wall.h
//  maze
//
//  Created by Andrew Boryk on 12/20/16.
//  Copyright © 2016 Andrew Boryk. All rights reserved.
//

#import "Maze-Prefix.pch"

@class Board;

@interface Space : NSObject

/// Type of space
@property SpaceType type;

/// Position for space
@property CGPoint position;

/// Percentage that a space is friendly
@property float friendlyPercentage;

/// Percentage that a space is enemy
@property float enemyPercentage;

/// Determines whether this space contains a flag
@property BOOL isFlag;

/// Determines whether this space is designated as a home base
@property BOOL isBase;

/// Determines if player can pass through wall going in a direction
+ (BOOL) canPass:(CGPoint )point playerType: (PlayerType) playerType;

/// Inits a space for type
- (instancetype) initWithType: (SpaceType) type position: (CGPoint)position;
@end
