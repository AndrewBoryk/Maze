//
//  BoardView.h
//  maze
//
//  Created by Andrew Boryk on 12/20/16.
//  Copyright © 2016 Andrew Boryk. All rights reserved.
//

#import "Maze-Prefix.pch"
@class Board;
@class SpaceView;
@class Player;
@class Space;

@protocol BoardViewDelegate;

@interface BoardView : UIView

@property (weak, nonatomic) id<BoardViewDelegate> delegate;

/// Board for view
@property (strong, nonatomic) Board *board;

/// First objective flag to capture
@property (strong, nonatomic) SpaceView *flagOne;

/// Second objective flag to capture
@property (strong, nonatomic) SpaceView *flagTwo;

/// Third objective flag to capture
@property (strong, nonatomic) SpaceView *flagThree;

- (void) setObjectiveOne:(Space *)flagOne;

- (void) setObjectiveTwo:(Space *)flagTwo;

- (void) setObjectiveThree:(Space *)flagThree;

/// Array which contains all spaces
@property (strong, nonatomic) NSMutableDictionary *spaces;

/// Initializes view wiht board
- (instancetype) initWithBoard: (Board *) board;

/// Returns a spaceView for a given point
- (SpaceView *) spaceViewForPoint: (CGPoint) point;

/// Replace a space on the board
- (void) replaceSpace: (Space *)space;


@end

@protocol BoardViewDelegate <NSObject>

@optional

- (void) adjustedObjective: (NSInteger) objectiveNumber withSpaceView: (SpaceView *) spaceView;


@end
