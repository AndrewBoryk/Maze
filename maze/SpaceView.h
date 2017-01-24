//
//  SpaceView.h
//  maze
//
//  Created by Andrew Boryk on 12/20/16.
//  Copyright © 2016 Andrew Boryk. All rights reserved.
//

#import "Maze-Prefix.pch"
#import "Space.h"
#import "BoardView.h"

@interface SpaceView : UIView <UIGestureRecognizerDelegate> {
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

/// Color for the goal
@property (strong, nonatomic) UIColor *goalColor;

/// Determines if the space is a goal
@property BOOL isGoal;

/// Determines if goal has been completed
@property BOOL isCompleted;

/// Initialize space
- (instancetype) initWithSpace:(Space *)space width:(NSInteger)width height:(NSInteger) height;

/// Adjust the space
+ (void) adjustSpaceAtPosition: (CGPoint) position forType: (PlayerType) playerType inBoard: (BoardView *) boardView;
@end
