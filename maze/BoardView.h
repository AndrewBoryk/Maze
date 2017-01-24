//
//  BoardView.h
//  maze
//
//  Created by Andrew Boryk on 12/20/16.
//  Copyright © 2016 Andrew Boryk. All rights reserved.
//

#import "Maze-Prefix.pch"
#import "Board.h"
@class SpaceView;
#import "Player.h"

@interface BoardView : UIView

/// Current boardView instance
+ (id)sharedInstance;

/// Set the current boardView
+ (void) setCurrentBoardView: (BoardView *) boardView;

/// Return the current board
+ (BoardView *) currentBoardView;

/// Current board
@property (strong, nonatomic) BoardView *currentBoardViewInstance;

/// Board for view
@property (strong, nonatomic) Board *board;

/// First objective flag to capture
@property (strong, nonatomic) SpaceView *flagOne;

/// Second objective flag to capture
@property (strong, nonatomic) SpaceView *flagTwo;

/// Third objective flag to capture
@property (strong, nonatomic) SpaceView *flagThree;

- (void) setObjectiveOne:(Space *)flagOne;

- (void) setObjectiveTwo:(Space *)flagTwo;

- (void) setObjectiveThree:(Space *)flagThree;

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

/// Replace a space on the board
- (void) replaceSpace: (Space *)space;
@end
