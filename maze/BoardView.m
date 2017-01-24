//
//  BoardView.m
//  maze
//
//  Created by Andrew Boryk on 12/20/16.
//  Copyright © 2016 Andrew Boryk. All rights reserved.
//

#import "BoardView.h"

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
@end
