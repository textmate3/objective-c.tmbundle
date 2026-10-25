// Every C framework in the SDK with an umbrella header, so the C grammar knows every name a C program on macOS can reach.
// Tcl, Tk, Ruby, GLUT, Kernel and DriverKit are left out: they are interpreters, a kernel and a driver SDK, not application API.
// Kerberos is left out because its gssapi.h redefines what GSS declares, and GSS is the one Apple still develops.
#import <Accelerate/Accelerate.h>
#import <ApplicationServices/ApplicationServices.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AudioUnit/AudioUnit.h>
#import <Carbon/Carbon.h>
#import <CFNetwork/CFNetwork.h>
#import <ColorSync/ColorSync.h>
#import <CoreAudio/CoreAudio.h>
#import <CoreAudioTypes/CoreAudioTypes.h>
#import <CoreFoundation/CoreFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreMIDI/CoreMIDI.h>
#import <CoreServices/CoreServices.h>
#import <CoreText/CoreText.h>
#import <CoreVideo/CoreVideo.h>
#import <DirectoryService/DirectoryService.h>
#import <DiskArbitration/DiskArbitration.h>
#import <DVDPlayback/DVDPlayback.h>
#import <ForceFeedback/ForceFeedback.h>
#import <GSS/GSS.h>
#import <Hypervisor/Hypervisor.h>
#import <ImageIO/ImageIO.h>
#import <IOKit/IOKitLib.h>
#import <IOSurface/IOSurface.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import <LatentSemanticMapping/LatentSemanticMapping.h>
#import <LDAP/LDAP.h>
#import <MediaToolbox/MediaToolbox.h>
#import <NetFS/NetFS.h>
#import <Network/Network.h>
#import <OpenAL/OpenAL.h>
#import <OpenCL/OpenCL.h>
#import <OpenDirectory/OpenDirectory.h>
#import <OpenGL/OpenGL.h>
#import <OpenGL/gl.h>
#import <Security/Security.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <VideoToolbox/VideoToolbox.h>
#import <vmnet/vmnet.h>

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
