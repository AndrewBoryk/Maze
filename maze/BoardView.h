//
//  BoardView.h
//  maze
//
//  Created by Andrew Boryk on 12/20/16.
//  Copyright © 2016 Andrew Boryk. All rights reserved.
//

#import "Maze-Prefix.pch"
#import "Board.h"
#import "SpaceView.h"
#import "Player.h"

@interface BoardView : UIView

/// Board for view
@property (strong, nonatomic) Board *board;

/// Array which contains all spaces
@property (strong, nonatomic) NSMutableDictionary *spaces;

/// Initializes view wiht board
- (instancetype) initWithBoard: (Board *) board;

/// Adds a player to the board
- (void) addPlayer: (Player *) player;

/// Moves a player to a position
- (void) movePlayer: (Player *) player toPosition: (CGPoint) position;

/// Remove a player from the board
- (void) removePlayer: (Player *) player;

/// Returns a spaceView for a given point
- (SpaceView *) spaceViewForPoint: (CGPoint) point;
@end
