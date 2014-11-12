#|
 This file is a part of Plump-Tex
 (c) 2014 Shirakumo http://tymoon.eu (shinmera@tymoon.eu)
 Author: Nicolas Hafner <shinmera@tymoon.eu>
|#

(defpackage #:plump-conspack
  (:nicknames #:org.tymoonnext.plump.conspack)
  (:use #:cl #:plump)
  (:shadow #:load)
  (:export
   #:define-encoding
   #:define-for-descendants
   #:encode
   #:decode
   #:dump
   #:load))
(in-package #:plump-conspack)

(defun make-ensured-instance (class &rest args)
  (apply #'make-instance
         class
         (loop for prev = NIL then item
               for item in args
               collect (case prev
                         (:attributes (ensure-attribute-map item))
                         (:children (ensure-child-array item))
                         (T item)))))

(defmacro define-encoding (class)
  "Defines automatic plump-conspack encoding for the class of name CLASS.
Generated are cpk:encode/decode-object methods for the given class.
If a given slot of a class does not have an initarg, it is not included
in the encoding.

This method is used over the slots variant as some initforms may signal
an error if not overridden with a value."
  (c2mop:finalize-inheritance (find-class class))
  (let ((slots (c2mop:class-slots (find-class class))))
    `(progn
       (defmethod cpk:encode-object ((object ,class) &key &allow-other-keys)
         (list
          (list ,@(loop for slot in slots
                        for name = (c2mop:slot-definition-name slot)
                        for arg = (first (c2mop:slot-definition-initargs slot))
                        when arg
                        append `(,arg (slot-value object ',name))))))

       (defmethod cpk:decode-object ((class (eql ',class)) data &key &allow-other-keys)
         (apply #'make-ensured-instance ',class (first data))))))

(defmacro define-for-descendants (class)
  "Expands to a DEFINE-ENCODING for CLASS and all its subclasses."
  (c2mop:finalize-inheritance (find-class class))
  `(progn
     (define-encoding ,class)
     ,@(loop for class in (c2mop:class-direct-subclasses (find-class class))
             collect `(define-for-descendants ,(class-name class)))))

(define-for-descendants node)

;; Since we know all the symbols used in the class definitions of standard-plump
;; we can define an index here and save some more.
(cpk:define-index plump
  node nesting-node child-node root text-node
  comment element doctype fulltext-element
  xml-header cdata processing instruction
  :children :parent :text :tag-name :attributes
  :doctype)

;; We need circularity tracking due to child/parent backreferences.
(defun encode (node &optional stream)
  (cpk:with-named-index 'plump
    (cpk:tracking-refs ()
      (cpk:encode node :stream stream))))

(defun decode (vector)
  (cpk:with-named-index 'plump
    (cpk:tracking-refs ()
      (cpk:decode vector))))

(defun dump (node pathname &key if-exists)
  )

(defun load (pathname &key if-does-not-exist)
  )
