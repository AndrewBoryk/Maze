//
//  Wall.h
//  maze
//
//  Created by Andrew Boryk on 12/20/16.
//  Copyright © 2016 Andrew Boryk. All rights reserved.
//

#import "Maze-Prefix.pch"

@interface WallView : UIView

/// Determines if the wall is filled in or empty
@property BOOL isWallVisible;

/// Side that the wall is on
@property DirectionType sideType;

/// Size of the space that the wall encompasses
@property NSInteger size;

/// Initialize a wall for a side and size
- (instancetype) initWithSide:(DirectionType)direction size:(CGFloat)size;

/// Sets whether a wall is visible
- (void) setWallVisible:(BOOL)visible;

@end
