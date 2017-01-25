//
//  Player.m
//  maze
//
//  Created by Andrew Boryk on 12/20/16.
//  Copyright © 2016 Andrew Boryk. All rights reserved.
//

#import "Player.h"
#import "Board.h"
#import "BoardView.h"
#import "SpaceView.h"
#import "Game.h"
#import "Space.h"

@implementation Player {
    
    /// Timer for AI movements
    NSTimer *artificialIntelligenceTimer;
}
     
- (instancetype) initWithType:(ItemType) type playerID:(NSString *)playerID withPosition: (CGPoint) position andPlayerNumber: (int)playerNumber {
    self = [super init];
    
    if (self) {
        self.playerID = playerID;
        self.type = type;
        self.playerNumber = playerNumber;
        Space *homeSpace = [Game homeForPlayer:self];
        if ([Utils notNull:homeSpace]) {
            self.position = homeSpace.position;
        }
        else {
            self.position = position;
        }
        
        self.state = StateAttacking;
        self.health = 100.0f;
    }
    
    return self;
}

- (NSArray *) determinePossibleMovementsForPlayer: (Player *)player {
    CGPoint position = player.position;
    NSInteger boardWidth = [[Game currentBoard] width];
    NSInteger boardHeight = [[Game currentBoard] width];
    
    NSMutableArray *possibilityArray = [[NSMutableArray alloc] init];
    if ((position.x - 1) >= 0) {
        Space *leftSpace = [[Game currentBoard] spaceForPoint:CGPointMake(position.x-1, position.y)];
        if ([Utils notNull:leftSpace]) {
            if (leftSpace.type != ItemTypeWall && [self isNotEnemyBase:leftSpace player:player]) {
                [possibilityArray addObject:leftSpace];
            }
        }
        
    }
    
    if ((position.x + 1) < boardWidth) {
        Space *rightSpace = [[Game currentBoard] spaceForPoint:CGPointMake(position.x+1, position.y)];
        if ([Utils notNull:rightSpace]) {
            if (rightSpace.type != ItemTypeWall && [self isNotEnemyBase:rightSpace player:player]) {
                [possibilityArray addObject:rightSpace];
            }
        }
        
    }
    
    if ((position.y - 1) >= 0) {
        Space *upSpace = [[Game currentBoard] spaceForPoint:CGPointMake(position.x, position.y-1)];
        if ([Utils notNull:upSpace]) {
            if (upSpace.type != ItemTypeWall && [self isNotEnemyBase:upSpace player:player]) {
                [possibilityArray addObject:upSpace];
            }
        }
        
    }
    
    if ((position.y + 1) < boardHeight) {
        Space *downSpace = [[Game currentBoard] spaceForPoint:CGPointMake(position.x, position.y+1)];
        if ([Utils notNull:downSpace]) {
            if (downSpace.type != ItemTypeWall && [self isNotEnemyBase:downSpace player:player]) {
                [possibilityArray addObject:downSpace];
            }
        }
        
    }
    
    return possibilityArray;
}

- (BOOL) isNotEnemyBase: (Space *)space player:(Player *)player {
    if (space.isBase) {
        if (player.type != space.type) {
            return NO;
        }
    }
    
    return YES;
}

- (Space *) determineBestSpaceToInteract {
    if ([self respondsToSelector:@selector(determineDestinationForPlayer:)]) {
        Space *objectiveSpace = [self determineDestinationForPlayer:self];
        
        if ([Utils notNull:objectiveSpace]) {
            NSArray *possibilityArray = [self determinePossibleMovementsForPlayer:self];
            
            Space *bestSpace = nil;
            
            float bestValue = 0;
            for (Space *testSpace in possibilityArray) {
                
                if ([[Game playersInSpace:testSpace notOfAlliance:self.type] count]) {
                    return testSpace;
                }
                else if (testSpace.isFlag && testSpace.type != self.type) {
                    return testSpace;
                }
                else {
                    float movementValue = 1;
                    if (self.type == ItemTypeFriendly) {
                        if (testSpace.enemyPercentage > 0) {
                            movementValue = testSpace.enemyPercentage + 1;
                        }
                        else {
                            movementValue = (1.0f-testSpace.friendlyPercentage) + 1;
                        }
                    }
                    else if (self.type == ItemTypeEnemy) {
                        if (testSpace.friendlyPercentage > 0) {
                            movementValue = testSpace.friendlyPercentage + 1;
                        }
                        else {
                            movementValue = (1.0f-testSpace.enemyPercentage) + 1;
                        }
                    }
                    
                    int distanceValue = abs((int)objectiveSpace.position.x - (int)testSpace.position.x) + abs((int)objectiveSpace.position.y - (int)testSpace.position.y);
                    
                    float testValue = movementValue + distanceValue;
                    
                    if (![Utils notNull:bestSpace]) {
                        bestSpace = testSpace;
                        bestValue = testValue;
                    }
                    else {
                        if (testValue < bestValue) {
                            bestSpace = testSpace;
                            bestValue = testValue;
                        }
                    }
                }
                
            }
            
            return bestSpace;
        }
        
        
    }
    
    
    return nil;
    
}

