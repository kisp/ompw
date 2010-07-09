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

(in-package :ompw)

(rtest:deftest menu1
  (menu-spec2native '("ks"
		      ("file1" cl:+ cl:-)
		      ("file2" * + / :menu-separator +)
		      ("file3" ("first" * + /) ("second" +))
		      ("file4" * + / ("second" +))))
  #+pwgl
  (:menu-component
   ("ks"
    ("file1" (+ -))
    ("file2" (* + /) (:menu-component (+)))
    ("file3" ("first" (* + /)) ("second" (+)))
    ("file4" (* + /) ("second" (+)))))
  #-(or pwgl)
  #.(error "do not know how to test this"))

(rtest:deftest menu2
  (menu-spec2native '("KS"
		      ("file1" cl:+ cl:-)
		      ("file2" * + /)))
  #+pwgl
  (:menu-component
   ("KS"
    ("file1"
     (+ -))
    ("file2"
     (* + /))))
  #-(or pwgl)
  #.(error "do not know how to test this"))

(rtest:deftest menu3
  (menu-spec2native '("Esquisse"
		      ("Intervals"
		       ("Generation" + - +)
		       ("Treatment" subseq append)
		       ("Analysis" list))
		      ("Freq harmony"
		       ("Harm Series" subseq)
		       ("Modulations" list)
		       ("Treatment" + - +)
		       ("Analysis" subseq append :menu-separator +))
		      ("Utilities"
		       subseq append
		       :menu-separator
		       + - +
		       :menu-separator
		       list)))
  #+pwgl
  (:menu-component
   ("Esquisse"
    ("Intervals"
     ("Generation" (cl:+ cl:- cl:+))
     ("Treatment" (cl:subseq cl:append))
     ("Analysis" (cl:list)))
    ("Freq harmony"
     ("Harm Series" (cl:subseq))
     ("Modulations" (cl:list))
     ("Treatment" (cl:+ cl:- cl:+))
     ("Analysis" (cl:subseq cl:append)
		 (:menu-component (cl:+))))
    ("Utilities" (cl:subseq cl:append)
		 (:menu-component (cl:+ cl:- cl:+))
		 (:menu-component (cl:list))
		 )))
  #-(or pwgl)
  #.(error "do not know how to test this"))
