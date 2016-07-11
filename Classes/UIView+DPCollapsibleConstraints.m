// The MIT License (MIT)
//
// Copyright (c) 2015-2016 depaX
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import "UIView+DPCollapsibleConstraints.h"
#import "objc/runtime.h"

/// A stored property extension for NSLayoutConstraint's original constant.
@implementation NSLayoutConstraint (_DPOriginalConstantStorage)

+ (void)load
{
    // Swizzle to hack "-constraintWithItem:attribute:relatedBy:toItem:attribute:multiplier:constant:" method
    SEL originalSelector = @selector(constraintWithItem:attribute:relatedBy:toItem:attribute:multiplier:constant:);
    SEL swizzledSelector = @selector(dp_constraintWithItem:attribute:relatedBy:toItem:attribute:multiplier:constant:);

    Class class = NSLayoutConstraint.class;
    Method originalMethod = class_getClassMethod(class, originalSelector);
    Method swizzledMethod = class_getClassMethod(class, swizzledSelector);

    method_exchangeImplementations(originalMethod, swizzledMethod);
}

+ (instancetype)dp_constraintWithItem:(id)view1 attribute:(NSLayoutAttribute)attr1 relatedBy:(NSLayoutRelation)relation toItem:(nullable id)view2 attribute:(NSLayoutAttribute)attr2 multiplier:(CGFloat)multiplier constant:(CGFloat)c
{
    NSLayoutConstraint* constaint = nil;
    constaint = [self.class dp_constraintWithItem:view1 attribute:attr1 relatedBy:relation toItem:view2 attribute:attr2 multiplier:multiplier constant:c];

    if([view1 isKindOfClass:UIView.class])
    {
        UIView* tmpView = (UIView *)view1;

        if(tmpView.dp_EnabelManualCollapsed || tmpView.dp_autoCollapse)
        {
            [tmpView.dp_NSLayoutAttributes enumerateObjectsUsingBlock:^(NSNumber*  _Nonnull layoutAttribute, NSUInteger idx, BOOL * _Nonnull layoutStop) {

                if(layoutAttribute.integerValue == attr1)
                {
                    tmpView.dp_collapsibleConstraints = @[constaint];
                    *layoutStop = YES;
                }
            }];
        }
    }

    return constaint;
}

- (void)setDp_originalConstant:(CGFloat)originalConstant
{
    objc_setAssociatedObject(self, @selector(dp_originalConstant), @(originalConstant), OBJC_ASSOCIATION_RETAIN);
}

- (CGFloat)dp_originalConstant
{
#if CGFLOAT_IS_DOUBLE
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
#else
    return [objc_getAssociatedObject(self, _cmd) floatValue];
#endif
}

@end

@implementation UIView (DPCollapsibleConstraints)

#pragma mark - Dynamic Properties

- (void)setDp_collapsed:(BOOL)collapsed
{
    [self.dp_collapsibleConstraints enumerateObjectsUsingBlock:
     ^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop){
         if (collapsed)
         {
            constraint.constant = 0;
         }
         else
         {
             constraint.constant = constraint.dp_originalConstant;
         }
     }];

    objc_setAssociatedObject(self, @selector(dp_collapsed), @(collapsed), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)dp_collapsed
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (NSMutableArray *)dp_collapsibleConstraints
{
    NSMutableArray *constraints = objc_getAssociatedObject(self, _cmd);
    if (!constraints)
    {
        constraints = @[].mutableCopy;
        objc_setAssociatedObject(self, _cmd, constraints, OBJC_ASSOCIATION_RETAIN);
    }
    return constraints;
}

- (void)setDp_collapsibleConstraints:(NSArray *)dp_collapsibleConstraints
{
    // Hook assignments to our custom `dp_collapsibleConstraints` property.
    NSMutableArray *constraints = (NSMutableArray *)self.dp_collapsibleConstraints;

    [dp_collapsibleConstraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
        // Store original constant value
        constraint.dp_originalConstant = constraint.constant;
        [constraints addObject:constraint];
    }];
}

-(void)setDp_NSLayoutAttributes:(NSArray *)dp_NSLayoutAttributes
{
    NSMutableArray *layoutAttributes = (NSMutableArray *)self.dp_NSLayoutAttributes;
    [layoutAttributes addObjectsFromArray:dp_NSLayoutAttributes];
}

- (NSMutableArray *)dp_NSLayoutAttributes
{
    NSMutableArray *layoutAttributes = objc_getAssociatedObject(self, _cmd);
    if (!layoutAttributes)
    {
        layoutAttributes = @[].mutableCopy;
        objc_setAssociatedObject(self, _cmd, layoutAttributes, OBJC_ASSOCIATION_RETAIN);
    }
    return layoutAttributes;
}

- (void) setDp_EnabelManualCollapsed:(BOOL)dp_EnabelManualCollapsed
{
    objc_setAssociatedObject(self, @selector(dp_EnabelManualCollapsed), @(dp_EnabelManualCollapsed), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)dp_EnabelManualCollapsed
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

@end


@implementation UIView (DPAutomaticallyCollapseByIntrinsicContentSize)

#pragma mark - Hacking "-updateConstraints"

+ (void)load
{
    // Swizzle to hack "-updateConstraints" method
    SEL originalSelector = @selector(updateConstraints);
    SEL swizzledSelector = @selector(dp_updateConstraints);

    Class class = UIView.class;
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

    method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (void)dp_updateConstraints
{
    // Call primary method's implementation
    [self dp_updateConstraints];

    if (self.dp_autoCollapse && self.dp_collapsibleConstraints.count > 0)
    {

        // "Absent" means this view doesn't have an intrinsic content size, {-1, -1} actually.
        const CGSize absentIntrinsicContentSize = CGSizeMake(UIViewNoIntrinsicMetric, UIViewNoIntrinsicMetric);

        // Calculated intrinsic content size
        const CGSize contentSize = [self intrinsicContentSize];

        // When this view doesn't have one, or has no intrinsic content size after calculating,
        // it going to be collapsed.
        if (CGSizeEqualToSize(contentSize, absentIntrinsicContentSize) || CGSizeEqualToSize(contentSize, CGSizeZero))
        {
            self.dp_collapsed = YES;
        }
        else
        {
            self.dp_collapsed = NO;
        }
    }
}

#pragma mark - Dynamic Properties

- (BOOL)dp_autoCollapse
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setDp_autoCollapse:(BOOL)autoCollapse
{
    objc_setAssociatedObject(self, @selector(dp_autoCollapse), @(autoCollapse), OBJC_ASSOCIATION_RETAIN);
}

@end

