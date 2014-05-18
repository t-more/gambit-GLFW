#||
Made by Tomas Möre 2014

To compile:
MAC OSX
glfw must have opengl cocoa corevideo and iokit frameworks included to run
The following should be in -cc-options for this
-framework Cocoa -framework OpenGL -framework CoreVideo -framework IOKit -x objective-c -I/usr/local/include -I/System/Library/Frameworks/CoreVideo.framework -I/System/Library/Frameworks/IOKit.framework  -I/System/Library/Frameworks/Cocoa.framework -I/System/Library/Frameworks/OpenGL.framework

gsc  -cc-options "-framework Cocoa -framework OpenGL -lglfw3 -framework CoreVideo -framework IOKit -x objective-c -I/usr/local/include -I/System/Library/Frameworks/CoreVideo.framework -I/System/Library/Frameworks/IOKit.framework -I/System/Library/Frameworks/Cocoa.framework -I/System/Library/Frameworks/OpenGL.framework -L[path to glfw3.a] "  glfwNative.scm

||#

(declare 
 (block)
 (mostly-fixnum)
 )
(c-declare #<<c-declare-end
#include <GLFW/glfw3.h>

c-declare-end
) 


 #|| CONSTANTS ||#
(include "glfwconstants.scm")


(c-define-type GLFWvidmode            (struct "GLFWvidmode" ))
(c-define-type GLFWvidmode*           (pointer GLFWvidmode))

(c-define-type GLFWgammaramp            (struct "GLFWgammaramp" ))
(c-define-type GLFWgammaramp*           (pointer GLFWgammaramp))

(c-define-type GLFWmonitor*            (pointer "GLFWmonitor"            GLFWmonitor* ))
(c-define-type GLFWmonitor**           (pointer GLFWmonitor*))
(c-define-type GLFWwindow*             (pointer "GLFWwindow"             GLFWwindow*))

 #|| STRUCTS ||#

