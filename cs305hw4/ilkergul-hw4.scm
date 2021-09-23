(define twoOperatorCalculator
	(lambda (hwlist)
		(if (= (length hwlist) 1)
			(car hwlist)
			(if (eq? '- (cadr hwlist))
				(twoOperatorCalculator (cons (- (car hwlist) (caddr hwlist)) (cdddr hwlist)))
				(if (eq? '+ (cadr hwlist))
					(twoOperatorCalculator (cons (+ (car hwlist) (caddr hwlist)) (cdddr hwlist)))
					 ; I have not added a last else statement to get output similar to golden 
				)
			)
		)
	)
)

(define fourOperatorCalculator
	(lambda (hwlist)
		(cond
			(( = (length hwlist) 1) hwlist)
			; if the length of the hwlist is 1 then return the hwlist as itself
			((eq? '/ (cadr hwlist)) (fourOperatorCalculator (cons (/ (car hwlist) (caddr hwlist)) (cdddr hwlist))))
			((eq? '* (cadr hwlist)) (fourOperatorCalculator (cons (* (car hwlist) (caddr hwlist)) (cdddr hwlist))))
			(else (cons (car hwlist) (fourOperatorCalculator (cdr hwlist))))
		)
	)
)
(define mapping 
	(lambda (hwlist)
		(if (pair? hwlist)
			(twoOperatorCalculator (fourOperatorCalculator (calculatorNested hwlist)))
			hwlist
		)
	)
)

(define calculatorNested 
	(lambda (hwlist)
		(map mapping hwlist)
	)
)

(define checkOperators
	(lambda (hwlist)
		(cond
			((and (not (list? hwlist))(number? hwlist)) #f)
			((and (not (list? hwlist))(symbol? hwlist)) #f)
			((null? hwlist) #f)
			((and (list? (car hwlist)) (null? (cdr hwlist))) (checkOperators (car hwlist)))
			((and (list? (car hwlist)) (not (null? (cdr hwlist)))) (and (checkOperators (car hwlist)) (checkOperators (cdr hwlist))))
			((and (number? (car hwlist)) (null? (cdr hwlist))) #t)
			((and (number? (car hwlist)) (not (null? (cdr hwlist)))) 
				(if (not (number? (cadr hwlist)))
					(checkOperators (cdr hwlist))
					#f
				)
			)
			((and (number? (car hwlist)) (null? (cdr hwlist))) #t)
			((not (and (or (eq? '+ (car hwlist)) (eq? '- (car hwlist)) (eq? '* (car hwlist)) (eq? '/ (car hwlist))) 
				(not (number? (car hwlist))))) #f)
			((and (or (eq? '+ (car hwlist)) (eq? '- (car hwlist)) (eq? '* (car hwlist)) (eq? '/ (car hwlist) )) 
				(not (null? (cdr hwlist)))) (checkOperators (cdr hwlist)))
			((and (or (eq? '+ (car hwlist)) (eq? '- (car hwlist)) (eq? '* (car hwlist)) (eq? '/ (car hwlist) )) 
				(null? (cdr hwlist))) #f)
			(else #t)
		)			 
	)
)

(define calculator
	(lambda (hwlist)
		(if (null? hwlist) 
			#f
			(if (checkOperators hwlist)
				(twoOperatorCalculator 
					(fourOperatorCalculator 
						(calculatorNested hwlist)
					)
				)
				#f
			)
		)
	)
)
					
