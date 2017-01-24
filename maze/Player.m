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


@implementation Player {
    
    /// Timer for AI movements
    NSTimer *artificialIntelligenceTimer;
}

+ (id)sharedInstance {
    static Player *sharedMyInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyInstance = [[self alloc] init];
        
    });
    return sharedMyInstance;
}

+ (void) setCurrentPlayer: (Player *) player{
    [[Player sharedInstance] setCurrentPlayerInstance:player];
}

+ (Player *) currentPlayer {
    return [[Player sharedInstance] currentPlayerInstance];
}
     
- (instancetype) initWithType:(ItemType) type playerID:(NSString *)playerID withPosition: (CGPoint) position {
    self = [super init];
    
    if (self) {
        self.playerID = playerID;
        self.type = type;
        self.position = position;
    }
    
    return self;
}

- (NSArray *) determinePossibleMovementsForPlayer: (Player *)player {
    CGPoint position = player.position;
    NSInteger boardWidth = [[Board currentBoard] width];
    NSInteger boardHeight = [[Board currentBoard] width];
    
    NSMutableArray *possibilityArray = [[NSMutableArray alloc] init];
    if ((position.x - 1) >= 0) {
        Space *leftSpace = [[Board currentBoard] spaceForPoint:CGPointMake(position.x-1, position.y)];
        if ([Utils notNull:leftSpace]) {
            if (leftSpace.type != ItemTypeWall && [self isNotEnemyBase:leftSpace player:player]) {
                [possibilityArray addObject:leftSpace];
            }
        }
        
    }
    
    if ((position.x + 1) < boardWidth) {
        Space *rightSpace = [[Board currentBoard] spaceForPoint:CGPointMake(position.x+1, position.y)];
        if ([Utils notNull:rightSpace]) {
            if (rightSpace.type != ItemTypeWall && [self isNotEnemyBase:rightSpace player:player]) {
                [possibilityArray addObject:rightSpace];
            }
        }
        
    }
    
    if ((position.y - 1) >= 0) {
        Space *upSpace = [[Board currentBoard] spaceForPoint:CGPointMake(position.x, position.y-1)];
        if ([Utils notNull:upSpace]) {
            if (upSpace.type != ItemTypeWall && [self isNotEnemyBase:upSpace player:player]) {
                [possibilityArray addObject:upSpace];
            }
        }
        
    }
    
    if ((position.y + 1) < boardHeight) {
        Space *downSpace = [[Board currentBoard] spaceForPoint:CGPointMake(position.x, position.y+1)];
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
    if ([self respondsToSelector:@selector(determineDesitnationForPlayer:)]) {
        Space *objectiveSpace = [self determineDesitnationForPlayer:self];
        
        if ([Utils notNull:objectiveSpace]) {
            NSArray *possibilityArray = [self determinePossibleMovementsForPlayer:self];
            
            Space *bestSpace = nil;
            
            float bestValue = 0;
            for (Space *testSpace in possibilityArray) {
                
                if (testSpace.isFlag && testSpace.type != self.type) {
                    return testSpace;
                }
                else {
                    float movementValue = 1;
                    if (self.type == ItemTypeFriendly) {
                        if (testSpace.enemyPercentage > 0) {
                            movementValue = ceilf(testSpace.enemyPercentage/0.2f) + 6;
                        }
                        else {
                            movementValue = ceilf((1.0f-testSpace.friendlyPercentage)/2.0f) + 1;
                        }
                    }
                    else if (self.type == ItemTypeEnemy) {
                        if (testSpace.friendlyPercentage > 0) {
                            movementValue = ceilf(testSpace.friendlyPercentage/0.2f) + 6;
                        }
                        else {
                            movementValue = ceilf((1.0f-testSpace.enemyPercentage)/2.0f) + 1;
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

- (Space *) determineDesitnationForPlayer: (Player *)player {
    int distanceObjectiveOne = 0;
    int distanceObjectiveTwo = 0;
    int distanceObjectiveThree = 0;
    
    if ([Utils notNull:[[BoardView currentBoardView] flagOne]]) {
        if ([[BoardView currentBoardView] flagOne].space.type != player.type) {
            Space *objectiveSpace = [[BoardView currentBoardView] flagOne].space;
            distanceObjectiveOne = abs((int)objectiveSpace.position.x - (int)player.position.x) + abs((int)objectiveSpace.position.y - (int)player.position.y);
        }
    }
    
    if ([Utils notNull:[[BoardView currentBoardView] flagTwo]]) {
        if ([[BoardView currentBoardView] flagTwo].space.type != player.type) {
            Space *objectiveSpace = [[BoardView currentBoardView] flagTwo].space;
            distanceObjectiveTwo = abs((int)objectiveSpace.position.x - (int)player.position.x) + abs((int)objectiveSpace.position.y - (int)player.position.y);
        }
    }
    
    
    if ([Utils notNull:[[BoardView currentBoardView] flagThree]]) {
        if ([[BoardView currentBoardView] flagThree].space.type != player.type) {
            Space *objectiveSpace = [[BoardView currentBoardView] flagThree].space;
            distanceObjectiveThree = abs((int)objectiveSpace.position.x - (int)player.position.x) + abs((int)objectiveSpace.position.y - (int)player.position.y);
        }
    }
    
    
    if (distanceObjectiveOne != 0) {
        if (distanceObjectiveTwo < distanceObjectiveOne && distanceObjectiveTwo != 0) {
            if (distanceObjectiveThree < distanceObjectiveTwo && distanceObjectiveThree != 0) {
                return [[BoardView currentBoardView] flagThree].space;
            }
            else {
                return [[BoardView currentBoardView] flagTwo].space;
            }
        }
        else if (distanceObjectiveThree < distanceObjectiveOne && distanceObjectiveThree != 0) {
            return [[BoardView currentBoardView] flagThree].space;
        }
        else {
            return [[BoardView currentBoardView] flagOne].space;
        }
    }
    else if (distanceObjectiveTwo != 0) {
        if (distanceObjectiveThree < distanceObjectiveTwo && distanceObjectiveThree != 0) {
            return [[BoardView currentBoardView] flagThree].space;
        }
        else {
            return [[BoardView currentBoardView] flagTwo].space;
        }
    }
    else if (distanceObjectiveThree != 0) {
        return [[BoardView currentBoardView] flagThree].space;
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
            [[BoardView currentBoardView] movePlayer:self toPosition:interactionSpace.position];
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

@end













