#import "NvCubitTestingPlugin.h"
#if __has_include(<nv_cubit_testing/nv_cubit_testing-Swift.h>)
#import <nv_cubit_testing/nv_cubit_testing-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "nv_cubit_testing-Swift.h"
#endif

@implementation NvCubitTestingPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftNvCubitTestingPlugin registerWithRegistrar:registrar];
}
@end
