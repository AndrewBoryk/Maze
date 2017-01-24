//
//  BoardView.m
//  maze
//
//  Created by Andrew Boryk on 12/20/16.
//  Copyright © 2016 Andrew Boryk. All rights reserved.
//

#import "BoardView.h"
#import "PlayerView.h"

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

- (void) addPlayer:(Player *)player {
    if ([Utils notNull:self.board] && [Utils notNull:player]) {
        if ([Utils notNull:player.playerID]) {
            if (![Utils notNull:self.board.playerArray]) {
                self.board.playerArray = [[NSMutableArray alloc] init];
            }
            
            BOOL found = NO;
            for (Player *tempPlayer in self.board.playerArray) {
                if ([Utils notNull:tempPlayer.playerID]) {
                    if ([tempPlayer.playerID isEqualToString:player.playerID]) {
                        found = YES;
                        break;
                    }
                }
            }
            
            if (!found) {
                [self.board.playerArray addObject:player];
                PlayerView *playerView = [[PlayerView alloc] initWithPlayer:player inBoard:self];
                [self.board.playerViewArray addObject:playerView];
                [self addSubview:playerView];
            }
        }
        
    }
}

- (void) removePlayer: (NSString *) playerID {
    if ([Utils notNull:self.board] && [Utils notNull:playerID]) {
        if (![Utils notNull:self.board.playerViewArray]) {
            self.board.playerViewArray = [[NSMutableArray alloc] init];
        }
        
        if (![Utils notNull:self.board.playerArray]) {
            self.board.playerArray = [[NSMutableArray alloc] init];
        }
        else {
            for (Player *tempPlayer in self.board.playerArray) {
                if ([Utils notNull:tempPlayer.playerID]) {
                    if ([tempPlayer.playerID isEqualToString:playerID]) {
                        [self.board.playerArray removeObject:tempPlayer];
                        break;
                    }
                }
            }
            
            for (PlayerView *tempPlayerView in self.board.playerViewArray) {
                if ([Utils notNull:tempPlayerView.player]) {
                    if ([Utils notNull:tempPlayerView.player.playerID]) {
                        if ([tempPlayerView.player.playerID isEqualToString:playerID]) {
                            [self.board.playerViewArray removeObject:tempPlayerView];
                            [tempPlayerView removeFromSuperview];
                            
                            break;
                        }
                    }
                }
            }
        }
    }
}

- (void) movePlayer:(Player *)player toPosition:(CGPoint)position {
    if ([Utils notNull:self.board] && [Utils notNull:player.playerID]) {
        if (![Utils notNull:self.board.playerArray]) {
            self.board.playerArray = [[NSMutableArray alloc] init];
        }
        
        if (![Utils notNull:self.board.playerViewArray]) {
            self.board.playerViewArray = [[NSMutableArray alloc] init];
        }
        
        if (position.x < self.board.width && position.y < self.board.height) {
            if ([Space canPass:position inBoard:self.board playerType:player.type]) {
                for (Player *tempPlayer in self.board.playerArray) {
                    if ([Utils notNull:tempPlayer.playerID]) {
                        if ([tempPlayer.playerID isEqualToString:player.playerID]) {
                            tempPlayer.position = position;
                            
                            for (PlayerView *tempPlayerView in self.board.playerViewArray) {
                                if ([Utils notNull:tempPlayerView.player]) {
                                    if ([Utils notNull:tempPlayerView.player.playerID]) {
                                        if ([tempPlayerView.player.playerID isEqualToString:tempPlayer.playerID]) {
                                            tempPlayerView.center = [[self spaceViewForPoint:tempPlayer.position] center];
                                            
                                            break;
                                        }
                                    }
                                }
                            }
                            
                            break;
                        }
                    }
                }
            }
            
        }
        
    }
}


- (SpaceView *) spaceViewForPoint: (CGPoint) point {
    
    if ([Utils notNull:self.spaces]) {
        NSString *spaceKey = [NSString stringWithFormat:@"%i:%i", (int)point.x, (int)point.y];
        
        return [self.spaces objectForKey:spaceKey];
    }
    
    return nil;
}
@end
