//
//  SpaceView.m
//  maze
//
//  Created by Andrew Boryk on 12/20/16.
//  Copyright © 2016 Andrew Boryk. All rights reserved.
//

#import "SpaceView.h"
#import "Space.h"
#import "Player.h"
#import "BoardView.h"
#import "Board.h"
#import "Game.h"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

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
        
        if (self.space.type == ItemTypeWall) {
            self.backgroundColor = [Utils colorWithHexString:@"141414"];
            self.layer.borderColor = [Utils colorWithHexString:@"141414"].CGColor;
        }
        else if (self.space.type == ItemTypeFriendly) {
            self.backgroundColor = [Utils colorWithHexString:@"3498db"];
            self.layer.borderColor = [Utils colorWithHexString:@"2980b9"].CGColor;
        }
        else if (self.space.type == ItemTypeEnemy) {
            self.backgroundColor = [Utils colorWithHexString:@"e74c3c"];
            self.layer.borderColor = [Utils colorWithHexString:@"c0392b"].CGColor;
        }
        else if (self.space.type == ItemTypeEmpty) {
            if (self.space.friendlyPercentage > 0) {
                
                self.backgroundColor = [Utils colorWithHexString:@"ecf0f1"];
                self.layer.borderColor = [Utils colorWithHexString:@"2980b9"].CGColor;
                if (self.space.friendlyPercentage == 1) {
                    self.space.type = ItemTypeFriendly;
                }
                else {
                    self.space.type = ItemTypeEmpty;
                }
                
            }
            else if (self.space.enemyPercentage > 0) {
                
                self.backgroundColor = [Utils colorWithHexString:@"ecf0f1"];
                self.layer.borderColor = [Utils colorWithHexString:@"c0392b"].CGColor;
                if (self.space.enemyPercentage == 1) {
                    self.space.type = ItemTypeEnemy;
                }
                else {
                    self.space.type = ItemTypeEmpty;
                }
            }
            else {
                self.backgroundColor = [Utils colorWithHexString:@"ecf0f1"];
                self.layer.borderColor = [Utils colorWithHexString:@"bdc3c7"].CGColor;
                self.space.type = ItemTypeEmpty;
            }
        }
        
//        [SpaceView adjustSpacePercentage:self];

        tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleInteraction:)];
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


- (void) handleInteraction: (UITapGestureRecognizer *) gesture {
    if (self.space.type != ItemTypeWall && !self.space.isBase) {
        double absoluteX = fabs((self.space.position.x - [Game currentPlayer].position.x));
        double absoluteY = fabs((self.space.position.y - [Game currentPlayer].position.y));
        
        if (absoluteX <= 2 && absoluteY <= 2) {
            if (!(absoluteX == 2 && absoluteY == 2)) {
                if (absoluteX == 2 || absoluteY == 2) {
                    [SpaceView adjustSpaceAtPosition:self.space.position forType:[[Game currentPlayer] type] withStrength:0.5f];
                }
                else {
                    [SpaceView adjustSpaceAtPosition:self.space.position forType:[[Game currentPlayer] type] withStrength:1.0f];
                }
                
            }
            
        }
        
    }
    
}

+ (void) handleInteractionWithSpace: (Space *)space andPlayer: (Player *)player andStrength:(float)strength {
    if (space.type != ItemTypeWall) {
        [SpaceView adjustSpaceAtPosition:space.position forType:player.type withStrength:strength];
    }
    
}

