//
//  ViewController.h
//  CameraApp
//
//  Created by Rienk Woudwijk on 04-02-14.
//  Copyright (c) 2014 Vignet'D. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate>

typedef enum _luminanceImageSource {
    FULL_LIGHT = 0,
    HALF_LIGHT = 1,
    BAD_LIGHT = 2
}luminanceImageSource;

@property (strong, nonatomic) IBOutlet UIImageView *luminanceImageView;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *layer;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *prevLayer;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) AVCaptureSession *sess;
@property (nonatomic, assign) luminanceImageSource        luminanceImageSource;


@end