- (Space *) determineDestinationForPlayer: (Player *)player {
    int distanceObjectiveOne = 0;
    int distanceObjectiveTwo = 0;
    int distanceObjectiveThree = 0;
    
    if ([Utils notNull:[[Game currentBoardView] flagOne]]) {
        if ([[Game currentBoardView] flagOne].space.type != player.type) {
            Space *objectiveSpace = [[Game currentBoardView] flagOne].space;
            distanceObjectiveOne = abs((int)objectiveSpace.position.x - (int)player.position.x) + abs((int)objectiveSpace.position.y - (int)player.position.y);
        }
    }
    
    if ([Utils notNull:[[Game currentBoardView] flagTwo]]) {
        if ([[Game currentBoardView] flagTwo].space.type != player.type) {
            Space *objectiveSpace = [[Game currentBoardView] flagTwo].space;
            distanceObjectiveTwo = abs((int)objectiveSpace.position.x - (int)player.position.x) + abs((int)objectiveSpace.position.y - (int)player.position.y);
        }
    }
    
    
    if ([Utils notNull:[[Game currentBoardView] flagThree]]) {
        if ([[Game currentBoardView] flagThree].space.type != player.type) {
            Space *objectiveSpace = [[Game currentBoardView] flagThree].space;
            distanceObjectiveThree = abs((int)objectiveSpace.position.x - (int)player.position.x) + abs((int)objectiveSpace.position.y - (int)player.position.y);
        }
    }
    
    
    if (distanceObjectiveOne != 0) {
        if (distanceObjectiveTwo < distanceObjectiveOne && distanceObjectiveTwo != 0) {
            if (distanceObjectiveThree < distanceObjectiveTwo && distanceObjectiveThree != 0) {
                return [[Game currentBoardView] flagThree].space;
            }
            else {
                return [[Game currentBoardView] flagTwo].space;
            }
        }
        else if (distanceObjectiveThree < distanceObjectiveOne && distanceObjectiveThree != 0) {
            return [[Game currentBoardView] flagThree].space;
        }
        else {
            return [[Game currentBoardView] flagOne].space;
        }
    }
    else if (distanceObjectiveTwo != 0) {
        if (distanceObjectiveThree < distanceObjectiveTwo && distanceObjectiveThree != 0) {
            return [[Game currentBoardView] flagThree].space;
        }
        else {
            return [[Game currentBoardView] flagTwo].space;
        }
    }
    else if (distanceObjectiveThree != 0) {
        return [[Game currentBoardView] flagThree].space;
    }
    
    return nil;
}

- (void) startAIMovements {
    [artificialIntelligenceTimer invalidate];
    
    artificialIntelligenceTimer = [NSTimer scheduledTimerWithTimeInterval:0.25f target:self selector:@selector(performAIMovements) userInfo:nil repeats:YES];
}

- (void) endAIMovements {
    [artificialIntelligenceTimer invalidate];
}

- (void) performAIMovements {
    Space *interactionSpace = [self determineBestSpaceToInteract];
    
    if (interactionSpace.type == self.type) {
        [UIView animateWithDuration:0.2f animations:^{
            [[Game sharedInstance] movePlayer:self toPosition:interactionSpace.position];
        } completion:^(BOOL finished) {
            if ([self.delegate respondsToSelector:@selector(didMoveAIPlayer:)]) {
                [self.delegate didMoveAIPlayer: self];
            }
        }];
    }
    else if (interactionSpace.type != ItemTypeWall) {
        [SpaceView handleInteractionWithSpace:interactionSpace andPlayer:self andStrength:1.0f];
    }
}

+ (void) adjustHealthOfPlayer:(Player *)player by:(float) healthAdjustment {
    player.health+= healthAdjustment;
    
    PlayerView *playerView = [Game playerViewForPlayer:player];
    
    [UIView animateWithDuration:0.1f animations:^{
        playerView.alpha = player.health/100.0f;
    }];
    
    if (player.health <= 0) {
        [[Game sharedInstance] removePlayer:player];
        player.health = 100.0f;
        
        Space *homeSpace = [Game homeForPlayer:player];
        if ([Utils notNull:homeSpace]) {
            player.position = homeSpace.position;
        }
        else {
            if (player.type == ItemTypeFriendly) {
                player.position = CGPointMake([Game currentBoard].width / 2 + 2, [Game currentBoard].height- 1);
            }
            else if (player.type == ItemTypeEnemy) {
                player.position = CGPointMake([Game currentBoard].width / 2 + 2, 1);
            }
        }
        
        [[Game sharedInstance] addPlayer:player];
        
        if ([player.delegate respondsToSelector:@selector(didMoveAIPlayer:)]) {
            [player.delegate didMoveAIPlayer:player];
        }
    }
    else {
        playerView.player = player;
    }
}
@end













