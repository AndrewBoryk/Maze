//
//  Wall.h
//  maze
//
//  Created by Andrew Boryk on 12/20/16.
//  Copyright © 2016 Andrew Boryk. All rights reserved.
//

#import "Maze-Prefix.pch"

@interface Space : NSObject

/// Type for wall
@property WallType type;

/// If true, there is a wall on the left side
@property BOOL leftSide;

/// If true, there is a wall on the right side
@property BOOL rightSide;

/// If true, there is a wall on the up side
@property BOOL upSide;

/// If true, there is a wall on the down side
@property BOOL downSide;

/// Position for space
@property CGPoint position;

/// Determines if player can pass through wall going in a direction
+ (BOOL) canPass: (WallType) wall direction: (DirectionType) direction;

/// Inits a wall for type
- (instancetype) initWithType: (WallType) wall position: (CGPoint)position;
@end
