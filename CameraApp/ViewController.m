//
//  ViewController.m
//  CameraApp
//
//  Created by Rienk Woudwijk on 04-02-14.
//  Copyright (c) 2014 Vignet'D. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImage+Pixels.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize luminanceImageView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setupCapture];
}

-(void)setupCapture{
    @autoreleasepool {

        AVCaptureDeviceInput *input = [AVCaptureDeviceInput
                                       deviceInputWithDevice:[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo]
                                       error:nil];
        
        AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc]init];
        
        dispatch_queue_t queue = dispatch_queue_create("myQueue", NULL);
        [output setSampleBufferDelegate:self queue:queue];
        
        output.alwaysDiscardsLateVideoFrames = YES;
        NSDictionary *videoSettings = @{(__bridge NSString*)kCVPixelBufferPixelFormatTypeKey: [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA]};
        [output setVideoSettings:videoSettings];
        
        self.sess = [[AVCaptureSession alloc]init];
        self.sess.sessionPreset = AVCaptureSessionPresetMedium;
        [self.sess addInput:input];
        [self.sess  addOutput:output];
        
        self.imageView = [[UIImageView alloc] init];
        
        self.layer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.sess];
        self.layer.bounds = self.view.bounds;
        self.layer.frame = self.view.frame;
        [self.view.layer addSublayer:self.layer];
        
        [self.sess startRunning];
    }
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
      fromConnection:(AVCaptureConnection *)connection
{
    @autoreleasepool {
    
        CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        CVPixelBufferLockBaseAddress(imageBuffer, 0);
        uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer);
        size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
        size_t width = CVPixelBufferGetWidth(imageBuffer);
        size_t height = CVPixelBufferGetHeight(imageBuffer);
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef newContext = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
        CGImageRef newImage = CGBitmapContextCreateImage(newContext);
        
        CGContextRelease(newContext);
        CGColorSpaceRelease(colorSpace);
        
        UIImage *image = [UIImage imageWithCGImage:newImage scale:1.0 orientation:UIImageOrientationUp];
        CGImageRelease(newImage);
        
        unsigned char *pixels = [image rgbaPixels];
        double totalLuminance = 0.0;
        for (int p = 0; p < image.size.width * image.size.height; p+=4) {
            totalLuminance += pixels[p]*0.299 + pixels[p+1]*0.587 + pixels[p+2]*0.114;
        }
        
        totalLuminance /= (image.size.width * image.size.height);
        totalLuminance /= 255.0;        NSLog(@"%f", totalLuminance);
        
        free(pixels);
        
        [self setLuminanceImageSource];
        
        CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    }
}

-(void)setLuminanceImageSource
{
    
	UIImage *image;
	switch (self.luminanceImageSource) {
		case FULL_LIGHT:
		{
			image = [UIImage imageNamed:@"belichting-goed.png"];
			NSLog(@"full");
			break;
		}
		case HALF_LIGHT:
		{
			image = [UIImage imageNamed:@"belichting-matig.png"];
			NSLog(@"half");
			break;
		}
		case BAD_LIGHT:
		{
			image= [UIImage imageNamed:@"belichting-slecht.png"];
			NSLog(@"bad");
			break;
		}
		default:
		{
			image = [UIImage imageNamed:@"belichting-goed.png"];
			break;
		}
	}
    self.luminanceImageView = [[UIImageView alloc] initWithImage:image];
    [self.luminanceImageView setImage:image];
    [self.view bringSubviewToFront:self.luminanceImageView];
//	NSLog(@"%@", self.luminanceImageView.image);
//	NSLog(@"lumi X:%f, Y:%f", self.luminanceImageView.frame.origin.x, self.luminanceImageView.frame.origin.y);
//	NSLog(@"view X:%f, Y:%f",self.view.frame.origin.x, self.view.frame.origin.y);
//	NSLog(@"window %@", self.view.window);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
