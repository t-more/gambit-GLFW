(define-macro (c-constants #!rest body)

 (append '(begin) (map (lambda (constant-info)
         (let (
               (constant (if (list? constant-info) (car constant-info) constant-info))
               (c-name   (symbol->string (if (list? constant-info) (or (list-ref constant-info 1) constant-info) constant-info)))
               
               )
           `(define ,constant ((c-lambda () int ,(string-append "___result = " c-name";"))))
           )

         ) body))
  
  )
(c-define-type unsigned-int8*          (pointer unsigned-int8))
(c-define-type unsigned-int16*         (pointer unsigned-int16))
(c-define-type unsigned-int32*         (pointer unsigned-int32))
(c-define-type unsigned-int64*         (pointer unsigned-int64))

(c-define-type int8*                   (pointer int8))
(c-define-type int16*                  (pointer int16))
(c-define-type int32*                  (pointer int32))
(c-define-type int64*                  (pointer int64))

(c-define-type float32*                (pointer float32))
(c-define-type float64*                (pointer float64))



#|| UNSIGNED int VECTORS ||#
(c-define-type u8vector*     (pointer unsigned-int8))
(c-define-type u16vector*    (pointer unsigned-int16))
(c-define-type u32vector*    (pointer unsigned-int32))
(c-define-type u64vector*    (pointer unsigned-int64))

(define make-u8vector-still-nonclear  (c-lambda (unsigned-int) scheme-object "___result = ___EXT(___alloc_scmobj)(___ps, ___sU8VECTOR, ___arg1);"))
(define make-u8vector-still (c-lambda (unsigned-int int8) scheme-object #<<c-lambda-end
___SCMOBJ temp = ___EXT(___alloc_scmobj)(___ps, ___sU8VECTOR, ___arg1);
___result = temp;
uint8_t* cvector = ___BODY(temp);
uint8_t i;
for(i = 0; i < ___arg1;i++){ cvector[i] = ___arg2;};
c-lambda-end
))
(define u8vector-still  (lambda args
                          (let* ((make-length (length args))
                                 (max-index   (- make-length 1))
                                 (u8vector    (make-u8vector-still-nonclear make-length)))                            
                            (let loop ((i 0))
                              (u8vector-set! u8vector i (list-ref args i))
                              (if (not (eq? i max-index)) (loop (+ i 1)) u8vector)
                              ))))
(define u8vector->u8vector* (c-lambda (scheme-object) u8vector* "___result = ___BODY(___arg1);"))
(define u8vector->unsigned-int8* (c-lambda (scheme-object unsigned-int) unsigned-int8* "___result = ___BODY(___arg1) + ___arg2;"))


(define make-u16vector-still-nonclear  (c-lambda (unsigned-int) scheme-object "___result = ___EXT(___alloc_scmobj)(___ps, ___sU16VECTOR, ___arg1 * 2);"))
(define make-u16vector-still (c-lambda (unsigned-int int16) scheme-object #<<c-lambda-end
int length = ___arg1 * 2;
___SCMOBJ temp = ___EXT(___alloc_scmobj)(___ps, ___sU16VECTOR,length);
___result = temp;
uint16_t* cvector = ___BODY(temp);
uint16_t i;
for(i = 0; i < length;i++){ cvector[i] = ___arg2;};
c-lambda-end
))
(define u16vector-still  (lambda args
                          (let* ((make-length (length args))
                                 (max-index   (- make-length 1))
                                 (u16vector   (make-u16vector-still-nonclear make-length)))                            
                            (let loop ((i 0))
                              (u16vector-set! u16vector i (list-ref args i))
                              (if (not (eq? i max-index)) (loop (+ i 1)) u16vector)
                              ))))
(define u16vector->u16vector* (c-lambda (scheme-object) u16vector* "___result = ___BODY(___arg1);"))
(define u16vector->unsigned-int16* (c-lambda (scheme-object unsigned-int) unsigned-int16* "___result = ___BODY(___arg1) + ___arg2;"))

(define make-u32vector-still-nonclear  (c-lambda (unsigned-int) scheme-object "___result = ___EXT(___alloc_scmobj)(___ps, ___sU32VECTOR, ___arg1 * 4);"))
(define make-u32vector-still (c-lambda (unsigned-int int32) scheme-object #<<c-lambda-end
int length = ___arg1 * 4;
___SCMOBJ temp = ___EXT(___alloc_scmobj)(___ps, ___sU32VECTOR, length);
___result = temp;
uint32_t* cvector = ___BODY(temp);
uint32_t i;
for(i = 0; i < length;i++){ cvector[i] = ___arg2;};
c-lambda-end
))
(define u32vector-still  (lambda args
                          (let* ((make-length (length args))
                                 (max-index   (- make-length 1))
                                 (u32vector   (make-u32vector-still-nonclear make-length)))                            
                            (let loop ((i 0))
                              (u32vector-set! u32vector i (list-ref args i))
                              (if (not (eq? i max-index)) (loop (+ i 1)) u32vector)
                              ))))
(define u32vector->u32vector* (c-lambda (scheme-object) u32vector* "___result = ___BODY(___arg1);"))
(define u32vector->unsigned-int32* (c-lambda (scheme-object unsigned-int) unsigned-int32* "___result = ___BODY(___arg1) + ___arg2;"))

(define make-u64vector-still-nonclear  (c-lambda (unsigned-int) scheme-object "___result = ___EXT(___alloc_scmobj)(___ps, ___sU64VECTOR, ___arg1 * 8);"))
(define make-u64vector-still (c-lambda (unsigned-int int64) scheme-object #<<c-lambda-end
int length = ___arg1 * 8;
___SCMOBJ temp = ___EXT(___alloc_scmobj)(___ps, ___sU64VECTOR, length);
___result = temp;
uint64_t* cvector = ___BODY(temp);
uint32_t i;
for(i = 0; i < length;i++){ cvector[i] = ___arg2;};
c-lambda-end
))
(define u64vector-still  (lambda args
                          (let* ((make-length (length args))
                                 (max-index   (- make-length 1))
                                 (u64vector   (make-u64vector-still-nonclear make-length)))                            
                            (let loop ((i 0))
                              (u64vector-set! u64vector i (list-ref args i))
                              (if (not (eq? i max-index)) (loop (+ i 1)) u64vector)
                              ))))
(define u64vector->u64vector* (c-lambda (scheme-object) u64vector* "___result = ___BODY(___arg1);"))
(define u64vector->unsigned-int64* (c-lambda (scheme-object unsigned-int) unsigned-int64* "___result = ___BODY(___arg1) + ___arg2;"))



#|| SIGNED int VECTORS ||#
(c-define-type s8vector*     (pointer int8))
(c-define-type s16vector*    (pointer int16))
(c-define-type s32vector*    (pointer int32))
(c-define-type s64vector*    (pointer int64))

(define make-s8vector-still-nonclear  (c-lambda (unsigned-int) scheme-object "___result = ___EXT(___alloc_scmobj)(___ps, ___sS8VECTOR, ___arg1);"))
(define make-s8vector-still (c-lambda (unsigned-int int8) scheme-object #<<c-lambda-end
___SCMOBJ temp = ___EXT(___alloc_scmobj)(___ps, ___sS8VECTOR, ___arg1);
___result = temp;
int8_t* cvector = ___BODY(temp);
uint32_t i;
for(i = 0; i < ___arg1;i++){ cvector[i] = ___arg2;};
c-lambda-end
))
(define s8vector-still  (lambda args
                          (let* ((make-length (length args))
                                 (max-index   (- make-length 1))
                                 (s8vector    (make-s8vector-still-nonclear make-length)))                            
                            (let loop ((i 0))
                              (s8vector-set! s8vector i (list-ref args i))
                              (if (not (eq? i max-index)) (loop (+ i 1)) s8vector)
                              ))))
(define s8vector->s8vector* (c-lambda (scheme-object) s8vector* "___result = ___BODY(___arg1);"))
(define s8vector->int8* (c-lambda (scheme-object unsigned-int) int8* "___result = ___BODY(___arg1) + ___arg2;"))


(define make-s16vector-still-nonclear  (c-lambda (unsigned-int) scheme-object "___result = ___EXT(___alloc_scmobj)(___ps, ___sS16VECTOR, ___arg1 * 2);"))
(define make-s16vector-still (c-lambda (unsigned-int int16) scheme-object #<<c-lambda-end
int length = ___arg1 * 2; 
___SCMOBJ temp = ___EXT(___alloc_scmobj)(___ps, ___sS16VECTOR, length);
___result = temp;
int16_t* cvector = ___BODY(temp);
uint32_t i;
for(i = 0; i < length;i++){ cvector[i] = ___arg2;};
c-lambda-end
))
(define s16vector-still  (lambda args
                          (let* ((make-length (length args))
                                 (max-index   (- make-length 1))
                                 (s16vector    (make-s16vector-still-nonclear make-length)))                            
                            (let loop ((i 0))
                              (s16vector-set! s16vector i (list-ref args i))
                              (if (not (eq? i max-index)) (loop (+ i 1)) s16vector)
                              ))))
(define s16vector->s16vector* (c-lambda (scheme-object) s16vector* "___result = ___BODY(___arg1);"))
(define s16vector->int16* (c-lambda (scheme-object unsigned-int) int16* "___result = ___BODY(___arg1) + ___arg2;"))


(define make-s32vector-still-nonclear  (c-lambda (unsigned-int) scheme-object "___result = ___EXT(___alloc_scmobj)(___ps, ___sS32VECTOR, ___arg1 * 4);"))
(define make-s32vector-still (c-lambda (unsigned-int int32) scheme-object #<<c-lambda-end
int length = ___arg1 * 4; 
___SCMOBJ temp = ___EXT(___alloc_scmobj)(___ps, ___sS32VECTOR, length);
___result = temp;
int32_t* cvector = ___BODY(temp);
uint32_t i;
for(i = 0; i < length;i++){ cvector[i] = ___arg2;};
c-lambda-end
))
(define s32vector-still  (lambda args
                          (let* ((make-length (length args))
                                 (max-index   (- make-length 1))
                                 (s32vector    (make-s32vector-still-nonclear make-length)))                            
                            (let loop ((i 0))
                              (s32vector-set! s32vector i (list-ref args i))
                              (if (not (eq? i max-index)) (loop (+ i 1)) s32vector)
                              ))))
(define s32vector->s32vector* (c-lambda (scheme-object) s32vector* "___result = ___BODY(___arg1);"))
(define s32vector->int32* (c-lambda (scheme-object unsigned-int) int32* "___result = ___BODY(___arg1) + ___arg2;"))

(define make-s64vector-still-nonclear  (c-lambda (unsigned-int) scheme-object "___result = ___EXT(___alloc_scmobj)(___ps, ___sS64VECTOR, ___arg1 * 8);"))
(define make-s64vector-still (c-lambda (unsigned-int int64) scheme-object #<<c-lambda-end
int length = ___arg1 * 8; 
___SCMOBJ temp = ___EXT(___alloc_scmobj)(___ps, ___sS64VECTOR, length);
___result = temp;
int64_t* cvector = ___BODY(temp);
int64_t i;
for(i = 0; i < length;i++){ cvector[i] = ___arg2;};
c-lambda-end
))
(define s64vector-still  (lambda args
                          (let* ((make-length (length args))
                                 (max-index   (- make-length 1))
                                 (s64vector    (make-s64vector-still-nonclear make-length)))                            
                            (let loop ((i 0))
                              (s64vector-set! s64vector i (list-ref args i))
                              (if (not (eq? i max-index)) (loop (+ i 1)) s64vector)
                              ))))
(define s64vector->s64vector* (c-lambda (scheme-object) s64vector* "___result = ___BODY(___arg1);"))
(define s64vector->int64* (c-lambda (scheme-object unsigned-int) int64* "___result = ___BODY(___arg1) + ___arg2;"))

#|| FLOAT VECTORS ||#
(c-define-type f32vector*    (pointer float32))
(c-define-type f64vector*    (pointer float64))

(define make-f32vector-still-nonclear  (c-lambda (unsigned-int) scheme-object "___result = ___EXT(___alloc_scmobj)(___ps, ___sF32VECTOR, ___arg1 * 4);"))
(define make-f32vector-still (c-lambda (unsigned-int float32) scheme-object #<<c-lambda-end
int length = ___arg1 * 4; 
___SCMOBJ temp = ___EXT(___alloc_scmobj)(___ps, ___sF32VECTOR, length);
___result = temp;
float* cvector = ___BODY(temp);
uint64_t i;
for(i = 0; i < length;i++){ cvector[i] = ___arg2;};
c-lambda-end
))
(define f32vector-still  (lambda args
                          (let* ((make-length (length args))
                                 (max-index   (- make-length 1))
                                 (f32vector    (make-f32vector-still-nonclear make-length)))                            
                            (let loop ((i 0))
                              (f32vector-set! f32vector i (list-ref args i))
                              (if (not (eq? i max-index)) (loop (+ i 1)) f32vector)
                              ))))
(define f32vector->f32vector* (c-lambda (scheme-object) f32vector* "___result = ___BODY(___arg1);"))
(define f32vector->float32* (c-lambda (scheme-object unsigned-int) float32* "___result = ___BODY(___arg1) + ___arg2;"))

(define make-f64vector-still-nonclear  (c-lambda (unsigned-int) scheme-object "___result = ___EXT(___alloc_scmobj)(___ps, ___sF64VECTOR, ___arg1 * 4);"))
(define make-f64vector-still (c-lambda (unsigned-int float64) scheme-object #<<c-lambda-end
int length = ___arg1 * 4; 
___SCMOBJ temp = ___EXT(___alloc_scmobj)(___ps, ___sF64VECTOR, length);
___result = temp;
double* cvector = ___BODY(temp);
uint32_t i;
for(i = 0; i < length;i++){ cvector[i] = ___arg2;};
c-lambda-end
))
(define f64vector-still  (lambda args
                          (let* ((make-length (length args))
                                 (max-index   (- make-length 1))
                                 (f64vector    (make-f64vector-still-nonclear make-length)))                            
                            (let loop ((i 0))
                              (f64vector-set! f64vector i (list-ref args i))
                              (if (not (eq? i max-index)) (loop (+ i 1)) f64vector)
                              ))))
(define f64vector->f64vector* (c-lambda (scheme-object) f64vector* "___result = ___BODY(___arg1);"))
(define f64vector->float64* (c-lambda (scheme-object unsigned-int) float64* "___result = ___BODY(___arg1) + ___arg2;"))

(define make-int* (c-lambda (int) (pointer int) "int* n = malloc(sizeof(int)); *n = ___arg1; ___result = n;"))
(define int*-value (c-lambda ((pointer int)) int "___result = *___arg1;"))
(define int*-set!   (c-lambda ((pointer int) int) void "*___arg1 = ___arg2;"))
(define int*-free  (c-lambda ((pointer int)) void "free(___arg1);"))
