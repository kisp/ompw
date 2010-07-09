;;; -*- Mode:Lisp; Syntax:ANSI-Common-Lisp; -*-

;;; By catalog, we mean here the ability of the target systems
;;; to display available interface functions (boxes) in menus
;;; OMPW's aim is to create those directly from the file content.

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

(in-package :ompw)

(define-menu ompw :print-name "ompw")
(define-menu file-dialogs :in ompw :print-name "File-Dialogs")
(in-menu file-dialogs)

;;; choose-new-file-dialog
#-(or pwgl om)
(define-box choose-new-file-dialog (&key (prompt "Enter the path for a new file:")
					 button-string)
  :non-generic t
  (declare (ignore button-string))
  (format *query-io* "~&~a~%[please enter a path like /tmp/test.txt]~%" prompt)
  (force-output *query-io*)
  (parse-namestring (read-line *query-io*)))

#+om
(define-box choose-new-file-dialog (&key (prompt "Enter the path for a new file:")
					 button-string)
  :non-generic t
  (ccl::choose-new-file-dialog :prompt prompt :button-string button-string))

#+pwgl
(define-box choose-new-file-dialog (&key (prompt "Enter the path for a new file:")
					 button-string)
  :non-generic t
  (capi:prompt-for-file prompt :operation :save))

;;; choose-file-dialog
#-(or pwgl om)
(define-box choose-file-dialog (&key (prompt "Enter the path for an existing file:")
				     button-string)
  :non-generic t
  (format *query-io* "~&~a~%[please enter a path like /tmp/test.txt]~%" prompt)
  (force-output *query-io*)
  (let ((path (parse-namestring (read-line *query-io*))))
    (if (probe-file path)
	path
	(progn
	  (format *query-io* "~&ERROR: ~A does not exist.~%" path)
	  (choose-file-dialog :prompt prompt :button-string button-string)))))



#+om
(define-box choose-file-dialog (&key (prompt "Enter the path for an existing file:")
				     button-string)
  :non-generic t
  (ccl::choose-file-dialog :prompt prompt :button-string button-string))

#+pwgl
(define-box choose-file-dialog (&key (prompt "Enter the path for an existing file:")
				     button-string)
  :non-generic t
  (capi:prompt-for-file prompt))

(install-menu ompw)
