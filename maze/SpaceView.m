//
//  SpaceView.m
//  maze
//
//  Created by Andrew Boryk on 12/20/16.
//  Copyright © 2016 Andrew Boryk. All rights reserved.
//

#import "SpaceView.h"


@implementation SpaceView {
    
    /// Reconizes when a user taps on a space
    UITapGestureRecognizer *tapRecognizer;
    
    /// Imageview which holds the flag
    UIImageView *flagImageView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@synthesize defaultSpaceSize;

+ (id)sharedInstance {
    static SpaceView *sharedMyInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyInstance = [[self alloc] initInstance];
        
    });
    return sharedMyInstance;
}

- (instancetype) initInstance {
    self = [super init];
    
    if (self) {
        self.defaultSpaceSize = 60.0f;
    }
    
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [Appearance boardBackgroundColor];
    }
    
    return self;
}

- (instancetype) initWithSpace:(Space *)space width:(NSInteger)width height:(NSInteger)height {
//    CGFloat spaceSize = ([Utils screenWidth] / width);
    CGFloat spaceSize = [[SpaceView sharedInstance] defaultSpaceSize];
    CGFloat xPosition = (spaceSize * space.position.x);
    CGFloat yPosition = (spaceSize * space.position.y);
    
    self = [self initWithFrame:CGRectMake(xPosition, yPosition, spaceSize, spaceSize)];
    
    if (self) {
        self.space = space;
        self.width = width;
        self.height = height;
        self.size = spaceSize;
        
        self.layer.borderWidth = 0.5f;
        
        self.backgroundColor = [Utils colorWithHexString:@"ecf0f1"];
        self.layer.borderColor = [Utils colorWithHexString:@"bdc3c7"].CGColor;
        
        if (self.space.type == SpaceTypeWall) {
            self.backgroundColor = [Utils colorWithHexString:@"141414"];
            self.layer.borderColor = [Utils colorWithHexString:@"141414"].CGColor;
        }
        else if (self.space.type == SpaceTypeFriendly) {
            self.backgroundColor = [Utils colorWithHexString:@"3498db"];
            self.layer.borderColor = [Utils colorWithHexString:@"2980b9"].CGColor;
        }
        else if (self.space.type == SpaceTypeEnemy) {
            self.backgroundColor = [Utils colorWithHexString:@"e74c3c"];
            self.layer.borderColor = [Utils colorWithHexString:@"c0392b"].CGColor;
        }

        tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        tapRecognizer.numberOfTapsRequired = 1;
        tapRecognizer.numberOfTouchesRequired = 1;
        tapRecognizer.delegate = self;
        
        [self addGestureRecognizer:tapRecognizer];
        
        flagImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Flag"]];
        flagImageView.frame = CGRectMake(0, 0, 24, 24);
        flagImageView.center = CGPointMake(self.frame.size.width/2.0f, self.frame.size.height/2.0f);
        flagImageView.alpha = 0.6f;
        flagImageView.hidden = !space.isFlag;
        flagImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self addSubview:flagImageView];
//        [self maskLayerMake:self.space.type];
    }
    
    return self;
}


- (void) handleTap: (UITapGestureRecognizer *) gesture {
    if (self.space.type != SpaceTypeWall && !self.space.isBase) {
        double absoluteX = fabs((self.space.position.x - [Player currentPlayer].position.x));
        double absoluteY = fabs((self.space.position.y - [Player currentPlayer].position.y));
        
        if (absoluteX <= 2 && absoluteY <= 2) {
            if (!(absoluteX == 2 && absoluteY == 2)) {
                if (absoluteX == 2 || absoluteY == 2) {
                    [SpaceView adjustSpaceAtPosition:self.space.position forType:[[Player currentPlayer] type] inBoard:(BoardView *)self.superview withStrength:0.5f];
                }
                else {
                    [SpaceView adjustSpaceAtPosition:self.space.position forType:[[Player currentPlayer] type] inBoard:(BoardView *)self.superview withStrength:1.0f];
                }
                
            }
            
        }
        
    }
    
}

+ (void) adjustSpaceAtPosition: (CGPoint) position forType: (PlayerType) playerType inBoard: (BoardView *) boardView withStrength: (float) strength {
    SpaceView *spaceView = [boardView spaceViewForPoint:position];
    
    if ([Utils notNull:spaceView]) {
        if ([Utils notNull:spaceView.space]) {
            if (playerType == PlayerTypeFriendly) {
                if (spaceView.space.enemyPercentage > 0) {
                    spaceView.space.enemyPercentage-= (0.2f * strength);
                }
                else if (spaceView.space.friendlyPercentage < 1) {
                    spaceView.space.friendlyPercentage+= (0.2f * strength);
                }
            }
            else if (playerType == PlayerTypeEnemy) {
                if (spaceView.space.friendlyPercentage > 0) {
                    spaceView.space.friendlyPercentage-= (0.2f * strength);
                }
                else if (spaceView.space.enemyPercentage < 1) {
                    spaceView.space.enemyPercentage+= (0.2f * strength);
                }
            }
            
            if (spaceView.space.friendlyPercentage > 1) {
                spaceView.space.friendlyPercentage = 1;
            }
            else if (spaceView.space.friendlyPercentage < 0) {
                spaceView.space.friendlyPercentage = 0;
            }
            
            if (spaceView.space.enemyPercentage > 1) {
                spaceView.space.enemyPercentage = 1;
            }
            else if (spaceView.space.enemyPercentage < 0) {
                spaceView.space.enemyPercentage = 0;
            }
            
            if (spaceView.space.friendlyPercentage > 0) {
                
                spaceView.backgroundColor = [[Utils colorWithHexString:@"3498db"] colorWithAlphaComponent:spaceView.space.friendlyPercentage];
                spaceView.layer.borderColor = [Utils colorWithHexString:@"2980b9"].CGColor;
                if (spaceView.space.friendlyPercentage == 1) {
                    spaceView.space.type = SpaceTypeFriendly;
                }
                else {
                    spaceView.space.type = SpaceTypeEmpty;
                }
                
            }
            else if (spaceView.space.enemyPercentage > 0) {
                
                spaceView.backgroundColor = [[Utils colorWithHexString:@"e74c3c"] colorWithAlphaComponent:spaceView.space.enemyPercentage];
                spaceView.layer.borderColor = [Utils colorWithHexString:@"c0392b"].CGColor;
                if (spaceView.space.enemyPercentage == 1) {
                    spaceView.space.type = SpaceTypeEnemy;
                }
                else {
                    spaceView.space.type = SpaceTypeEmpty;
                }
            }
            else {
                spaceView.backgroundColor = [Utils colorWithHexString:@"ecf0f1"];
                spaceView.layer.borderColor = [Utils colorWithHexString:@"bdc3c7"].CGColor;
                spaceView.space.type = SpaceTypeEmpty;
            }
        }
    }
    
    
    if (![Utils notNull:boardView.spaces]) {
        boardView.spaces = [[NSMutableDictionary alloc] init];
    }
    
    NSString *spaceKey = [NSString stringWithFormat:@"%i:%i", (int)position.x, (int)position.y];
    
    if ([Utils notNull:spaceKey]) {
        [boardView.spaces setObject:spaceView forKey:spaceKey];
    }
    
    [boardView.board replacePoint:position withSpace:spaceView.space];
    
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


@end
