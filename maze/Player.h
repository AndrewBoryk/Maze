//
//  Player.h
//  maze
//
//  Created by Andrew Boryk on 12/20/16.
//  Copyright © 2016 Andrew Boryk. All rights reserved.
//

#import "Maze-Prefix.pch"

@interface Player : NSObject

/// Direction that player is heading
@property DirectionType direction;

/// Position of player
@property CGPoint position;

/// Speed that the player is traveling
@property float speed;

/// Determines if player is a moving ghost
@property BOOL isGhost;

@end
