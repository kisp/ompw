;;; arch-tag: 153F21EC-B49A-465A-B293-D4FD6FD1B197

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

(in-package :cl-user)

;; this file was intended to be a load file for people
;; that do not use ASDF
;; for the unlikely case, you can comment out the code below

;; for now, let's just call ASDF to do the job

(asdf:oos 'asdf:load-op :ompw)

;; (let ((ompw-base-directory
;;        (make-pathname :name nil :type nil :version nil
;;                    :defaults (parse-namestring *load-truename*)))
;;       must-compile)
;;   (with-compilation-unit ()
;;     (dolist (file '("package"
;;                  "define-box"
;;                  "pprint-define-box"
;;                  ))
;;       (let ((pathname (make-pathname :name file :type "lisp" :version nil
;;                                      :defaults ompw-base-directory)))
;;         (let ((compiled-pathname (compile-file-pathname pathname)))
;;           (unless (and (not must-compile)
;;                        (probe-file compiled-pathname)
;;                        (< (file-write-date pathname)
;;                           (file-write-date compiled-pathname)))
;;             (setq must-compile t)
;;             (compile-file pathname))
;;           (setq pathname compiled-pathname))
;;         (load pathname)))))
