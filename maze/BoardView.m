//
//  BoardView.m
//  maze
//
//  Created by Andrew Boryk on 12/20/16.
//  Copyright © 2016 Andrew Boryk. All rights reserved.
//

#import "BoardView.h"
#import "PlayerView.h"
#import "SpaceView.h"
#import "Board.h"
#import "Game.h"
#import "Space.h"

@implementation BoardView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype) init {
    self = [super init];
    
    if (self) {
        
        self.backgroundColor = [Appearance boardBackgroundColor];
        self.frame = CGRectMake(0.0f, 0.0f, [Utils screenWidth], [Utils screenHeight]);
        self.spaces = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (instancetype) initWithBoard: (Board *) board {
    self = [self init];
    
    if (self) {
        
        self.board = board;
        
        if ([Utils notNull:self.board.boardArray]) {
            for (int y = 0; y < self.board.height; y++) {
                for (int x = 0; x < self.board.width; x++) {
                    Space *space = [self.board spaceForPoint:CGPointMake(x, y)];
                    SpaceView *spaceView = [[SpaceView alloc] initWithSpace:space width:self.board.width height:self.board.height];
                    [self addSubview:spaceView];
                    
                    NSString *spaceKey = [NSString stringWithFormat:@"%i:%i", x, y];
                    [self.spaces setObject:spaceView forKey:spaceKey];
                }
            }
            
            self.frame = CGRectMake(0.0f, 0.0f, self.board.width * [[SpaceView sharedInstance] defaultSpaceSize], self.board.height * [[SpaceView sharedInstance] defaultSpaceSize]);
        }
        
        
    }
    return self;
}

- (void) setObjectiveOne:(Space *)flagOne {
    if ([Utils notNull:[Game currentBoardView].flagOne]) {
        [[Game currentBoardView].flagOne removeFromSuperview];
    }
    
    [Game currentBoardView].flagOne = nil;
    
    if ([Utils notNull:flagOne]) {
        
        [[[Game currentBoardView] board] replacePoint:flagOne.position withSpace:flagOne];
        [Game setCurrentBoard:[[Game currentBoardView] board]];
        
        [Game currentBoardView].flagOne = [[Game currentBoardView] spaceViewForPoint:flagOne.position];
    }
}

- (void) setObjectiveTwo:(Space *)flagTwo {
    if ([Utils notNull:[Game currentBoardView].flagTwo]) {
        [[Game currentBoardView].flagTwo removeFromSuperview];
    }
    
    [Game currentBoardView].flagTwo = nil;
    
    if ([Utils notNull:flagTwo]) {
        
        
        [[[Game currentBoardView] board] replacePoint:flagTwo.position withSpace:flagTwo];
        [Game setCurrentBoard:[[Game currentBoardView] board]];
        
        [Game currentBoardView].flagTwo = [[Game currentBoardView] spaceViewForPoint:flagTwo.position];
    }
}

- (void) setObjectiveThree:(Space *)flagThree {
    if ([Utils notNull:[Game currentBoardView].flagThree]) {
        [[Game currentBoardView].flagThree removeFromSuperview];
    }
    
    [Game currentBoardView].flagThree = nil;
    
    if ([Utils notNull:flagThree]) {
        
        [[[Game currentBoardView] board] replacePoint:flagThree.position withSpace:flagThree];
        [Game setCurrentBoard:[[Game currentBoardView] board]];
        
        [Game currentBoardView].flagThree = [[Game currentBoardView] spaceViewForPoint:flagThree.position];
    }
}

- (SpaceView *) spaceViewForPoint: (CGPoint) point {
    
    if ([Utils notNull:self.spaces]) {
        NSString *spaceKey = [NSString stringWithFormat:@"%i:%i", (int)point.x, (int)point.y];
        
        return [self.spaces objectForKey:spaceKey];
    }
    
    return nil;
}

- (void) replaceSpace: (Space *)space {
    [[Game currentBoardView] spaceViewForPoint:space.position];
    
    SpaceView *spaceView = [[SpaceView alloc] initWithSpace:space width:[Game currentBoardView].board.width height:[Game currentBoardView].board.height];
    [[Game currentBoardView] addSubview:spaceView];
    
    NSString *spaceKey = [NSString stringWithFormat:@"%i:%i", (int)space.position.x, (int)space.position.y];
    [[Game currentBoardView].spaces setObject:spaceView forKey:spaceKey];
}
@end
