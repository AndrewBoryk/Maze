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
        self.frame = CGRectMake(40.0f, 40.0f, [Utils screenWidth] - 80.0f, [Utils screenWidth] - 80.0f);
        self.spaces = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (instancetype) initWithBoard: (Board *) board {
    self = [self init];
    
    if (self) {
        
        self.board = board;
        
        if ([Utils notNull:self.board.boardArray]) {
            for (int y = 0; y < self.board.scale; y++) {
                for (int x = 0; x < self.board.scale; x++) {
                    Space *space = [self.board spaceForPoint:CGPointMake(x, y)];
                    SpaceView *spaceView = [[SpaceView alloc] initWithSpace:space scale:self.board.scale];
                    [self addSubview:spaceView];
                    
                    NSString *spaceKey = [NSString stringWithFormat:@"%i:%i", x, y];
                    [self.spaces setObject:spaceView forKey:spaceKey];
                }
            }
        }
        
    }
    
    return self;
}
@end
