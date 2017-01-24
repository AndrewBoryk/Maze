//
//  SpaceView.h
//  maze
//
//  Created by Andrew Boryk on 12/20/16.
//  Copyright © 2016 Andrew Boryk. All rights reserved.
//

#import "Maze-Prefix.pch"
#import "WallView.h"
#import "Space.h"

@interface SpaceView : UIView {
    /// Default size for a space
    CGFloat defaultSpaceSize;
}

/// Shared instance, for default values pertaining to the spaceView
+ (id)sharedInstance;

/// Default size for a space
@property (nonatomic) CGFloat defaultSpaceSize;

/// Space for view
@property (strong, nonatomic) Space *space;

/// Width for board
@property CGFloat width;

/// Height for board
@property CGFloat height;

/// Size for space
@property CGFloat size;

/// Wall on the space's left side
@property (strong, nonatomic) WallView *leftWall;

/// Wall on the space's right side
@property (strong, nonatomic) WallView *rightWall;

/// Wall on the space's up side
@property (strong, nonatomic) WallView *upWall;

/// Wall on the space's down side
@property (strong, nonatomic) WallView *downWall;

/// Color for the goal
@property (strong, nonatomic) UIColor *goalColor;

/// Determines if the space is a goal
@property BOOL isGoal;

/// Determines if goal has been completed
@property BOOL isCompleted;

/// Initialize space
- (instancetype) initWithSpace:(Space *)space width:(NSInteger)width height:(NSInteger) height;
@end
