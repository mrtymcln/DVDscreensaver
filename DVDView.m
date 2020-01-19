#import "DVDView.h"
#define WIDTH ([NSScreen mainScreen].frame.size.width)
#define HEIGHT ([NSScreen mainScreen].frame.size.height)

// d = r * t
// r = d / t
// r = width / 10 seconds. 

@implementation DVDView

- (instancetype)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        
        const float fps = 60.0f;
        [self setAnimationTimeInterval:1.0/fps];

        const int speed = WIDTH / (15.0 * fps);
       
        self.dvdWidth = 256;
        self.dvdHeight = 128;
        self.x = WIDTH / 2.0 - self.dvdWidth / 2.0;
        self.y = HEIGHT / 2.0 - self.dvdHeight / 2.0;
        self.dirtyRect = NSMakeRect(self.x, self.y, self.dvdWidth, self.dvdHeight);
        self.xSpeed = speed * (arc4random() % 2 == 0 ? 1 : -1);
        self.ySpeed = speed * (arc4random() % 2 == 0 ? 1 : -1);
        
        NSString * dvdPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"dvdlogo" ofType:@"png"];
        
        self.dvdLogo = [[NSImage alloc] initWithContentsOfFile:dvdPath];
        [self hitWall];
    }
    return self;
}

- (void)startAnimation
{
    [super startAnimation];
}

- (void)stopAnimation
{
    [super stopAnimation];
}

- (void)drawRect:(NSRect)rectParam
{
    const float g = 15.0f/255.0f;
    [[NSColor colorWithRed:g green:g blue:g alpha:1] setFill];
    NSRectFill(rectParam);
    NSRect rect;

    rect.size = NSMakeSize(self.dvdWidth, self.dvdHeight);
    
    self.x += self.xSpeed;
    self.y += self.ySpeed;
    rect.origin = CGPointMake(self.x, self.y);
    self.dirtyRect = rect;
    
    [self.dvdLogo drawInRect:rect];
    
    CGPoint centre = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    
    if (centre.x + self.dvdWidth / 2 >= WIDTH || centre.x - self.dvdWidth / 2 <= 0) {
        self.xSpeed *= -1;
        [self hitWall];
    }
    
    if (centre.y + self.dvdHeight / 2 >= HEIGHT || centre.y - self.dvdHeight / 2 <= 0) {
        self.ySpeed *= -1;
        [self hitWall];
    }

}

- (void)hitWall
{

    NSArray * colours = @[[NSColor redColor],
                          [NSColor blueColor],
                          [NSColor yellowColor],
                          [NSColor cyanColor],
                          [NSColor orangeColor],
                          [NSColor magentaColor],
                          [NSColor greenColor]
                        ];
    self.dvdColor = colours[arc4random() % [colours count]];
    
    [self.dvdLogo lockFocus];
    [self.dvdColor set];
    NSRect imageRect = {NSZeroPoint, [self.dvdLogo size]};
    NSRectFillUsingOperation(imageRect, NSCompositingOperationSourceAtop);
    [self.dvdLogo unlockFocus];
}

- (void)animateOneFrame
{
    //[self setNeedsDisplay:true];
    [self setNeedsDisplayInRect:self.dirtyRect];
    return;
}

- (BOOL)hasConfigureSheet
{
    return NO;
}

- (NSWindow*)configureSheet
{
    return nil;
}
@end
