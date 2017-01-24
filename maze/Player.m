//
//  Player.m
//  maze
//
//  Created by Andrew Boryk on 12/20/16.
//  Copyright © 2016 Andrew Boryk. All rights reserved.
//

#import "Player.h"
#import "Board.h"

@implementation Player

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
     
- (instancetype) initWithType:(PlayerType) type playerID:(NSString *)playerID withPosition: (CGPoint) position {
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
    NSInteger boardWidth = [[[Board sharedInstance] currentBoard] width];
    NSInteger boardHeight = [[[Board sharedInstance] currentBoard] width];
    
    NSMutableArray *possibilityArray = [[NSMutableArray alloc] init];
    if ((position.x - 1) >= 0) {
        Space *leftSpace = [[[Board sharedInstance] currentBoard] spaceForPoint:CGPointMake(position.x-1, position.y)];
        if ([Utils notNull:leftSpace]) {
            if (leftSpace.type != SpaceTypeWall) {
                [possibilityArray addObject:leftSpace];
            }
        }
        
    }
    
    if ((position.x + 1) < boardWidth) {
        Space *rightSpace = [[[Board sharedInstance] currentBoard] spaceForPoint:CGPointMake(position.x+1, position.y)];
        if ([Utils notNull:rightSpace]) {
            if (rightSpace.type != SpaceTypeWall) {
                [possibilityArray addObject:rightSpace];
            }
        }
        
    }
    
    if ((position.y - 1) >= 0) {
        Space *upSpace = [[[Board sharedInstance] currentBoard] spaceForPoint:CGPointMake(position.x, position.y-1)];
        if ([Utils notNull:upSpace]) {
            if (upSpace.type != SpaceTypeWall) {
                [possibilityArray addObject:upSpace];
            }
        }
        
    }
    
    if ((position.y + 1) < boardHeight) {
        Space *downSpace = [[[Board sharedInstance] currentBoard] spaceForPoint:CGPointMake(position.x, position.y+1)];
        if ([Utils notNull:downSpace]) {
            if (downSpace.type != SpaceTypeWall) {
                [possibilityArray addObject:downSpace];
            }
        }
        
    }
    
    return possibilityArray;
}

- (Space *) determineBestSpaceToInteract {
    if ([self.dataSource respondsToSelector:@selector(objectiveSpaceForPlayer:)]) {
        Space *objectiveSpace = [self.dataSource objectiveSpaceForPlayer:self];
        
        if ([Utils notNull:objectiveSpace]) {
            NSArray *possibilityArray = [self determinePossibleMovementsForPlayer:self];
            
            Space *bestSpace = nil;
            
            float bestValue = 0;
            for (Space *testSpace in possibilityArray) {
                float movementValue = 1;
                if (self.type == PlayerTypeFriendly) {
                    if (testSpace.enemyPercentage > 0) {
                        movementValue = ceilf(testSpace.enemyPercentage/0.2f) + 6;
                    }
                    else {
                        movementValue = ceilf((1.0f-testSpace.friendlyPercentage)/2.0f) + 1;
                    }
                }
                else if (self.type == PlayerTypeEnemy) {
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
            
            return bestSpace;
        }
        
        
    }
    
    
    return nil;
    
}
@end













