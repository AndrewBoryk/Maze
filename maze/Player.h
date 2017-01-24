//
//  Player.h
//  maze
//
//  Created by Andrew Boryk on 12/20/16.
//  Copyright © 2016 Andrew Boryk. All rights reserved.
//

#import "Maze-Prefix.pch"
#import "Player.h"

@interface Player : NSObject

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

@end
