#|| 
Made by Tomas Möre 2014
This is a wrapper for the glfwNative library

The purpose of this library is to wrap glfw natives to a more scheme friendly environment

gsc  -cc-options "-framework Cocoa -framework OpenGL -lglfw3 -framework CoreVideo -framework IOKit -x objective-c -I/usr/local/include -I/System/Library/Frameworks/CoreVideo.framework -I/System/Library/Frameworks/IOKit.framework -I/System/Library/Frameworks/Cocoa.framework -I/System/Library/Frameworks/OpenGL.framework -L/Users/tomasmore/Downloads/glfw-3.0.4/build/src/ "  glfw.scm
gsc  -cc-options "-framework Cocoa -lglfw3 -lGLEW -framework CoreVideo -framework IOKit -x objective-c -I/usr/local/include -I/System/Library/Frameworks/CoreVideo.framework -I/System/Library/Frameworks/IOKit.framework -I/System/Library/Frameworks/Cocoa.framework -L/Users/tomasmore/Downloads/glfw-3.0.4/build/src/ "  glfw.scm
||#

(include "glfwNative.scm")
(include "glfwConstantConverter.scm")

;; to compare all the diffrent windows that we can make we need to be able to tell the windows from eachother.
;: we do this by getting the pointer number
(define  glfw#get-glfw-window-pointer      (c-lambda (GLFWwindow*) int "___result = ___arg1;"))
(define glfw#get-window-pointer (lambda (window) (glfw#get-glfw-window-pointer (##vector-ref window 1))))
#|| ERROR CALLBACK ||#
(define   glfw-error-procedure-holder #f)
(c-define (glfw#error-callback-procedure error-code error-msg)(int nonnull-UTF-8-string) void "gambitErrorCallback" ""
          (if  glfw-error-procedure-holder
              (glfw-error-procedure-holder error-code error-msg)
              )
          #f
          )

(define (glfw#set-error-callback procedure)
  (if (procedure? procedure)
      (begin
        (set!  glfw-error-procedure-holder procedure)
        (glfw-native#set-error-callback glfw#error-callback-procedure)
        )
      (begin
        (set!  glfw-error-procedure-holder #f)
        (glfw-native#set-error-callback #f)
        )))

#|| HINTS ||#
(define glfw#default-window-hint glfw-native#default-window-hint)
(define glfw#window-hint (lambda (hint hint-value) (glfw-native#window-hint (symbol->glfw-hint hint) (symbol->glfw-hint-value hint-value))))
#|| INIT ||#
(define glfw-initiated? #f)


;; Table of all windows created
;; this will mainly help the event procedures to find the correct window
;; key is the glfw-native#window* value is a scheme glfw#window
;; we need the equa test checker too see if windows are equal                                            
(define glfw#windows (make-table test: equal?))

(define (glfw#init)
  (if (not glfw-initiated?)
      (let ((inited? (glfw-native#init)))
        (set! glfw-initiated? inited?)
        inited?
        )#f))

(define (glfw#terminate)
  (or (not glfw-initiated?)
      (begin
      (glfw-native#terminate)
        (table-for-each (lambda (key val) 
                          (table-set! glfw#windows key)
                          ) glfw#windows) 
        )
      )
  )

#|| WIDNOW HANDLERS ||#

(define-type glfw#window

             constructor: glfw#make-window-type
             instance
             ;; the following slots prefixed with "on" should be #f or a procedure
             ;; default for all is #f
             ;; if this is a procedure all of the agruments are given an instance of the type itself
             ;; plus the extra information needed

             (on-close               read-only: init: #f)
             (on-refresh             read-only: init: #f)
             (on-resize              read-only: init: #f)
             (on-iconify             read-only: init: #f)
             (on-reposition          read-only: init: #f)
             (on-focus               read-only: init: #f)
             (on-mouse-click         read-only: init: #f)
             (on-cursor-move         read-only: init: #f)
             (on-mouse-enter         read-only: init: #f)
             (on-scroll              read-only: init: #f)
             (on-key-press           read-only: init: #f)
             (on-char-press          read-only: init: #f)
             (on-framebuffer-resize  read-only: init: #f)
             ;; utilities

             ;; because there are no native get title procedure 
             (title                  read-only:)
             )
(define-macro (get-glfw-window window)
  `(if (glfw#window? ,window) (##vector-ref ,window 1) ,window)
  )
(define-macro (get-scheme-window window)
  `(or (table-ref glfw#windows ,window #f) (error "Invalid glfw window")))

;; The following c-defines are what wrapps the c event listeners to scheme
(c-define (glfw#on-close glfw-window)(GLFWwindow*) void "gambitGLFWonError" ""
          (let ((window (get-scheme-window glfw-window)))
            ((##vector-ref window 2) window)
            )#f)
(c-define (glfw#on-refresh glfw-window)(GLFWwindow*) void "gambitGLFWonRefresh" ""
          (let ((window (get-scheme-window glfw-window)))
            ((##vector-ref window 3) window)
            )#f)
(c-define (glfw#on-resize glfw-window new-width new-height)(GLFWwindow* int int) void "gambitGLFWonResize" ""
          (let ((window (get-scheme-window glfw-window)))
            (##vector-set! window 17 new-width)
            (##vector-set! window 18 new-height)
            ((##vector-ref window 4) window new-width new-height)
            )#f)
(c-define (glfw#on-iconify glfw-window iconified?)(GLFWwindow* bool) void "gambitGLFWonIconify" ""
          (let ((window (get-scheme-window glfw-window)))
            (##vector-set! window 19 iconified?)
            ((##vector-ref window 5) window iconified?)
            )#f)
(c-define (glfw#on-reposition glfw-window x-position y-position)(GLFWwindow* int int) void "gambitGLFWonRespos" ""
          (let ((window (get-scheme-window glfw-window)))
            ((##vector-ref window 6) window x-position y-position)
            ) #f)
(c-define (glfw#on-focus glfw-window focused?)(GLFWwindow* bool) void "gambitGLFWonFocus" ""
          (let ((window (get-scheme-window glfw-window)))
            ((##vector-ref window 7) window focused?)
            )#f)

(c-define (glfw#on-mouse-click glfw-window button action modifier)(GLFWwindow* int int int) void "gambitGLFWonMouseClick" ""
          (let ((window (get-scheme-window glfw-window)))
            ((##vector-ref window 8) 
             window 
             (glfw-mouse-button->symbol button)
             (glfw-action->symbol       action)
             (glfw-mod-key->symbol      modifier)
             ))#f)
(c-define (glfw#on-cursor-move glfw-window x-pos y-pos)(GLFWwindow* double double) void "gambitGLFWonMousePos" ""
          (let ((window (get-scheme-window glfw-window)))
            ((##vector-ref window 9) 
             window 
             x-pos
             y-pos
             ))#f)
(c-define (glfw#on-mouse-enter glfw-window enter?)(GLFWwindow* bool) void "gambitGLFWonMouseEnter" ""
          (let ((window (get-scheme-window glfw-window)))
            ((##vector-ref window 10)
             window
             enter?
             )) #f)
(c-define (glfw#on-scroll glfw-window x-offset y-offset)(GLFWwindow* double double) void "gambitGLFWonScroll" ""
          (let ((window (get-scheme-window glfw-window)))
            ((##vector-ref window 11)
             window
             x-offset
             y-offset
             ))#f)
(c-define (glfw#on-key-press glfw-window key scancode action mods)(GLFWwindow* int int int int) void "gambitGLFWonKey" ""
          (let ((window (get-scheme-window glfw-window)))
            ((##vector-ref window 12)
             window
             key
             scancode
             (glfw-action->symbol action)
             (if (eq? mods 0) #f (glfw-mod-key->symbol mods))
             ))#f)
(c-define (glfw#on-char-press glfw-window utf-8-integer)(GLFWwindow* int) void "gambitGLFWonCharPress" ""          
          (let ((window (get-scheme-window glfw-window)))
            ((##vector-ref window 13)
             window
             (integer->char utf-8-integer)
             ))#f)
(c-define (glfw#on-framebuffer-resize glfw-window width height)(GLFWwindow* int int) void "gambitGLFWonFrameBufferResize" ""
          (let ((window (get-scheme-window glfw-window)))
            ((##vector-ref window 14)
             window
             width
             height
             ))#f)

              
;; Setters for the diffrent event callback procedures
;; what realy happends is is that we bind a scheme procedure to the glfw#window specifi slot
;; then we tell glfw to use one of the procedures defined above.
;; the procedures defined above will find the correct procedure for the window and run it
;; this way we do not need to make and compile c-define for the interpeter to work 
(define  (glfw#window-on-close-set! window value)
  (glfw-native#set-window-close-callback (glfw#window-instance window) (if value glfw#on-close #f))
  (##vector-set! window 2 value))
                                 
(define  (glfw#window-on-refresh-set! window value)
  (glfw-native#set-window-refresh-callback (glfw#window-instance window) (if value glfw#on-refresh #f))
  (##vector-set! window 3 value))

(define  (glfw#window-on-resize-set! window value)
  (glfw-native#set-window-size-callback (glfw#window-instance window) (if value glfw#on-resize #f))
  (##vector-set! window 4 value))
(define  (glfw#window-on-iconify-set! window value)
  (glfw-native#set-window-iconify-callback (glfw#window-instance window) (if value glfw#on-iconify  #f))
  (##vector-set! window 5 value))

(define  (glfw#window-on-reposition-set! window value)
  (glfw-native#set-window-pos-callback (glfw#window-instance window) (if value glfw#on-reposition #f))
  (##vector-set! window 6 value))

(define  (glfw#window-on-focus-set! window value)
  (glfw-native#set-window-focus-callback (glfw#window-instance window) (if value glfw#on-focus #f))
  (##vector-set! window 7 value))

(define  (glfw#window-on-mouse-click-set! window value)
  (glfw-native#set-mouse-button-callback (glfw#window-instance window) (if value glfw#on-mouse-click #f))
  (##vector-set! window 8 value))

(define  (glfw#window-on-cursor-move-set! window value)
  (glfw-native#set-cursor-pos-callback (glfw#window-instance window) (if value glfw#on-cursor-move #f))
  (##vector-set! window 9 value))

(define  (glfw#window-on-mouse-enter-set! window value)
  (glfw-native#set-cursor-enter-callback (glfw#window-instance window) (if value glfw#on-mouse-enter #f))
  (##vector-set! window 10 value))

(define  (glfw#window-on-scroll-set! window value)
  (glfw-native#set-scroll-callback (glfw#window-instance window) (if value glfw#on-scroll #f))
  (##vector-set! window 11 value))

(define  (glfw#window-on-key-press-set! window value)
  (glfw-native#set-key-callback (glfw#window-instance window) (if value glfw#on-key-press #f))
  (##vector-set! window 12 value))

(define  (glfw#window-on-char-press-set! window value)
  (glfw-native#set-char-callback (glfw#window-instance window) (if value glfw#on-char-press #f))
  (##vector-set! window 13 value))

(define  (glfw#window-on-framebuffer-resize-set! window value)
  (glfw-native#set-framebuffer-size-callback (glfw#window-instance window) (if value glfw#on-framebuffer-resize #f))
  (##vector-set! window 14 value))


;; This is the procedure to create a window
;; it returns an instace of glfw#window
;; as a little sugar I made it such that if GLFW isn't initiated it does so automaticly
(define (glfw#make-window width height title
             #!key
             (monitor #f)
             (share   #f)
             )
  ;; just as a helper we init glfw if it isn' allready so
  (or glfw-initiated? (glfw#init))
  (let* ((glfw-window (glfw-native#create-window width height title monitor share))
         (window (glfw#make-window-type
                      glfw-window title)))
    (table-set! glfw#windows glfw-window window)
    window
    ))

;; the destroy window procedure both destrys the glfw-native and
;; removes the scheme version from it's table.
;; can be dangerous if there still are references to the
;; window in the code.
(define (glfw#window-destroy window)
  (let ((pointer (glfw#get-window-pointer window)))    
    (glfw-native#destroy-window (get-glfw-window window))
    (table-set! glfw#windows pointer)))

(define (glfw#window-should-close window)
  (glfw-native#window-should-close (get-glfw-window window)))

(define (glfw#window-attribute window attribute)
  (let ((glfw-window (get-glfw-window window)))
    (glfw-native#get-window-attrib glfw-window attribute)));;(glfw-attribute-value->symbol (glfw-native#get-window-attrib glfw-window attribute))))

(define (glfw#window-show window)
  (glfw-native#show-window (get-glfw-window window)))

(define (glfw#widnow-hide window)
  (glfw-native#hide-window (get-glfw-window window)))

(define (glfw#window-iconify window)
  (glfw-native#iconify (get-glfw-window window)))

(define (glfw#window-pos window)
  (let ((glfw-window (get-glfw-window window))
        (x-int (make-int* 0))
        (y-int (make-int* 0)))
    (glfw-native#get-window-pos glfw-window x-int y-int)
    (let ((respond-pair (cons (int*-value x-int) (int*-value y-int))))
      (int*-free x-int)(int*-free y-int)
      respond-pair)))

;; addinng window-position-x and window-position-y as well, they are the same as above but just removes one dimention
(define (glfw#window-position-x window)
  (let ((glfw-window (get-glfw-window window))
        (x-int (make-int* 0)))
    (glfw-native#get-window-pos glfw-window x-int #f)
    (let ((x (int*-value x-int)))
      (int*-free x-int)
      x)))
(define (glfw#window-position-y window)
  (let ((glfw-window (get-glfw-window window))
        (y-int (make-int* 0)))
    (glfw-native#get-window-pos glfw-window #f y-int)
    (let ((y (int*-value y-int)))
      (int*-free y-int)
      y)))

(define (glfw#window-position-set! window x-pos y-pos)
  (let ((glfw-window (get-glfw-window window)))
    (glfw-native#set-window-pos glfw-window x-pos y-pos)))
;; we make window-pos-x-set and window-pos-y-set as well
;: they do the same thing as window-pos-set but will take the other value from the allreade existing one
(define (glfw#window-position-x-set! window x-pos)
  (let ((glfw-window (get-glfw-window window)))
    (glfw-native#set-window-pos glfw-window x-pos (glfw#window-position-y glfw-window)))
  )
(define (glfw#window-position-y-set! window y-pos)
  (let ((glfw-window (get-glfw-window window)))    
    (glfw-native#set-window-pos glfw-window (glfw#window-position-x glfw-window) y-pos))
  )

(define (glfw#window-size window)
  (let ((glfw-window (get-glfw-window window))
        (width (make-int* 0))
        (height (make-int* 0)))
    (glfw-native#get-window-size glfw-window width height)
    (let ((respond-pair (cons (int*-value width) (int*-value height))))
      (int*-free width)(int*-free height)
      respond-pair)))
(define (glfw#window-width window)
  (let ((glfw-window (get-glfw-window window))
        (width (make-int* 0)))
    (glfw-native#get-window-size glfw-window width #f)
    (let ((respond (int*-value width)))
      (int*-free width)
      respond)))
(define (glfw#window-height window)
  (let ((glfw-window (get-glfw-window window))
        (height (make-int* 0)))
    (glfw-native#get-window-size glfw-window #f height)
    (let ((respond (int*-value height)))
      (int*-free height)
      respond)))

(define (glfw#window-size-set! window width height)
  (let ((glfw-window (get-glfw-window window)))
    (glfw-native#set-window-size glfw-window width height)
    ))
;; we define window-width-set! and window height-set as well
(define (glfw#window-width-set! window width)
  (let ((glfw-window (get-glfw-window window)))
    (glfw-native#set-window-size glfw-window width (glfw#window-height glfw-window))
    ))
(define (glfw#window-height-set! window height)
  (let ((glfw-window (get-glfw-window window)))
    (glfw-native#set-window-size glfw-window (glfw#window-width glfw-window) height)
    ))

(define (glfw#window-title-set! window title-string)
  (let ((glfw-window (get-glfw-window window)))
    (##vector-set! window 15 title-string)
    (glfw-native#set-window-title (get-glfw-window window)  title-string)))

(define (glfw#window-monitor window)
  (let ((glfw-window (get-glfw-window window)))
    (glfw-native#get-monitor glfw-window)))

#|| CLIPBOARD ||#
(define (glfw#get-clipboard-string window)
  (let ((glfw-window (get-glfw-window window)))
    (glfw-native#get-clipboard-string glfw-window)))

(define (glfw#clipboard-string-set! window string)
  (let ((glfw-window (get-glfw-window window)))
    (glfw-native#set-clipboard-string glfw-window string)))

#|| CONTEXT ||#
(define (glfw#current-context #!optional new-context-window)
  (if new-context-window
      (begin (glfw-native#make-context-current (get-glfw-window new-context-window))
        new-context-window)
      (table-ref glfw#windows  (glfw-native#get-current-context) #f)))

(define (glfw#window-swap-buffers window)
  (glfw-native#swap-buffers (get-glfw-window window)))

(define glfw#current-vsync 0)

(define (glfw##swap-interval fps)
  (glfw-native#swap-interval fps)
  (set! glfw#current-vsync fps))

#|| MONITOR ||#
;; there is no need to do anything too fancy with monitor
;; meaning that the montior data format is the same as native

(define glfw#get-monitors
  (let ((glfw-get-monitor (c-lambda (GLFWmonitor** int) GLFWmonitor* "___result = ___arg1[___arg2];")))
  (lambda ()
  (let* ((count          (make-int* 0))
         (output-list    (list))
         (monitors-array (glfw-native#get-monitors count)))
    (if (not (eq? (int*-value count) 0))
        (begin
          (let loop ((i (- (int*-value count) 1)))
            (set! output-list (cons (glfw-get-monitor monitors-array i) output-list))
            (if (not (eq? i 0)) (loop (- i 1)))
            )
          (int*-free count)
          output-list
          )'())))))

(define (glfw#monitor-position monitor)
  (let ((x-pos (make-int* 0))
        (y-pos (make-int* 0)))
    (glfw-native#get-monitor-pos monitor x-pos y-pos)
    (let ((respond-pair (cons (int*-value x-pos) (int*-value y-pos))))
      (int*-free x-pos)(int*-free y-pos)
      respond-pair)))

(define (glfw#monitor-position-x monitor)
  (let ((x-pos (make-int* 0)))
    (glfw-native#get-monitor-pos monitor x-pos #f)
    (let ((respond (int*-value x-pos)))
      (int*-free x-pos)
      respond)))

(define (glfw#monitor-position-y monitor)
  (let ((y-pos (make-int* 0)))
    (glfw-native#get-monitor-pos monitor #f y-pos)
    (let ((respond (int*-value y-pos)))
      (int*-free y-pos)
      respond)))

(define (glfw#monitor-physical-size monitor)
  (let ((width (make-int* 0))
        (height (make-int* 0)))
    (glfw-native#get-monitor-physical-size monitor width height)
    (let ((respond-pair (cons (int*-value width) (int*-value height))))
      (int*-free width)(int*-free height)
      respond-pair)))

(define (glfw#monitor-physical-width monitor)
  (let ((x-pos (make-int* 0)))
    (glfw-native#get-monitor-physical-size monitor x-pos #f)
    (let ((respond (int*-value x-pos)))
      (int*-free x-pos)
      respond)))

(define (glfw#monitor-physical-height monitor)
  (let ((height (make-int* 0)))
    (glfw-native#get-monitor-physical-size monitor #f height)
    (let ((respond (int*-value height)))
      (int*-free height)
      respond)))

;; just a rename
(define (glfw#monitor-name monitor) 
  (glfw-native#get-monitor-name monitor))

;; this table is here to make sure that none of the oncallback procedures are garbage collected
;; i could be wrong about this
(define glfw-monitor-on-callback-function #f)

(c-define (glfw#on-monitor-connect/disconnect-cfun glfw-monitor connected?)(GLFWmonitor* bool) void "gambitGLFWonMontorCallback" ""
          (if glfw-monitor-on-callback-function
              (glfw-monitor-on-callback-function glfw-monitor connected?)
              )#f)

(define (glfw#on-monitor-connect/disconnet procedure)
  (if (procedure? procedure)
      (begin (if glfw-monitor-on-callback-function
                 (set! glfw-monitor-on-callback-function procedure)
                 (begin
                   (set! glfw-monitor-on-callback-function procedure)
                   (glfw-native#set-monitor-callback glfw#on-monitor-connect/disconnect-cfun))))
      (glfw-native#set-monitor-callback #f)))


