//
//  UIImage+Pixels.h
//  CameraApp
//
//  Created by Rienk Woudwijk on 04-02-14.
//  Copyright (c) 2014 Vignet'D. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface UIImage (Pixels)
-(unsigned char*) grayscalePixels;
-(unsigned char*) rgbaPixels;
@end
