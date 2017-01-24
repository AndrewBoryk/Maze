//
//  Board.m
//  maze
//
//  Created by Andrew Boryk on 12/20/16.
//  Copyright © 2016 Andrew Boryk. All rights reserved.
//

#import "Board.h"

@implementation Board

- (instancetype) init {
    self = [super init];
    
    if (self) {
        self.boardArray = [[NSMutableArray alloc] init];
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

- (BOOL) replacePoint:(CGPoint)point withType:(SpaceType)type {
    
    if (point.x < self.width && point.y < self.height) {
        if (point.y < self.boardArray.count) {
            NSMutableArray *rowArray = [[self.boardArray objectAtIndex:point.y] mutableCopy];
            if (point.x < rowArray.count) {
                Space *space = [[Space alloc] initWithType:type position:point];
                [rowArray setObject:space atIndexedSubscript:point.x];
                [self.boardArray setObject:rowArray atIndexedSubscript:point.y];
                return YES;
            }
        }
    }
    
    return NO;
}
@end
