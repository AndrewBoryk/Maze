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
        self.defaultSpaceSize = 30.0f;
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
        else if (self.space.type == SpaceTypeFriendlyHome || self.space.type == SpaceTypeCapturedFriendly || self.space.type == SpaceTypeCapturedFriendlyFlag) {
            self.backgroundColor = [Utils colorWithHexString:@"3498db"];
            self.layer.borderColor = [Utils colorWithHexString:@"2980b9"].CGColor;
        }
        else if (self.space.type == SpaceTypeEnemyHome || self.space.type == SpaceTypeCapturedEnemy || self.space.type == SpaceTypeCapturedEnemyFlag) {
            self.backgroundColor = [Utils colorWithHexString:@"e74c3c"];
            self.layer.borderColor = [Utils colorWithHexString:@"c0392b"].CGColor;
        }

        tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        tapRecognizer.numberOfTapsRequired = 1;
        tapRecognizer.numberOfTouchesRequired = 1;
        tapRecognizer.delegate = self;
        
//        [self maskLayerMake:self.space.type];
    }
    
    return self;
}

- (void) maskLayerMake: (WallType) maskType{
    UIBezierPath *maskPath;
    
    CGFloat cornerRadius = (self.size * 0.1f) / 2.0f;
    
    if (maskType == WallTypeLeftUp) {
        maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                         byRoundingCorners:(UIRectCornerTopLeft)
                                               cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    }
    else if (maskType == WallTypeLeftDown) {
        maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                         byRoundingCorners:(UIRectCornerBottomLeft)
                                               cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    }
    else if (maskType == WallTypeLeftUpDown) {
        maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                         byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerTopLeft)
                                               cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    }
    else if (maskType == WallTypeRightUp) {
        maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                         byRoundingCorners:(UIRectCornerTopRight)
                                               cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    }
    else if (maskType == WallTypeRightDown) {
        maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                         byRoundingCorners:(UIRectCornerBottomRight)
                                               cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    }
    else if (maskType == WallTypeRightUpDown) {
        maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                         byRoundingCorners:(UIRectCornerBottomRight|UIRectCornerTopRight)
                                               cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    }
    else if (maskType == WallTypeLeftRightUp) {
        maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                         byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight)
                                               cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    }
    else if (maskType == WallTypeLeftRightDown) {
        maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                         byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight)
                                               cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    }
    else if (maskType == WallTypeLeftRightUpDown) {
        maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                         byRoundingCorners:(UIRectCornerAllCorners)
                                               cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    }
    else {
        maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                         byRoundingCorners:(UIRectCornerAllCorners)
                                               cornerRadii:CGSizeMake(0.0, 0.0)];
    }
    
    
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void) handleTap: (UITapGestureRecognizer *) gesture {
    
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
@end
