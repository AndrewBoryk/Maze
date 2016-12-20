//
//  SpaceView.m
//  maze
//
//  Created by Andrew Boryk on 12/20/16.
//  Copyright © 2016 Andrew Boryk. All rights reserved.
//

#import "SpaceView.h"

@implementation SpaceView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [Appearance boardBackgroundColor];
//        self.clipsToBounds = YES;
        
        self.leftWall = [[WallView alloc] initWithSide:DirectionLeft size:frame.size.width];
        self.rightWall = [[WallView alloc] initWithSide:DirectionRight size:frame.size.width];
        self.upWall = [[WallView alloc] initWithSide:DirectionUp size:frame.size.width];
        self.downWall = [[WallView alloc] initWithSide:DirectionDown size:frame.size.width];
        
        [self addSubview: self.leftWall];
        [self addSubview: self.rightWall];
        [self addSubview: self.upWall];
        [self addSubview: self.downWall];
    }
    
    return self;
}

- (instancetype) initWithSpace:(Space *)space scale:(NSInteger)scale {
    CGFloat spaceSize = (([Utils screenWidth] - 80.0f) / scale);
    CGFloat xPosition = (spaceSize * space.position.x);
    CGFloat yPosition = (spaceSize * space.position.y);
    
    self = [self initWithFrame:CGRectMake(xPosition, yPosition, spaceSize, spaceSize)];
    
    if (self) {
        self.space = space;
        self.scale = scale;
        self.size = spaceSize;
        
        [self.leftWall setWallVisible:self.space.leftSide];
        [self.rightWall setWallVisible:self.space.rightSide];
        [self.upWall setWallVisible:self.space.upSide];
        [self.downWall setWallVisible:self.space.downSide];
        
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
@end
