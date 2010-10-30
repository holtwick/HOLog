This NSLog helper can be put into an ObjC method and than dumps the full 
method name including the values passed to that method.

Example of using the 'HOLogPing' NSLog extension: 

	#import "HOLog.h"

	@implementation HOLogDemoViewController

	- (void)exampleMethod:(id)obj 
	                   a1:(int)a1 
	                   a2:(CGPoint)a2
	                   a3:(double)a3 
	                   a4:(BOOL)a4
	{
    
	    // In the following line happens the magic!!!
	    HOLogPing
    
	    // ... 
	}

	- (void)viewDidLoad {
    
	    // ...

	    // Test call
	    [self exampleMethod:@"a string"
	                     a1:42 
	                     a2:CGPointMake(12, 21) 
	                     a3:1.23
	                     a4:YES
	     ];
	}

	@end

Examples output:

	2010-10-30 13:35:56.112 HOLogDemo[35880:207] 

	  -[HOLogDemoViewController exampleMethod:@a string a1:(int)42 a2:(CGPoint){12, 21} a3:(double)1.230000 a4:(char)1]
	