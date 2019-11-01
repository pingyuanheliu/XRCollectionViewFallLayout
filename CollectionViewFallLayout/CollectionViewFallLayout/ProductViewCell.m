//
//  ProductViewCell.m
//  CollectionViewFallLayout
//
//  Created by LL on 2019/11/1.
//  Copyright © 2019 LL. All rights reserved.
//

#import "ProductViewCell.h"

@interface ProductViewCell ()

@property (nonatomic, strong) ProductModel *cellModel;
//视图是否包含标签
@property (nonatomic, assign) BOOL containTag;
@property (nonatomic, strong) UIImageView *iconImgV;//图片
@property (nonatomic, strong) UILabel *labTag;//标签
@property (nonatomic, strong) UILabel *labTitle;//标题
@property (nonatomic, strong) UILabel *labIntro;//简介
@property (nonatomic, strong) UILabel *labPrice;//价格
@property (nonatomic, strong) UILabel *labLevel;//权益等级
@property (nonatomic, strong) UILabel *labCostPrice;//原价
@property (nonatomic, strong) UILabel *labSales;//销量

@end

@implementation ProductViewCell

#pragma mark - Life Cycle
- (void)dealloc
{
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

#pragma mark - Draw Rect

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self customView];
}

#pragma mark - View

- (void)customView {
    self.layer.cornerRadius = 3.0;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [[UIColor colorWithRed:0xE0/255.0 green:0xE0/255.0 blue:0xE0/255.0 alpha:1.0] CGColor];
    NSArray *hContraints;
    NSArray *vContraints;
    NSString *hFormat;
    NSString *vFormat;
    NSDictionary<NSString *, id> *vViews;
    NSLayoutConstraint *equalWH;
    //
    [self.contentView addSubview:self.iconImgV];
    hContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_iconImgV]-10-|"
                                                          options:0
                                                          metrics:nil
                                                            views:NSDictionaryOfVariableBindings(_iconImgV)];
    vContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_iconImgV]"
                                                          options:0
                                                          metrics:nil
                                                            views:NSDictionaryOfVariableBindings(_iconImgV)];
    equalWH = [NSLayoutConstraint constraintWithItem:_iconImgV
                                           attribute:NSLayoutAttributeHeight
                                           relatedBy:NSLayoutRelationEqual
                                              toItem:_iconImgV
                                           attribute:NSLayoutAttributeWidth
                                          multiplier:1.0
                                            constant:0];
    [self.contentView addConstraint:equalWH];
    [self.contentView addConstraints:hContraints];
    [self.contentView addConstraints:vContraints];
    //
    self.labTitle.text = self.cellModel.title;
    //
    if (self.cellModel.tag) {
        //
        self.labTag.text = @"限量";
        [self.contentView addSubview:self.labTag];
        hContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_labTag]"
                                                              options:0
                                                              metrics:nil
                                                                views:NSDictionaryOfVariableBindings(_labTag)];
        vContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_iconImgV]-10-[_labTag(==16)]"
                                                              options:0
                                                              metrics:nil
                                                                views:NSDictionaryOfVariableBindings(_iconImgV,_labTag)];
        [self.contentView addConstraints:hContraints];
        [self.contentView addConstraints:vContraints];
        //
        UIView *bgV = [[UIView alloc] initWithFrame:CGRectZero];
        bgV.backgroundColor = [UIColor orangeColor];
        bgV.translatesAutoresizingMaskIntoConstraints = NO;
        bgV.layer.cornerRadius = 2.0;
        [self.contentView addSubview:bgV];
        hContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[bgV]"
                                                              options:0
                                                              metrics:nil
                                                                views:NSDictionaryOfVariableBindings(bgV)];
        vContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_iconImgV]-10-[bgV(==16)]"
                                                              options:0
                                                              metrics:nil
                                                                views:NSDictionaryOfVariableBindings(_iconImgV,bgV)];
        NSLayoutConstraint *equalW;
        equalW = [NSLayoutConstraint constraintWithItem:bgV
                                              attribute:NSLayoutAttributeWidth
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:_labTag
                                              attribute:NSLayoutAttributeWidth
                                             multiplier:1.0
                                               constant:10];
        [self.contentView addConstraint:equalW];
        [self.contentView addConstraints:hContraints];
        [self.contentView addConstraints:vContraints];
        [self.contentView sendSubviewToBack:bgV];
        //
        hFormat = @"H:|-10-[_labTitle]-10-|";
        vFormat = @"V:[_labTag]-10-[_labTitle]";
        vViews = NSDictionaryOfVariableBindings(_labTag,_labTitle);
    }else {
        hFormat = @"H:|-10-[_labTitle]-10-|";
        vFormat = @"V:[_iconImgV]-10-[_labTitle]";
        vViews = NSDictionaryOfVariableBindings(_iconImgV,_labTitle);
    }
    //标题
    [self.contentView addSubview:self.labTitle];
    hContraints = [NSLayoutConstraint constraintsWithVisualFormat:hFormat
                                                          options:0
                                                          metrics:nil
                                                            views:NSDictionaryOfVariableBindings(_labTitle)];
    vContraints = [NSLayoutConstraint constraintsWithVisualFormat:vFormat
                                                          options:0
                                                          metrics:nil
                                                            views:vViews];
    [self.contentView addConstraints:hContraints];
    [self.contentView addConstraints:vContraints];
    //简介
    self.labIntro.text = self.cellModel.intro;
    [self.contentView addSubview:self.labIntro];
    hContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_labIntro]-10-|"
                                                          options:0
                                                          metrics:nil
                                                            views:NSDictionaryOfVariableBindings(_labIntro)];
    vContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_labTitle]-10-[_labIntro]"
                                                          options:0
                                                          metrics:nil
                                                            views:NSDictionaryOfVariableBindings(_labTitle,_labIntro)];
    [self.contentView addConstraints:hContraints];
    [self.contentView addConstraints:vContraints];
    //原价
    self.labCostPrice.text = self.cellModel.costPrice;
    [self.contentView addSubview:self.labCostPrice];
    hContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_labCostPrice]"
                                                          options:0
                                                          metrics:nil
                                                            views:NSDictionaryOfVariableBindings(_labCostPrice)];
    vContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_labCostPrice(==15)]-10-|"
                                                          options:0
                                                          metrics:nil
                                                            views:NSDictionaryOfVariableBindings(_labCostPrice)];
    equalWH = [NSLayoutConstraint constraintWithItem:_labCostPrice
                                           attribute:NSLayoutAttributeWidth
                                           relatedBy:NSLayoutRelationEqual
                                              toItem:self
                                           attribute:NSLayoutAttributeWidth
                                          multiplier:0.5
                                            constant:-10];
    [self.contentView addConstraints:hContraints];
    [self.contentView addConstraints:vContraints];
    //销量
    self.labSales.text = self.cellModel.sales;
    [self.contentView addSubview:self.labSales];
    hContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_labSales]-10-|"
                                                          options:0
                                                          metrics:nil
                                                            views:NSDictionaryOfVariableBindings(_labSales)];
    vContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_labSales(==15)]-10-|"
                                                          options:0
                                                          metrics:nil
                                                            views:NSDictionaryOfVariableBindings(_labSales)];
    equalWH = [NSLayoutConstraint constraintWithItem:_labSales
                                           attribute:NSLayoutAttributeWidth
                                           relatedBy:NSLayoutRelationEqual
                                              toItem:self
                                           attribute:NSLayoutAttributeWidth
                                          multiplier:0.5
                                            constant:-10];
    [self.contentView addConstraints:hContraints];
    [self.contentView addConstraints:vContraints];
    //价格
    self.labPrice.text = self.cellModel.price;
    [self.contentView addSubview:self.labPrice];
    hContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_labPrice]"
                                                          options:0
                                                          metrics:nil
                                                            views:NSDictionaryOfVariableBindings(_labPrice)];
    vContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_labPrice(==15)]-3-[_labCostPrice]"
                                                          options:0
                                                          metrics:nil
                                                            views:NSDictionaryOfVariableBindings(_labCostPrice,_labPrice)];
    equalWH = [NSLayoutConstraint constraintWithItem:_labPrice
                                           attribute:NSLayoutAttributeWidth
                                           relatedBy:NSLayoutRelationEqual
                                              toItem:self
                                           attribute:NSLayoutAttributeWidth
                                          multiplier:0.5
                                            constant:-10];
    [self.contentView addConstraints:hContraints];
    [self.contentView addConstraints:vContraints];
    //等级
    self.labLevel.text = self.cellModel.level;
    [self.contentView addSubview:self.labLevel];
    hContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_labLevel]-10-|"
                                                          options:0
                                                          metrics:nil
                                                            views:NSDictionaryOfVariableBindings(_labLevel)];
    vContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_labLevel(==15)]-5-[_labSales]"
                                                          options:0
                                                          metrics:nil
                                                            views:NSDictionaryOfVariableBindings(_labSales,_labLevel)];
    equalWH = [NSLayoutConstraint constraintWithItem:_labLevel
                                           attribute:NSLayoutAttributeWidth
                                           relatedBy:NSLayoutRelationEqual
                                              toItem:self
                                           attribute:NSLayoutAttributeWidth
                                          multiplier:0.5
                                            constant:-10];
    [self.contentView addConstraints:hContraints];
    [self.contentView addConstraints:vContraints];
}

