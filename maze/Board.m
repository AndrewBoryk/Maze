//
//  Board.m
//  maze
//
//  Created by Andrew Boryk on 12/20/16.
//  Copyright © 2016 Andrew Boryk. All rights reserved.
//

#import "Board.h"
#import "SpaceView.h"
@implementation Board

- (instancetype) init {
    self = [super init];
    
    if (self) {
        self.boardArray = [[NSMutableArray alloc] init];
        self.playerArray = [[NSMutableArray alloc] init];
        self.playerViewArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (instancetype) initWithWidth: (NSInteger) width height:(NSInteger) height {
    self = [self init];
    
    if (self) {
        self.width = width;
        self.height = height;
        
        [self initBoardArray];
    }
    
    return self;
}

- (instancetype) initWithScale: (NSInteger) scale {
    self = [self init];
    
    if (self) {
        self.width = scale;
        self.height = scale;
        
        [self initBoardArray];
    }
    
    return self;
}

- (void) initBoardArray {
    for (int row = 0; row < self.height; row++) {
        NSMutableArray *rowArray = [[NSMutableArray alloc] init];
        for (int collumn = 0; collumn < self.width; collumn++) {
            if (row == 0) {
                if (collumn == 0) {
                    [rowArray addObject: [[Space alloc] initWithType:SpaceTypeWall position:CGPointMake(collumn, row)]];
                }
                else if (collumn == (self.width - 1)) {
                    [rowArray addObject: [[Space alloc] initWithType:SpaceTypeWall position:CGPointMake(collumn, row)]];
                }
                else {
                    [rowArray addObject: [[Space alloc] initWithType:SpaceTypeWall position:CGPointMake(collumn, row)]];
                }
            }
            else if (row == (self.height - 1)) {
                if (collumn == 0) {
                    [rowArray addObject: [[Space alloc] initWithType:SpaceTypeWall position:CGPointMake(collumn, row)]];
                }
                else if (collumn == (self.width - 1)) {
                    [rowArray addObject: [[Space alloc] initWithType:SpaceTypeWall position:CGPointMake(collumn, row)]];
                }
                else {
                    [rowArray addObject: [[Space alloc] initWithType:SpaceTypeWall position:CGPointMake(collumn, row)]];
                }
            }
            else if (collumn == 0) {
                [rowArray addObject: [[Space alloc] initWithType:SpaceTypeWall position:CGPointMake(collumn, row)]];
            }
            else if (collumn == (self.width - 1)) {
                [rowArray addObject: [[Space alloc] initWithType:SpaceTypeWall position:CGPointMake(collumn, row)]];
            }
            else {
                [rowArray addObject: [[Space alloc] initWithType:SpaceTypeEmpty position:CGPointMake(collumn, row)]];
            }
        }
        
        [self.boardArray addObject:rowArray];
    }
}

- (Space *) spaceForPoint: (CGPoint) point {
    
    if ([Utils notNull:self.boardArray]) {
        if (point.y < self.boardArray.count) {
            if ([Utils notNull:[self.boardArray objectAtIndex:point.y]] && [[self.boardArray objectAtIndex:point.y] isKindOfClass: [NSArray class]]) {
                NSArray *rowArray = [self.boardArray objectAtIndex:point.y];
                
                if (point.x < rowArray.count) {
                    if ([Utils notNull:[rowArray objectAtIndex:point.x]] && [[rowArray objectAtIndex:point.x] isKindOfClass: [Space class]]) {
                        Space *space = [rowArray objectAtIndex:point.x];
                        
                        return space;
                    }
                }
            }
        }
    }
    
    return [[Space alloc] initWithType:SpaceTypeEmpty position:point];
}

- (NSNumber *) numberForPoint: (CGPoint) point {
    
    Space *space = [self spaceForPoint:point];
    
    if (!isnan(space.type)) {
        NSNumber *wallNumber = [NSNumber numberWithInteger:space.type];
        return wallNumber;
    }
    
    return @15;
}

- (WallType) wallForPoint: (CGPoint) point {
    NSNumber *wallNumber = [self numberForPoint: point];
    
    return wallNumber.integerValue;
}

- (BOOL) adjustSpace:(Space *)space {
    
    if ([Utils notNull:space]) {
        if (space.position.x < self.width && space.position.y < self.height) {
            if (space.position.y < self.boardArray.count) {
                NSMutableArray *rowArray = [[self.boardArray objectAtIndex:space.position.y] mutableCopy];
                if (space.position.x < rowArray.count) {
                    [rowArray setObject:space atIndexedSubscript:space.position.x];
                    [self.boardArray setObject:rowArray atIndexedSubscript:space.position.y];
                    
                    [self checkAdjustedObjective: space];
                    
                    
                    
                    return YES;
                }
            }
        }
    }
    
    return NO;
}

- (BOOL) replacePoint:(CGPoint)point withType:(SpaceType)type {
    
    if (point.x < self.width && point.y < self.height) {
        if (point.y < self.boardArray.count) {
            NSMutableArray *rowArray = [[self.boardArray objectAtIndex:point.y] mutableCopy];
            if (point.x < rowArray.count) {
                Space *space = [[Space alloc] initWithType:type position:point];
                [rowArray setObject:space atIndexedSubscript:point.x];
                [self.boardArray setObject:rowArray atIndexedSubscript:point.y];
                [[BoardView currentBoardView] replaceSpace:space];
                [self checkAdjustedObjective: space];
                return YES;
            }
        }
    }
    
    return NO;
}

- (BOOL) replacePoint:(CGPoint)point withSpace:(Space *)space {
    
    if (point.x < self.width && point.y < self.height && [Utils notNull:space]) {
        if (point.y < self.boardArray.count) {
            NSMutableArray *rowArray = [[self.boardArray objectAtIndex:point.y] mutableCopy];
            if (point.x < rowArray.count) {
                [rowArray setObject:space atIndexedSubscript:point.x];
                [self.boardArray setObject:rowArray atIndexedSubscript:point.y];
                [[BoardView currentBoardView] replaceSpace:space];
                [self checkAdjustedObjective: space];
                return YES;
            }
        }
    }
    
    return NO;
}

- (void) printBoard {
    [Utils printString:@"Board:"];
    for (int y = 0; y < self.height; y++) {
        NSString *rowString = @"";
        for (int x = 0; x < self.width; x++) {
            rowString = [NSString stringWithFormat:@"%@ %@", rowString, [self numberForPoint:CGPointMake(x, y)]];
        }
        
        [Utils printString:rowString];
    }
    [Utils printString:@"-------"];
}



+ (id)sharedInstance {
    static Board *sharedMyInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyInstance = [[self alloc] init];
        
    });
    return sharedMyInstance;
}

