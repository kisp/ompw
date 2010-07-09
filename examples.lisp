;;; -*- Mode:Lisp; Syntax:ANSI-Common-Lisp; -*-

;;; Copyright (c) 2007 - 2010, Kilian Sprotte. All rights reserved.

;;; Redistribution and use in source and binary forms, with or without
;;; modification, are permitted provided that the following conditions
;;; are met:

;;;   * Redistributions of source code must retain the above copyright
;;;     notice, this list of conditions and the following disclaimer.

;;;   * Redistributions in binary form must reproduce the above
;;;     copyright notice, this list of conditions and the following
;;;     disclaimer in the documentation and/or other materials
;;;     provided with the distribution.

;;; THIS SOFTWARE IS PROVIDED BY THE AUTHOR 'AS IS' AND ANY EXPRESSED
;;; OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
;;; WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
;;; ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
;;; DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
;;; DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
;;; GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
;;; INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
;;; WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
;;; NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
;;; SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

(defpackage :mylibrary-package
  (:use :cl :ompw))

(in-package :mylibrary-package)

(define-ompw myadd ((a 1) (b 1))
  "Add A + B."
  (+ a b))

(defmethod myadd ((a list) (b list))
  (mapcar #'+ a b))

(define-ompw myadd-non-gf ((a 1) (b 1))
  :non-generic t
  "Add A + B."
  (+ a b))

(define-ompw myposition ((elt 3) (list (1 2 3 4 3 2 1)) &optional (from-end nil))
  "Return position of ELT in LIST."
  :menu (from-end t nil)
  (position elt list :from-end from-end))

(define-ompw myadd2 ((a 3) (b 200))
  :menu (a 1 2 3 4 5)
  :menu (b (100 "einhundert") (200 "zweihundert"))
  "Add A + B."
  (+ a b))

(define-ompw myadd3 (&optional (a 1) (b 1))
  "Add A + B."
  (+ a b))

(define-ompw ks ()
  (progn
    "ks"))

(define-ompw mymember ((elt (2)) (list ((1) (2) 3 4 5 6)) &optional (test equal))
  (member elt list :test test))

(define-ompw menu-test ((dyn :mf))
  :menu (dyn :p :mf :f)
  (if (eql dyn :mf) "its mf" "another dyn"))

(define-ompw menu-test2 ((dyn mf))
  :menu (dyn p mf f)
  (if (eql dyn 'mf) "its mf" "another dyn"))

(define-ompw outputs-test ((a 1) (b 1))
  :outputs 2
  (values a b))
