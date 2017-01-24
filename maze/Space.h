//
//  Wall.h
//  maze
//
//  Created by Andrew Boryk on 12/20/16.
//  Copyright © 2016 Andrew Boryk. All rights reserved.
//

#import "Maze-Prefix.pch"

@interface Space : NSObject

/// Type of space
@property SpaceType type;

/// Position for space
@property CGPoint position;

/// Determines if player can pass through wall going in a direction
+ (BOOL) canPass:(Space *)space direction:(DirectionType)direction alliance:(BOOL)friendly;

/// Inits a space for type
- (instancetype) initWithType: (SpaceType) type position: (CGPoint)position;
@end
