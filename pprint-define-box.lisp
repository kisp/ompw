;;; arch-tag: 771ec342-01cd-483b-8b5f-4797a4f0d90e

;;; Copyright (c) 2007, Kilian Sprotte. All rights reserved.

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

(in-package :ompw)

;;; (set-pprint-dispatch '(cons (eql ompw:define-box)) #'ompw:pprint-define-box)

;;; this could probably be more pretty
(defun pprint-define-box (stream obj)
  (destructuring-bind (name lambda-list &rest body) (cdr obj)
    (let ((*standard-output* stream))
      (write-char #\()
      (prin1 'ompw:define-box)
      (write-char #\space)
      (prin1 name)
      (write-char #\space)
      (prin1 lambda-list)
      ;; TODO we assume that a doc string will always be before options
      (when (stringp (car body))
	(terpri)
	(prin1 (pop body)))
      (loop for opt-tail = body
	   for opt = (car opt-tail)
	   for keywordp = (keywordp opt)
	   for i upfrom 0
	   until (and (not keywordp) (evenp i))
	   do (when (evenp i) (terpri))
	   do (prin1 opt)
	   do (when (evenp i)
		(write-char #\space))
	   do (pop body))
      (mapc #'pprint body)
      (write-char #\))
      (terpri))))