+ (void) setCurrentBoard:(Board *)board {
    [[Board sharedInstance] setCurrentBoardInstance:board];
}

+ (Board *) currentBoard {
    return [[Board sharedInstance] currentBoardInstance];
}

- (void) checkAdjustedObjective: (Space *) space {
    if (space.isFlag) {
        if ([Utils notNull:[BoardView currentBoardView]]) {
            if ([Utils notNull:[[BoardView currentBoardView] flagOne]]) {
                if ([Utils notNull:[[[BoardView currentBoardView] flagOne] space]]) {
                    if ([[[[BoardView currentBoardView] flagOne] space] position].x == space.position.x && [[[[BoardView currentBoardView] flagOne] space] position].y == space.position.y) {
                        if ([[[BoardView currentBoardView] delegate] respondsToSelector:@selector(adjustedObjective:withSpaceView:)]) {
                            [[[BoardView currentBoardView] delegate] adjustedObjective:1 withSpaceView:[[BoardView currentBoardView] flagOne]];
                        }
                    }
                }
            }
            
            if ([Utils notNull:[[BoardView currentBoardView] flagTwo]]) {
                if ([Utils notNull:[[[BoardView currentBoardView] flagTwo] space]]) {
                    if ([[[[BoardView currentBoardView] flagTwo] space] position].x == space.position.x && [[[[BoardView currentBoardView] flagTwo] space] position].y == space.position.y) {
                        if ([[[BoardView currentBoardView] delegate] respondsToSelector:@selector(adjustedObjective:withSpaceView:)]) {
                            [[[BoardView currentBoardView] delegate] adjustedObjective:2 withSpaceView:[[BoardView currentBoardView] flagTwo]];
                        }
                    }
                }
            }
            
            
            if ([Utils notNull:[[BoardView currentBoardView] flagThree]]) {
                if ([Utils notNull:[[[BoardView currentBoardView] flagThree] space]]) {
                    if ([[[[BoardView currentBoardView] flagThree] space] position].x == space.position.x && [[[[BoardView currentBoardView] flagThree] space] position].y == space.position.y) {
                        if ([[[BoardView currentBoardView] delegate] respondsToSelector:@selector(adjustedObjective:withSpaceView:)]) {
                            [[[BoardView currentBoardView] delegate] adjustedObjective:3 withSpaceView:[[BoardView currentBoardView] flagThree]];
                        }
                    }
                }
            }
        }

    }
}
@end
