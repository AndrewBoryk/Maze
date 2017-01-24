//
//  Player.h
//  maze
//
//  Created by Andrew Boryk on 12/20/16.
//  Copyright © 2016 Andrew Boryk. All rights reserved.
//

#import "Maze-Prefix.pch"
#import "Player.h"
#import "Space.h"

@protocol PathManagerDataSource;

@interface Player : NSObject

@property (weak, nonatomic) id<PathManagerDataSource> dataSource;

/// Current player instance
+ (id)sharedInstance;

/// Set the current player
+ (void) setCurrentPlayer: (Player *) player;

/// Return the current player
+ (Player *) currentPlayer;

/// Current player
@property (strong, nonatomic) Player *currentPlayerInstance;

/// ID of player
@property (strong, nonatomic) NSString *playerID;

/// Position of player
@property CGPoint position;

/// Type of player
@property PlayerType type;

/// Initializes a player
- (instancetype) initWithType:(PlayerType) type playerID:(NSString *)playerID withPosition: (CGPoint) position;

/// Determines which space would be most beneficial for the user to interact
- (Space *) determineBestSpaceToInteract;

@end

@protocol PathManagerDataSource <NSObject>

/// DataSource for termining objective for player
- (Space *) objectiveSpaceForPlayer: (Player *)player;

@end
