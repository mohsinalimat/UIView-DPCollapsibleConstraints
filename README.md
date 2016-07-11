# UIView-DPCollapsibleConstraints

# Overview
`UIView+DPCollapsibleConstraints` builds to **collapse** a view and its relevant layout constraints, simulating a **"Flow Layout"** mode.
`UIView+DPCollapsibleConstraints` is derived from `UIView+FDCollapsibleConstraints`，but `UIView+DPCollapsibleConstraints` only supports pure objective-c code, what's more, it's compatible with masonry!!

## Demo 1 (`UIView+DPCollapsibleConstraints` act the same result comparing with `UIView+FDCollapsibleConstraints`)
This demo collapses the `forkingdog` image view and its bottom margin constraint.  

![view demo](https://github.com/forkingdog/UIView-FDCollapsibleConstraints/blob/master/Sceenshots/screenshot0.gif)  

## Demo 2(`UIView+DPCollapsibleConstraints` act the same result comparing with `UIView+FDCollapsibleConstraints`)

This demo collapses diffent components in cell, according to its data entity, each margin handles right as well.  

![cell demo](https://github.com/forkingdog/UIView-FDCollapsibleConstraints/blob/master/Sceenshots/screenshot1.gif)

# Basic usage 
## 0. enable constraints to collapse

you should set dp_EnabelManualCollapsed to YES before you want to collapse the view;
```
@property(nonatomic,assign)BOOL dp_EnabelManualCollapsed;
```
###or
if view like `UILabel`, `UIImageView` which have their `Intrinsic content size`,you can set dp_autoCollapse to YES;
```
@property (nonatomic, assign) BOOL dp_autoCollapse;
```

## 1. Select constraints to collapse
First, tell which constraints will be collapsed when the view collapses.
and dp_NSLayoutAttributes is the collection of NSLayoutAttribute;

```
@property(nonatomic,copy)NSArray* dp_NSLayoutAttributes;
```  
you can initial  dp_NSLayoutAttributes in this way:
```
view.dp_NSLayoutAttributes = @[@(NSLayoutAttributeTop),@(NSLayoutAttributeHeight)];
```

## 2. Collapse a view

Selected constraints will collapse when:  

```
view.dp_collapsed = YES;
```
![collapsed](https://github.com/forkingdog/UIView-FDCollapsibleConstraints/blob/master/Sceenshots/screenshot5.png)

And expand back when:

```
view.dp_collapsed = NO;
```

![recovered](https://github.com/forkingdog/UIView-FDCollapsibleConstraints/blob/master/Sceenshots/screenshot6.png)

# Auto collapse

Not every view needs to add a width or height constraint, views like `UILabel`, `UIImageView` have their `Intrinsic content size` when they have content in it. For these views, we provide a `Auto collapse` property, when its content is gone, selected constraints will collapse automatically.  
You can enable auto collapse by:  

```
label.dp_autoCollapse = YES;
imageView.dp_autoCollapse = YES;
```

And it will work as you expect: 

```
label.text = nil/*or @""*/; (auto => label.dp_collapsed = YES)
label.text = @"forkingdog"; (auto => label.dp_collapsed = NO)
imageView.image = nil; (auto => imageView.dp_collapsed = YES)
imageView.image = [UIImage imageNamed:@"forkingdog"]; (auto => imageView.dp_collapsed = NO)
```

We've also offered a Interface Builder friendly way to enable `auto collapse`:  

```
@property (nonatomic, assign) BOOL dp_autoCollapse;
```

Here's what you may find in `Attribute Inspector`

![auto collapse](https://github.com/forkingdog/UIView-FDCollapsibleConstraints/blob/master/Sceenshots/screenshot4.png)

It's behavior is same as setting `dp_autoCollapse` property in code.

# Installation  

Cocoapods: 
```
pod search UIView+DPCollapsibleConstraints
```

# License
MIT