;; videomode
(define glfw-native#videomode-width        (c-lambda (GLFWvidmode*) int "GLFWvidmode x = *___arg1;___result = x.width;"))
(define glfw-native#videomode-height       (c-lambda (GLFWvidmode*) int "GLFWvidmode x = *___arg1;___result = x.height;"))
(define glfw-native#videomode-red-rits     (c-lambda (GLFWvidmode*) int "GLFWvidmode x = *___arg1;___result = x.redBits;"))
(define glfw-native#videomode-green-bits   (c-lambda (GLFWvidmode*) int "GLFWvidmode x = *___arg1;___result = x.greenBits;"))
(define glfw-native#videomode-blue-bits    (c-lambda (GLFWvidmode*) int "GLFWvidmode x = *___arg1;___result = x.blueBits;"))
(define glfw-native#videomode-refresh-rate (c-lambda (GLFWvidmode*) int "GLFWvidmode x = *___arg1;___result = x.refreshRate;"))

;; gamaramp
(define glfw-native#gamaramp-red    (c-lambda (GLFWgammaramp*) (pointer unsigned-int) "GLFWgammaramp x = *___arg1;___result = x.red;"))
(define glfw-native#gamaramp-green  (c-lambda (GLFWgammaramp*) (pointer unsigned-int) "GLFWgammaramp x = *___arg1;___result = x.green;"))
(define glfw-native#gamaramp-blue   (c-lambda (GLFWgammaramp*) (pointer unsigned-int) "GLFWgammaramp x = *___arg1;___result = x.blue;"))
(define glfw-native#gamaramp-size   (c-lambda (GLFWgammaramp*) unsigned-int "GLFWgammaramp x = *___arg1;___result = x.size;"))

#|| error function  ||#
(c-define-type GLFWerrorfun           (function (int UTF-8-string)      void))
#||  monitor functions  ||# 
(c-define-type GLFWmonitorfun         (function (GLFWmonitor* int)           void))

#|| window functions ||#
(c-define-type GLFWwindowclosefun     (function (GLFWwindow*)           void))
(c-define-type GLFWwindrefreshfun     (function (GLFWwindow*)           void))
(c-define-type GLFWwindowsizefun      (function (GLFWwindow* int int)   void))
(c-define-type GLFWwindowiconifyfun   (function (GLFWwindow* bool)       void))
(c-define-type GLFWwindowposfun       (function (GLFWwindow* int int)   void))
(c-define-type GLFWwindowfocusfun     (function (GLFWwindow* bool)       void))

#|| framebuffer functions ||#
(c-define-type GLFWframebuffersizefun (function (GLFWwindow* int int)   void))

#|| Input functions ||#
(c-define-type GLFWmousebuttonfun     (function (GLFWwindow* int int int) void))
(c-define-type GLFWcursorposfun       (function (GLFWwindow* double double) void))
(c-define-type GLFWcursorenterfun     (function (GLFWwindow* bool) void))
(c-define-type GLFWscrollfun          (function (GLFWwindow* double double) void))
(c-define-type GLFWkeyfun             (function (GLFWwindow* int int int int) void))
(c-define-type GLFWcharfun            (function (GLFWwindow* unsigned-int) void))

#|| Context functions ||#
(c-define-type GLFWglproc             (function ()   void))


#|| INIT AND VERSION INFO ||#
(define glfw-native#init                        (c-lambda () bool  "glfwInit"));(lambda () (if (eq? (glfw-native#realInit) 1) #t #f)))

;; terminate
(define glfw-native#terminate                   (c-lambda () void "glfwTerminate"))

;; version info
(define glfw-native#get-version-info            (c-lambda ((pointer int) (pointer int) (pointer int)) void         "glfwGetVersion"))
(define glfw-native#get-version-string          (c-lambda ()                                          char-string  "glfwGetVersionString"))
#|| ERROR ||#
(define glfw-native#set-error-callback          (c-lambda (GLFWerrorfun)                              GLFWerrorfun "glfwSetErrorCallback")) 

#|| HINTS ||#
(define glfw-native#default-window-hint         (c-lambda ()        void "glfwDefaultWindowHints"))
(define glfw-native#window-hint                 (c-lambda (int int) void "glfwWindowHint"))

#|| WINDOW ||#
(define glfw-native#create-window               (c-lambda (int int nonnull-char-string GLFWmonitor* GLFWwindow*) GLFWwindow*  "glfwCreateWindow"))
(define glfw-native#destroy-window              (c-lambda (GLFWwindow*)                                          void         "glfwDestroyWindow"))
(define glfw-native#restore-window              (c-lambda (GLFWwindow*)                                          void         "glfwRestoreWindow"))
  
(define glfw-native#window-should-close         (c-lambda (GLFWwindow*)                                          int          "glfwWindowShouldClose"))


(define glfw-native#show-window                 (c-lambda (GLFWwindow*)                                          void         "glfwShowWindow"))
(define glfw-native#hide-window                 (c-lambda (GLFWwindow*)                                          void         "glfwHideWindow"))

(define glfw-native#iconify                     (c-lambda (GLFWwindow*)                                          void         "glfwIconifyWindow"))


(define glfw-native#get-window-pos              (c-lambda (GLFWwindow* (pointer int) (pointer int))              void         "glfwGetWindowPos"))
(define glfw-native#set-window-pos              (c-lambda (GLFWwindow* int int)                                  void         "glfwSetWindowPos"))

(define glfw-native#set-window-size             (c-lambda (GLFWwindow* int int)                                  void         "glfwSetWindowSize"))
(define glfw-native#set-window-title            (c-lambda (GLFWwindow* nonnull-UTF-8-string)                     void         "glfwSetWindowTitle"))

(define glfw-native#get-window-attrib           (c-lambda (GLFWwindow* int)                                      void         "glfwGetWindowAttrib"))

(define glfw-native#get-monitor                 (c-lambda (GLFWwindow*)                                          GLFWmonitor* "glfwGetWindowMonitor"))

;; callbacks
(define glfw-native#set-window-close-callback   (c-lambda (GLFWwindow* GLFWwindowclosefun)   GLFWwindowclosefun   "glfwSetWindowCloseCallback"))
(define glfw-native#set-window-focus-callback   (c-lambda (GLFWwindow* GLFWwindowfocusfun)   GLFWwindowfocusfun   "glfwSetWindowFocusCallback"))
(define glfw-native#set-window-iconify-callback (c-lambda (GLFWwindow* GLFWwindowiconifyfun) GLFWwindowiconifyfun "glfwSetWindowIconifyCallback"))
(define glfw-native#set-window-pos-callback     (c-lambda (GLFWwindow* GLFWwindowposfun)     GLFWwindowposfun     "glfwSetWindowPosCallback"))
(define glfw-native#set-window-refresh-callback (c-lambda (GLFWwindow* GLFWwindrefreshfun)   GLFWwindrefreshfun   "glfwSetWindowRefreshCallback"))
(define glfw-native#set-window-size-callback    (c-lambda (GLFWwindow* GLFWwindowsizefun)    GLFWwindowsizefun    "glfwSetWindowSizeCallback"))


#|| CLIPBOARD ||#
(define glfw-native#get-clipboard-string    (c-lambda (GLFWwindow*)              UTF-8-string "glfwGetClipboardString"))
(define glfw-native#set-clipboard-string    (c-lambda (GLFWwindow* UTF-8-string) void  "glfwSetClipboardString"))

#|| MONITOR ||#
(define glfw-native#get-monitors               (c-lambda ((pointer int))                              GLFWmonitor**        "glfwGetMonitors"))
(define glfw-native#get-primary-monitor        (c-lambda ()                                           GLFWmonitor*         "glfwGetPrimaryMonitor"))
(define glfw-native#get-monitor-pos            (c-lambda (GLFWmonitor*    (pointer int)(pointer int)) void                 "glfwGetMonitorPos"))
(define glfw-native#get-monitor-physical-size  (c-lambda (GLFWmonitor*    (pointer int)(pointer int)) void                 "glfwGetMonitorPhysicalSize"))
(define glfw-native#get-monitor-name           (c-lambda (GLFWmonitor*)                               nonnull-UTF-8-string "glfwGetMonitorName"))
(define glfw-native#set-monitor-callback       (c-lambda (GLFWmonitorfun)                             GLFWmonitorfun       "glfwSetMonitorCallback"))
(define glfw-native#get-video-modes            (c-lambda (GLFWmonitor*    (pointer int))              GLFWvidmode*         "glfwGetVideoModes"))
(define glfw-native#get-video-mode             (c-lambda (GLFWmonitor*)                               GLFWvidmode*         "glfwGetVideoMode"))
(define glfw-native#set-gamma                  (c-lambda (GLFWmonitor*    float)                      void                 "glfwSetGamma"))
(define glfw-native#get-gamma-ramp             (c-lambda (GLFWmonitor*)                               GLFWgammaramp*       "glfwGetGammaRamp"))
(define glfw-native#set-gamma-ramp             (c-lambda (GLFWmonitor*    GLFWgammaramp*)             void                 "glfwSetGammaRamp"))


#|| FRAME BUFFEr ||#

(define glfw-native#get-frame-buffer-size (c-lambda (GLFWwindow* (pointer int) (pointer int)) void "glfwGetFramebufferSize"))
;; callbacks
(define glfw-native#set-framebuffer-size-callback (c-lambda (GLFWwindow* GLFWframebuffersizefun) GLFWframebuffersizefun "glfwSetFramebufferSizeCallback"))

#|| CONTEXT ||#
(define glfw-native#make-context-current (c-lambda (GLFWwindow*) void        "glfwMakeContextCurrent"))
(define glfw-native#get-current-context  (c-lambda ()            GLFWwindow* "glfwGetCurrentContext"))
(define glfw-native#get-proc-address     (c-lambda (char-string) GLFWglproc  "glfwGetProcAddress"))
(define glfw-native#swap-buffers         (c-lambda (GLFWwindow*) void        "glfwSwapBuffers"))
(define glfw-native#swap-interval        (c-lambda (int)         void        "glfwSwapInterval"))
(define glfw-native#extention-supported? (c-lambda (char-string) bool        "glfwExtensionSupported"))

#|| EVENTS ||# 
(define    glfw-native#wait-events (c-lambda () void "glfwWaitEvents"))
(define    glfw-native#poll-events (c-lambda () void "glfwPollEvents"))

#|| INPUT ||# 

;; general
(define    glfw-native#get-input-mode            (c-lambda (GLFWwindow* int) int "glfwGetInputMode"))
(define    glfw-native#set-input-mode            (c-lambda (GLFWwindow* int int) void "glfwSetInputMode"))

;; keyboard
(define    glfw-native#get-key                   (c-lambda (GLFWwindow* int) int "glfwGetKey"))
(define    glfw-native#set-key-callback          (c-lambda (GLFWwindow* GLFWkeyfun) GLFWkeyfun "glfwSetKeyCallback"))
(define    glfw-native#set-char-callback         (c-lambda (GLFWwindow* GLFWcharfun) GLFWcharfun "glfwSetCharCallback"))

;; mouse
(define    glfw-native#get-mouse-button          (c-lambda (GLFWwindow* int) int "glfwGetMouseButton"))
(define    glfw-native#get-cursor-pos            (c-lambda (GLFWwindow* (pointer double) (pointer double)) void "glfwGetCursorPos"))
(define    glfw-native#set-cursor-pos            (c-lambda (GLFWwindow* double double) void "glfwSetCursorPos"))
(define    glfw-native#set-mouse-button-callback (c-lambda (GLFWwindow* GLFWmousebuttonfun) GLFWmousebuttonfun "glfwSetMouseButtonCallback"))
(define    glfw-native#set-cursor-pos-callback   (c-lambda (GLFWwindow* GLFWcursorposfun) GLFWcursorposfun "glfwSetCursorPosCallback"))
(define    glfw-native#set-cursor-enter-callback (c-lambda (GLFWwindow* GLFWcursorenterfun) GLFWcursorenterfun "glfwSetCursorEnterCallback"))
(define    glfw-native#set-scroll-callback       (c-lambda (GLFWwindow* GLFWscrollfun) GLFWscrollfun "glfwSetScrollCallback"))

;; joystick
(define    glfwjoystick-present?                 (c-lambda (int) bool "glfwJoystickPresent"))
(define    glfw-native#get-joystick-axes         (c-lambda (int (pointer int)) (pointer float) "glfwGetJoystickAxes"))
(define    glfw-native#get-joystick-buttons      (c-lambda (int (pointer int)) (pointer unsigned-char) "glfwGetJoystickButtons"))
(define    glfw-native#get-joystick-name         (c-lambda (GLFWkeyfun) UTF-8-string "glfwGetJoystickName"))

#|| TIME ||# 
;; unecessary, we have gambit time but lets include the api anyhow
(define    glfw-native#get-time         (c-lambda ()       double "glfwGetTime"))
(define    glfw-native#set-time         (c-lambda (double) void   "glfwSetTime"))
#|| NATIVE ACCESS ||# 
;; TODO

