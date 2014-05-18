
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
