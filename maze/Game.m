//
//  Game.m
//  maze
//
//  Created by Andrew Boryk on 1/24/17.
//  Copyright © 2017 Andrew Boryk. All rights reserved.
//

#import "Game.h"
#import "Space.h"
#import "SpaceView.h"

@implementation Game

- (instancetype) init {
    self = [super init];
    
    if (self) {
        self.friendlyArray = [[NSMutableArray alloc] init];
        self.enemyArray = [[NSMutableArray alloc] init];
        self.playerViewArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}

+ (id)sharedInstance {
    static Game *sharedMyInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyInstance = [[self alloc] init];
    });
    return sharedMyInstance;
}

+ (void) setCurrentPlayer: (Player *) player{
    [[Game sharedInstance] setCurrentPlayerInstance:player];
}

+ (Player *) currentPlayer {
    return [[Game sharedInstance] currentPlayerInstance];
}

+ (void) setCurrentBoard:(Board *)board {
    [[Game sharedInstance] setCurrentBoardInstance:board];
}

+ (Board *) currentBoard {
    return [[Game sharedInstance] currentBoardInstance];
}

+ (void) setCurrentBoardView:(BoardView *)boardView {
    [[Game sharedInstance] setCurrentBoardViewInstance:boardView];
}

+ (BoardView *) currentBoardView {
    return [[Game sharedInstance] currentBoardViewInstance];
}

- (void) addPlayer:(Player *)player {
    if ([Utils notNull:[Game currentBoard]] && [Utils notNull:player]) {
        if ([Utils notNull:player.playerID]) {
            if (![Utils notNull:[[Game sharedInstance] friendlyArray]]) {
                [[Game sharedInstance] setFriendlyArray: [[NSMutableArray alloc] init]];
            }
            
            if (![Utils notNull:[[Game sharedInstance] enemyArray]]) {
                [[Game sharedInstance] setEnemyArray: [[NSMutableArray alloc] init]];
            }
            
            if (player.type == ItemTypeEnemy) {
                BOOL found = NO;
                for (Player *tempPlayer in [[Game sharedInstance] enemyArray]) {
                    if ([Utils notNull:tempPlayer.playerID]) {
                        if ([tempPlayer.playerID isEqualToString:player.playerID]) {
                            found = YES;
                            break;
                        }
                    }
                }
                
                if (!found) {
                    [[[Game sharedInstance] enemyArray] addObject:player];
                    PlayerView *playerView = [[PlayerView alloc] initWithPlayer:player];
                    [[[Game sharedInstance] playerViewArray] addObject:playerView];
                    [[Game currentBoardView] addSubview:playerView];
                }
            }
            else if (player.type == ItemTypeFriendly) {
                BOOL found = NO;
                for (Player *tempPlayer in [[Game sharedInstance] friendlyArray]) {
                    if ([Utils notNull:tempPlayer.playerID]) {
                        if ([tempPlayer.playerID isEqualToString:player.playerID]) {
                            found = YES;
                            break;
                        }
                    }
                }
                
                if (!found) {
                    [[[Game sharedInstance] friendlyArray] addObject:player];
                    PlayerView *playerView = [[PlayerView alloc] initWithPlayer:player];
                    [[[Game sharedInstance] playerViewArray] addObject:playerView];
                    [[Game currentBoardView] addSubview:playerView];
                }
            }
        }
    }
}

- (void) removePlayer: (NSString *) playerID {
    if ([Utils notNull:[Game currentBoard]] && [Utils notNull:playerID]) {
        
        BOOL removed = NO;
        
        
        for (Player *tempPlayer in [[Game sharedInstance] friendlyArray]) {
            if ([Utils notNull:tempPlayer.playerID]) {
                if ([tempPlayer.playerID isEqualToString:playerID]) {
                    [[[Game sharedInstance] friendlyArray] removeObject:tempPlayer];
                    removed = YES;
                    break;
                }
            }
        }
        
        if (!removed) {
            for (Player *tempPlayer in [[Game sharedInstance] enemyArray]) {
                if ([Utils notNull:tempPlayer.playerID]) {
                    if ([tempPlayer.playerID isEqualToString:playerID]) {
                        [[[Game sharedInstance] enemyArray] removeObject:tempPlayer];
                        removed = YES;
                        break;
                    }
                }
            }
        }
        
        for (PlayerView *tempPlayerView in [[Game sharedInstance] playerViewArray]) {
            if ([Utils notNull:tempPlayerView.player]) {
                if ([Utils notNull:tempPlayerView.player.playerID]) {
                    if ([tempPlayerView.player.playerID isEqualToString:playerID]) {
                        [[[Game sharedInstance] playerViewArray] removeObject:tempPlayerView];
                        [tempPlayerView removeFromSuperview];
                        
                        break;
                    }
                }
            }
        }
    }
}

- (void) movePlayer:(Player *)player toPosition:(CGPoint)position {
    if ([Utils notNull:[Game currentBoard]] && [Utils notNull:player.playerID]) {
        
        if (position.x < [[Game currentBoard] width] && position.y < [[Game currentBoard] height]) {
            if ([Space canPass:position playerType:player.type]) {
                player.position = position;
                
                for (PlayerView *tempPlayerView in [[Game sharedInstance] playerViewArray]) {
                    if ([Utils notNull:tempPlayerView.player]) {
                        if ([Utils notNull:tempPlayerView.player.playerID]) {
                            if ([tempPlayerView.player.playerID isEqualToString:player.playerID]) {
                                SpaceView *tempSpaceView = [[Game currentBoardView] spaceViewForPoint:player.position];
                                tempPlayerView.center = tempSpaceView.center;
                                
                                break;
                            }
                        }
                    }
                }
            }
            
        }
        
    }
}

@end
