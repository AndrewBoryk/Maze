//
//  Board.h
//  maze
//
//  Created by Andrew Boryk on 12/20/16.
//  Copyright © 2016 Andrew Boryk. All rights reserved.
//

#import "Maze-Prefix.pch"
#import "Space.h"

@interface Board : NSObject

/// Array which holds coordinates for board
@property (strong, nonatomic) NSMutableArray *boardArray;

/// Scale for the board
@property NSInteger scale;

/// initialized board with scale
- (instancetype) initWithScale: (NSInteger) scale;

/// Returns the space at a point
- (Space *) spaceForPoint: (CGPoint) point;

/// Returns number value for point
- (NSNumber *) numberForPoint: (CGPoint) point;

/// Returns wall for point
- (WallType) wallForPoint: (CGPoint) point;

@end
