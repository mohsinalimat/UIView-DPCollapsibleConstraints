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

#import <UIKit/UIKit.h>

@interface UIView (DPCollapsibleConstraints)

/// Assigning this property immediately disables the view's collapsible constraints'
/// by setting their constants to zero.
@property (nonatomic, assign) BOOL dp_collapsed;

/// Specify constraints to be affected by "dp_collapsed" property by connecting in
@property (nonatomic, copy) NSArray *dp_collapsibleConstraints;

@property(nonatomic,copy)NSArray* dp_NSLayoutAttributes;

@property(nonatomic,assign)BOOL dp_EnabelManualCollapsed;

@end

@interface UIView (DPAutomaticallyCollapseByIntrinsicContentSize)

/// Enable to automatically collapse constraints in "dp_collapsibleConstraints" when
/// you set or indirectly set this view's "intrinsicContentSize" to {0, 0} or absent.
///
/// For example:
///  imageView.image = nil;
///  label.text = nil, label.text = @"";
///
/// "NO" by default, you may enable it by codes.
@property (nonatomic, assign) BOOL dp_autoCollapse;

@end


@interface NSLayoutConstraint (_DPOriginalConstantStorage)

@property(nonatomic,assign)CGFloat dp_originalConstant;

@end