#pragma mark -

- (UIImageView *)iconImgV {
    if (_iconImgV == nil) {
        _iconImgV = [[UIImageView alloc] initWithFrame:CGRectZero];
        _iconImgV.translatesAutoresizingMaskIntoConstraints = NO;
        _iconImgV.backgroundColor = [UIColor colorWithRed:0xE0/255.0 green:0xE0/255.0 blue:0xE0/255.0 alpha:1.0];
    }
    return _iconImgV;
}

- (UILabel *)labTag {
    if (_labTag == nil) {
        _labTag = [[UILabel alloc] init];
        _labTag.textColor = [UIColor whiteColor];
        _labTag.font = [UIFont systemFontOfSize:12.0];
        _labTag.textAlignment = NSTextAlignmentLeft;
        _labTag.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _labTag;
}

- (UILabel *)labTitle {
    if (_labTitle == nil) {
        _labTitle = [[UILabel alloc] init];
        _labTitle.textColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
        _labTitle.font = [UIFont systemFontOfSize:15.0];
        _labTitle.textAlignment = NSTextAlignmentLeft;
        _labTitle.translatesAutoresizingMaskIntoConstraints = NO;
        _labTitle.numberOfLines = 0;
    }
    return _labTitle;
}

- (UILabel *)labIntro {
    if (_labIntro == nil) {
        _labIntro = [[UILabel alloc] init];
        _labIntro.textColor = [UIColor colorWithRed:0x99/255.0 green:0x99/255.0 blue:0x99/255.0 alpha:1.0];
        _labIntro.font = [UIFont systemFontOfSize:10.0];
        _labIntro.textAlignment = NSTextAlignmentLeft;
        _labIntro.translatesAutoresizingMaskIntoConstraints = NO;
        _labIntro.numberOfLines = 0;
    }
    return _labIntro;
}

/**
 价格
 
 @return 价格Label
 */
- (UILabel *)labPrice {
    if (_labPrice == nil) {
        _labPrice = [[UILabel alloc] init];
        _labPrice.textColor = [UIColor colorWithRed:0xFF/255.0 green:0x79/255.0 blue:0x3F/255.0 alpha:1.0];
        _labPrice.font = [UIFont systemFontOfSize:15.0];
        _labPrice.textAlignment = NSTextAlignmentLeft;
        _labPrice.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _labPrice;
}

/**
 权益等级
 
 @return 等级Label
 */
- (UILabel *)labLevel {
    if (_labLevel == nil) {
        _labLevel = [[UILabel alloc] init];
        _labLevel.textColor = [UIColor colorWithRed:0xFF/255.0 green:0x79/255.0 blue:0x3F/255.0 alpha:1.0];
        _labLevel.font = [UIFont systemFontOfSize:10.0];
        _labLevel.textAlignment = NSTextAlignmentRight;
        _labLevel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _labLevel;
}

/**
 原价
 
 @return 原价Label
 */
- (UILabel *)labCostPrice {
    if (_labCostPrice == nil) {
        _labCostPrice = [[UILabel alloc] init];
        _labCostPrice.textColor = [UIColor colorWithRed:0x99/255.0 green:0x99/255.0 blue:0x99/255.0 alpha:1.0];
        _labCostPrice.font = [UIFont systemFontOfSize:10.0];
        _labCostPrice.textAlignment = NSTextAlignmentLeft;
        _labCostPrice.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _labCostPrice;
}

/**
 销量
 
 @return 销量Label
 */
- (UILabel *)labSales {
    if (_labSales == nil) {
        _labSales = [[UILabel alloc] init];
        _labSales.textColor = [UIColor colorWithRed:0x99/255.0 green:0x99/255.0 blue:0x99/255.0 alpha:1.0];
        _labSales.font = [UIFont systemFontOfSize:10.0];
        _labSales.textAlignment = NSTextAlignmentRight;
        _labSales.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _labSales;
}

#pragma mark - Data

/**
 更新数据

 @param model 数据模型
 */
- (void)updateData:(ProductModel *)model {
    self.cellModel = model;
    [self setNeedsDisplay];
}

@end
