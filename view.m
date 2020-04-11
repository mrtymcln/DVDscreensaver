#import "view.h"
#define WIDTH ([NSScreen mainScreen].frame.size.width)
#define HEIGHT ([NSScreen mainScreen].frame.size.height)

@implementation DVDView

static NSImage * drawLogo(NSString *dvdPath, NSColor *dvdColor) {
    NSImage * dvdLogo = [[NSImage alloc] initWithContentsOfFile:dvdPath];
    [dvdLogo lockFocus];
    [dvdColor set];
    NSRect imageRect = {NSZeroPoint, [dvdLogo size]};
    NSRectFillUsingOperation(imageRect, NSCompositingOperationSourceAtop);
    [dvdLogo unlockFocus];
    [dvdLogo setCacheMode:NSImageCacheAlways];
    return dvdLogo;
}

- (instancetype)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{self = [super initWithFrame:frame isPreview:isPreview]; if (self) {
    const float fps = 60.0f;
    [self setAnimationTimeInterval:1.0/fps];

    const int speed = WIDTH / (15.0 * fps);

    self.initializing = YES;
    self.dvdWidth = 256;
    self.dvdHeight = 128;
    self.x = WIDTH / 2.0 - self.dvdWidth / 2.0;
    self.y = HEIGHT / 2.0 - self.dvdHeight / 2.0;
    self.dirtyRect = NSMakeRect(self.x, self.y, self.dvdWidth, self.dvdHeight);
    self.xSpeed = speed * (arc4random() % 2 == 0 ? 1 : -1);
    self.ySpeed = speed * (arc4random() % 2 == 0 ? 1 : -1);
    
    NSString * dvdPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"dvdlogo" ofType:@"png"];
    
    self.dvdLogos = @[
        drawLogo(dvdPath, [NSColor redColor]),
        drawLogo(dvdPath, [NSColor blueColor]),
        drawLogo(dvdPath, [NSColor yellowColor]),
        drawLogo(dvdPath, [NSColor cyanColor]),
        drawLogo(dvdPath, [NSColor orangeColor]),
        drawLogo(dvdPath, [NSColor magentaColor]),
        drawLogo(dvdPath, [NSColor greenColor])
    ];
}return self;}

- (void)startAnimation
{[super startAnimation];}
- (void)stopAnimation
{[super stopAnimation];}
- (void)drawRect:(NSRect)rectParam {
    const float g = 0.0f/255.0f;
    [[NSColor colorWithRed:g green:g blue:g alpha:1] setFill];
    NSRectFill(rectParam);

    if (self.initializing) {
        const unsigned long count = [self.dvdLogos count];
        unsigned long offset = self.prevIdx = arc4random() % (count - 1);
        NSImage * logo = self.dvdLogo = self.dvdLogos[offset % count];
        for (unsigned long i = 1; i < count; i++) {
            logo = self.dvdLogos[(offset + i) % count];
            [logo drawInRect:self.dirtyRect];
        }
        [self.dvdLogo drawInRect:self.dirtyRect];
        self.initializing = NO;
        return;
    }

    NSRect rect;
    
    rect.size = NSMakeSize(self.dvdWidth, self.dvdHeight);
    
    self.x += self.xSpeed;
    self.y += self.ySpeed;
    rect.origin = CGPointMake(self.x, self.y);
    self.dirtyRect = rect;
    
    [self.dvdLogo drawInRect:rect];
    
    CGPoint centre = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    
    if (centre.x + self.dvdWidth / 2 >= self.bounds.size.width || centre.x - self.dvdWidth / 2 <= 0) {
        self.xSpeed *= -1;
        [self hitWall];
    }
    
    if (centre.y + self.dvdHeight / 2 >= self.bounds.size.height || centre.y - self.dvdHeight / 2 <= 0) {
        self.ySpeed *= -1;
        [self hitWall];
    }
}

- (void)hitWall
{
    const unsigned long count = [self.dvdLogos count];
    int idx = arc4random() % (count - 1);
    if (idx >= self.prevIdx) {
        idx = (idx + 1) % count;
    }
    self.prevIdx = idx;
    self.dvdLogo = self.dvdLogos[idx];
}

- (void)animateOneFrame {
    [self setNeedsDisplayInRect:self.dirtyRect];
    return;
}
- (BOOL)hasConfigureSheet{return NO;}
- (NSWindow*)configureSheet{return nil;}
@end
