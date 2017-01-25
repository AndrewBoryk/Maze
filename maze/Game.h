//
//  Game.h
//  maze
//
//  Created by Andrew Boryk on 1/24/17.
//  Copyright © 2017 Andrew Boryk. All rights reserved.
//

#import "Maze-Prefix.pch"
#import "Player.h"
#import "Board.h"
#import "BoardView.h"
#import "PlayerView.h"

@interface Game : NSObject

/// Current player instance
+ (id)sharedInstance;

/// Array holding friendly players
@property (strong, nonatomic) NSMutableArray *friendlyArray;

/// Array holding friendly bases
@property (strong, nonatomic) NSMutableArray *friendlyHomeArray;

/// Array holding enemy players
@property (strong, nonatomic) NSMutableArray *enemyArray;

/// Array holding enemy bases
@property (strong, nonatomic) NSMutableArray *enemyHomeArray;

/// Dictionary containing players
@property NSMutableArray *playerViewArray;

/// Current board
@property (strong, nonatomic) BoardView *currentBoardViewInstance;

/// Current board
@property (strong, nonatomic) Board *currentBoardInstance;

/// Current player
@property (strong, nonatomic) Player *currentPlayerInstance;

/// Set the current player
+ (void) setCurrentPlayer: (Player *) player;

/// Return the current player
+ (Player *) currentPlayer;

/// Set the current board
+ (void) setCurrentBoard: (Board *) board;

/// Return the current board
+ (Board *) currentBoard;

/// Set the current boardView
+ (void) setCurrentBoardView: (BoardView *) boardView;

/// Return the current board
+ (BoardView *) currentBoardView;

/// Adds a player to the board
- (void) addPlayer: (Player *) player;

/// Moves a player to a position
- (void) movePlayer: (Player *) player toPosition: (CGPoint) position;

/// Remove a player from the board
- (void) removePlayer: (Player *) player;

/// Determines if there are any players in the space
+ (NSArray *)playersInSpace:(Space *)space notOfAlliance:(ItemType) type;

/// Returns playerview for a player
+ (PlayerView *)playerViewForPlayer: (Player *)player;

/// Returns home space for player
+ (Space *)homeForPlayer:(Player *)player;
@end
