//
//  Player.h
//  maze
//
//  Created by Andrew Boryk on 12/20/16.
//  Copyright © 2016 Andrew Boryk. All rights reserved.
//

#import "Maze-Prefix.pch"
#import "Space.h"

@protocol PathManagerDataSource;
@protocol PathManagerDelegate;

@interface Player : NSObject

@property (weak, nonatomic) id<PathManagerDataSource> dataSource;
@property (weak, nonatomic) id<PathManagerDelegate> delegate;

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
@property ItemType type;

/// Initializes a player
- (instancetype) initWithType:(ItemType) type playerID:(NSString *)playerID withPosition: (CGPoint) position;

/// Determines which space would be most beneficial for the user to interact
- (Space *) determineBestSpaceToInteract;

/// Start the player moving with AI
- (void) startAIMovements;

/// End the player moving with AI
- (void) endAIMovements;

@end

@protocol PathManagerDataSource <NSObject>

@end

@protocol PathManagerDelegate <NSObject>

@optional

- (void) didMoveAIPlayer: (Player *)player;

@end
