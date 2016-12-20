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

- (instancetype) initWithScale: (NSInteger) scale {
    self = [self init];
    
    if (self) {
        self.scale = scale;
        
        for (int row = 0; row < scale; row++) {
            NSMutableArray *rowArray = [[NSMutableArray alloc] init];
            for (int collumn = 0; collumn < scale; collumn++) {
                if (row == 0) {
                    if (collumn == 0) {
                        [rowArray addObject: [[Space alloc] initWithType:WallTypeLeftUp position:CGPointMake(collumn, row)]];
                    }
                    else if (collumn == (scale - 1)) {
                        [rowArray addObject: [[Space alloc] initWithType:WallTypeRightUp position:CGPointMake(collumn, row)]];
                    }
                    else {
                        [rowArray addObject: [[Space alloc] initWithType:WallTypeUp position:CGPointMake(collumn, row)]];
                    }
                }
                else if (row == (scale - 1)) {
                    if (collumn == 0) {
                        [rowArray addObject: [[Space alloc] initWithType:WallTypeLeftDown position:CGPointMake(collumn, row)]];
                    }
                    else if (collumn == (scale - 1)) {
                        [rowArray addObject: [[Space alloc] initWithType:WallTypeRightDown position:CGPointMake(collumn, row)]];
                    }
                    else {
                        [rowArray addObject: [[Space alloc] initWithType:WallTypeDown position:CGPointMake(collumn, row)]];
                    }
                }
                else if (collumn == 0) {
                    [rowArray addObject: [[Space alloc] initWithType:WallTypeLeft position:CGPointMake(collumn, row)]];
                }
                else if (collumn == (scale - 1)) {
                    [rowArray addObject: [[Space alloc] initWithType:WallTypeRight position:CGPointMake(collumn, row)]];
                }
                else {
                    [rowArray addObject: [[Space alloc] initWithType:WallTypeNone position:CGPointMake(collumn, row)]];
                }
            }
            
            [self.boardArray addObject:rowArray];
        }
    }
    
    return self;
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
    
    return [[Space alloc] initWithType:WallTypeNone position:point];
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
@end
