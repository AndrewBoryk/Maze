//
//  Player.h
//  maze
//
//  Created by Andrew Boryk on 12/20/16.
//  Copyright © 2016 Andrew Boryk. All rights reserved.
//

#import "Maze-Prefix.pch"

@interface Player : NSObject

/// ID of player
@property (strong, nonatomic) NSString *playerID;

/// Position of player
@property CGPoint position;

/// Type of player
@property PlayerType type;

/// Initializes a player
- (instancetype) initWithType:(PlayerType) type playerID:(NSString *)playerID withPosition: (CGPoint) position;

@end
