//
//  Board.h
//  maze
//
//  Created by Andrew Boryk on 12/20/16.
//  Copyright © 2016 Andrew Boryk. All rights reserved.
//

#import "Maze-Prefix.pch"
#import "Space.h"
@class SpaceView;

@interface Board : NSObject

/// Current board instance
+ (id)sharedInstance;

/// Set the current board
+ (void) setCurrentBoard: (Board *) board;

/// Return the current board
+ (Board *) currentBoard;

/// Current board
@property (strong, nonatomic) Board *currentBoardInstance;

/// Array which holds coordinates for board
@property (strong, nonatomic) NSMutableArray *boardArray;

/// Width for the board
@property NSInteger width;

/// Height for the board
@property NSInteger height;

/// Dictionary containing players
@property NSMutableArray *playerArray;

/// Dictionary containing players
@property NSMutableArray *playerViewArray;

/// initialized board with scale
- (instancetype) initWithScale: (NSInteger) scale;

/// Initialize a board with a width and height
- (instancetype) initWithWidth: (NSInteger) width height:(NSInteger) height;

/// Returns the space at a point
- (Space *) spaceForPoint: (CGPoint) point;

/// Returns number value for point
- (NSNumber *) numberForPoint: (CGPoint) point;

/// Returns wall for point
- (WallType) wallForPoint: (CGPoint) point;

/// Replaces a space with a new space
- (BOOL) replacePoint: (CGPoint) point withType:(SpaceType) type;

/// Replace a point on the board with a space
- (BOOL) replacePoint:(CGPoint)point withSpace:(Space *)space;

/// Adjusts a space
- (BOOL) adjustSpace:(Space *)space;

/// Log the board to console
- (void) printBoard;


@end
