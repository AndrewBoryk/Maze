//
//  Player.h
//  maze
//
//  Created by Andrew Boryk on 12/20/16.
//  Copyright © 2016 Andrew Boryk. All rights reserved.
//

#import "Maze-Prefix.pch"

@class Space;

@protocol PathManagerDataSource;
@protocol PathManagerDelegate;

@interface Player : NSObject

@property (weak, nonatomic) id<PathManagerDataSource> dataSource;
@property (weak, nonatomic) id<PathManagerDelegate> delegate;

/// ID of player
@property (strong, nonatomic) NSString *playerID;

/// Position of player
@property CGPoint position;

/// Type of player
@property ItemType type;

/// State of player when in AI mode
@property PlayerState state;

/// Health of the player
@property float health;

/// Number of the player
@property int playerNumber;

/// Initializes a player
- (instancetype) initWithType:(ItemType) type playerID:(NSString *)playerID withPosition: (CGPoint) position andPlayerNumber: (int)playerNumber;

/// Determines which space would be most beneficial for the user to interact
- (Space *) determineBestSpaceToInteract;

/// Start the player moving with AI
- (void) startAIMovements;

/// End the player moving with AI
- (void) endAIMovements;

/// Adjust the health of the player
+ (void) adjustHealthOfPlayer:(Player *)player by:(float) healthAdjustment;

@end

@protocol PathManagerDataSource <NSObject>

@end

@protocol PathManagerDelegate <NSObject>

@optional

- (void) didMoveAIPlayer: (Player *)player;

@end
