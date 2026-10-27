// Every C framework with an umbrella header on any Apple platform, so the C grammar knows every name a C program can reach.
// The generator parses this file once per SDK, and each import is guarded so a framework absent from a platform is skipped there.
// Tcl, Tk, Ruby, GLUT, Kernel and DriverKit are left out: they are interpreters, a kernel and a driver SDK, not application API.
// Kerberos is left out because its gssapi.h redefines what GSS declares, and GSS is the one Apple still develops.
#include <TargetConditionals.h>

#if __has_include(<Accelerate/Accelerate.h>)
#import <Accelerate/Accelerate.h>
#endif
#if __has_include(<ApplicationServices/ApplicationServices.h>)
#import <ApplicationServices/ApplicationServices.h>
#endif
#if __has_include(<AudioToolbox/AudioToolbox.h>)
#import <AudioToolbox/AudioToolbox.h>
#endif
#if __has_include(<AudioUnit/AudioUnit.h>)
#import <AudioUnit/AudioUnit.h>
#endif
#if __has_include(<Carbon/Carbon.h>)
#import <Carbon/Carbon.h>
#endif
#if __has_include(<CFNetwork/CFNetwork.h>)
#import <CFNetwork/CFNetwork.h>
#endif
#if __has_include(<ColorSync/ColorSync.h>)
#import <ColorSync/ColorSync.h>
#endif
#if __has_include(<CoreAudio/CoreAudio.h>)
#import <CoreAudio/CoreAudio.h>
#endif
#if __has_include(<CoreAudioTypes/CoreAudioTypes.h>)
#import <CoreAudioTypes/CoreAudioTypes.h>
#endif
#if __has_include(<CoreFoundation/CoreFoundation.h>)
#import <CoreFoundation/CoreFoundation.h>
#endif
#if __has_include(<CoreGraphics/CoreGraphics.h>)
#import <CoreGraphics/CoreGraphics.h>
#endif
#if __has_include(<CoreMedia/CoreMedia.h>)
#import <CoreMedia/CoreMedia.h>
#endif
#if __has_include(<CoreMIDI/CoreMIDI.h>)
#import <CoreMIDI/CoreMIDI.h>
#endif
#if __has_include(<CoreServices/CoreServices.h>)
#import <CoreServices/CoreServices.h>
#endif
#if __has_include(<CoreText/CoreText.h>)
#import <CoreText/CoreText.h>
#endif
#if __has_include(<CoreVideo/CoreVideo.h>)
#import <CoreVideo/CoreVideo.h>
#endif
#if __has_include(<DirectoryService/DirectoryService.h>)
#import <DirectoryService/DirectoryService.h>
#endif
#if __has_include(<DiskArbitration/DiskArbitration.h>)
#import <DiskArbitration/DiskArbitration.h>
#endif
#if __has_include(<DVDPlayback/DVDPlayback.h>)
#import <DVDPlayback/DVDPlayback.h>
#endif
#if __has_include(<ForceFeedback/ForceFeedback.h>)
#import <ForceFeedback/ForceFeedback.h>
#endif
#if __has_include(<GSS/GSS.h>)
#import <GSS/GSS.h>
#endif
#if __has_include(<Hypervisor/Hypervisor.h>)
#import <Hypervisor/Hypervisor.h>
#endif
#if __has_include(<ImageIO/ImageIO.h>)
#import <ImageIO/ImageIO.h>
#endif
#if __has_include(<IOKit/IOKitLib.h>)
#import <IOKit/IOKitLib.h>
#endif
#if __has_include(<IOSurface/IOSurface.h>)
#import <IOSurface/IOSurface.h>
#endif
#if __has_include(<JavaScriptCore/JavaScriptCore.h>)
#import <JavaScriptCore/JavaScriptCore.h>
#endif
#if __has_include(<LatentSemanticMapping/LatentSemanticMapping.h>)
#import <LatentSemanticMapping/LatentSemanticMapping.h>
#endif
#if __has_include(<LDAP/LDAP.h>)
#import <LDAP/LDAP.h>
#endif
#if __has_include(<MediaToolbox/MediaToolbox.h>)
#import <MediaToolbox/MediaToolbox.h>
#endif
#if __has_include(<MobileCoreServices/MobileCoreServices.h>)
#import <MobileCoreServices/MobileCoreServices.h>
#endif
#if __has_include(<NetFS/NetFS.h>)
#import <NetFS/NetFS.h>
#endif
#if __has_include(<Network/Network.h>)
#import <Network/Network.h>
#endif
#if __has_include(<OpenAL/OpenAL.h>)
#import <OpenAL/OpenAL.h>
#endif
#if __has_include(<OpenCL/OpenCL.h>)
#import <OpenCL/OpenCL.h>
#endif
#if __has_include(<OpenDirectory/OpenDirectory.h>)
#import <OpenDirectory/OpenDirectory.h>
#endif
#if __has_include(<OpenGL/OpenGL.h>)
#import <OpenGL/OpenGL.h>
#endif
#if __has_include(<OpenGL/gl.h>)
#import <OpenGL/gl.h>
#endif
#if __has_include(<OpenGLES/OpenGLES.h>)
#import <OpenGLES/OpenGLES.h>
#endif
#if __has_include(<OpenGLES/ES3/gl.h>)
#import <OpenGLES/ES3/gl.h>
#endif
#if __has_include(<Security/Security.h>)
#import <Security/Security.h>
#endif
#if __has_include(<SystemConfiguration/SystemConfiguration.h>)
#import <SystemConfiguration/SystemConfiguration.h>
#endif
#if __has_include(<VideoToolbox/VideoToolbox.h>)
#import <VideoToolbox/VideoToolbox.h>
#endif
#if __has_include(<vmnet/vmnet.h>)
#import <vmnet/vmnet.h>
#endif

#import <MacTypes.h>
#import <dispatch/dispatch.h>
#import <fcntl.h>
#import <math.h>
#import <os/log.h>
#import <os/signpost.h>
#import <pthread.h>
#import <simd/simd.h>
#import <sqlite3.h>
#import <stdint.h>
#import <stdio.h>
#import <unistd.h>
#import <xpc/xpc.h>

int main (int argc, char const* argv[])
{
	return 0;
}