+ (void) adjustSpaceAtPosition: (CGPoint) position forType: (ItemType) playerType withStrength: (float) strength {
    SpaceView *spaceView = [[Game currentBoardView] spaceViewForPoint:position];
    
    if ([Utils notNull:spaceView]) {
        if ([Utils notNull:spaceView.space]) {
            
            NSArray *playerArray = [Game playersInSpace:spaceView.space notOfAlliance:playerType];
            if (playerArray.count) {
                for (Player *player in playerArray) {
                    [Player adjustHealthOfPlayer:player by:-(20.0f*strength)];
                }
            }
            else {
                if (playerType == ItemTypeFriendly) {
                    if (spaceView.space.enemyPercentage > 0) {
                        spaceView.space.enemyPercentage-= (0.2f * strength);
                    }
                    else if (spaceView.space.friendlyPercentage < 1) {
                        spaceView.space.friendlyPercentage+= (0.2f * strength);
                    }
                }
                else if (playerType == ItemTypeEnemy) {
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
                        spaceView.space.type = ItemTypeFriendly;
                    }
                    else {
                        spaceView.space.type = ItemTypeEmpty;
                    }
                    
                }
                else if (spaceView.space.enemyPercentage > 0) {
                    
                    spaceView.backgroundColor = [[Utils colorWithHexString:@"e74c3c"] colorWithAlphaComponent:spaceView.space.enemyPercentage];
                    spaceView.layer.borderColor = [Utils colorWithHexString:@"c0392b"].CGColor;
                    if (spaceView.space.enemyPercentage == 1) {
                        spaceView.space.type = ItemTypeEnemy;
                    }
                    else {
                        spaceView.space.type = ItemTypeEmpty;
                    }
                }
                else {
                    spaceView.backgroundColor = [Utils colorWithHexString:@"ecf0f1"];
                    spaceView.layer.borderColor = [Utils colorWithHexString:@"bdc3c7"].CGColor;
                    spaceView.space.type = ItemTypeEmpty;
                }
            }
            
            
            
//            [SpaceView adjustSpacePercentage: spaceView];
        }
    }
    
    
    if (![Utils notNull:[Game currentBoardView].spaces]) {
        [Game currentBoardView].spaces = [[NSMutableDictionary alloc] init];
    }
    
    NSString *spaceKey = [NSString stringWithFormat:@"%i:%i", (int)position.x, (int)position.y];
    
    if ([Utils notNull:spaceKey]) {
        [[Game currentBoardView].spaces setObject:spaceView forKey:spaceKey];
    }
    
    [[Game currentBoardView].board adjustSpace:spaceView.space];
    
}

+ (void) adjustSpacePercentage: (SpaceView *) spaceView {
    UIBezierPath *peekPath = [UIBezierPath bezierPath];
    [peekPath moveToPoint:CGPointMake(24, 24)];
    
    float startAngle = spaceView.space.friendlyPercentage * 360.0f;
    UIColor *fillColor = [Utils colorWithHexString:@"ecf0f1"];

    if (spaceView.space.friendlyPercentage > 0) {
        fillColor = [Utils colorWithHexString:@"3498db"];
        startAngle = spaceView.space.friendlyPercentage;
        
    }
    else if (spaceView.space.enemyPercentage > 0) {
        fillColor = [Utils colorWithHexString:@"e74c3c"];
        startAngle = spaceView.space.enemyPercentage;
    }

    
    [peekPath addArcWithCenter:CGPointMake(24, 24) radius:12 startAngle:DEGREES_TO_RADIANS(startAngle) endAngle:DEGREES_TO_RADIANS(360.0f) clockwise:YES];
    spaceView.percentageLayer = [[CAShapeLayer alloc] init];
    spaceView.percentageLayer.fillColor = fillColor.CGColor;
    spaceView.percentageLayer.path = peekPath.CGPath;
    spaceView.percentageLayer.shadowColor = [UIColor blackColor].CGColor;
    spaceView.percentageLayer.shadowOffset = CGSizeMake(0, 0);
    spaceView.percentageLayer.shadowOpacity = 1.0f;
    spaceView.percentageLayer.shadowRadius = 1.0f;
    
    if (startAngle == 0 || spaceView.space.type == ItemTypeWall) {
        spaceView.percentageLayer.hidden = YES;
        if ([spaceView.layer.sublayers containsObject:spaceView.percentageLayer]) {
            [spaceView.percentageLayer removeFromSuperlayer];
        }
    }
    else {
        spaceView.percentageLayer.hidden = NO;
        if (![spaceView.layer.sublayers containsObject:spaceView.percentageLayer]) {
            [spaceView.layer addSublayer:spaceView.percentageLayer];
        }
    }
    
    
}
- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


@end
