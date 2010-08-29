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

(defvar *library-name* nil)

(defun nconc1 (list obj)
  (nconc list (list obj)))

(define-modify-macro nconc1f (obj) nconc1)

#+pwgl
(defun menu-spec2native (menu-spec)
  (labels ((collect-until-change (menu-items)
	     (destructuring-bind (first . rest)
		 menu-items
	       (cond
		 ((eq :menu-separator first)
		  (values :menu-separator rest))
		 ((listp first)
		  (values first rest))
		 ;; okay its a normal symbol
		 (t (loop
		       for items-tail on menu-items
		       for item = (car items-tail)
		       while (and (atom item)
				  (not (eq :menu-separator item)))
		       collect item into items
		       finally (return (values items items-tail)))))))
	   (split-menu-items (menu-items)
	     (multiple-value-bind (first rest)
		 (collect-until-change menu-items)
	       (cond
		 ((null rest) (list first))
		 (t (cons first (split-menu-items rest))))))
	   (convert (menu-spec)
	     (labels ((rec (items)
			(cond
			  ((null items) nil)
			  ((eq :menu-separator (first items))
			   (destructuring-bind (next . rest)
			       (rec (rest items))
			     `((:menu-component ,next)
			       ,@rest)))
			  ((stringp (caar items))
			   (destructuring-bind (first . rest)
			       items
			     `(,(convert first) ,@(rec rest))))
			  (t (cons (car items) (rec (cdr items)))))))
	       (destructuring-bind (name . items)
		   menu-spec
		 (cons name (rec (split-menu-items items)))))))
    `(:menu-component ,(convert menu-spec))))

#+om
(defun menu-spec2native (menu-spec)
  (labels ((symbols+sub-menus (items)
	     (loop for item in items
		if (listp item)
		collect (rec item) into sub-menus
		else collect (cond
			       ((eql item :menu-separator)
				'-)
			       (t item))
		into symbols
		finally (return (values symbols sub-menus))))
	   (rec (menu-spec)
	     (destructuring-bind (name . items)
		 menu-spec
	       (multiple-value-bind (symbols sub-menus)
		   (symbols+sub-menus items)
		 `(,name ,sub-menus nil ,symbols nil)))))
    (let ((rec (rec menu-spec)))
      (if (fourth rec)
	  ;; we have some functions directly on the first level
	  (list rec)
	  ;; we have only submenus on the first level
	  (second rec)))))

#-(or pwgl om)
(defun menu-spec2native (menu-spec)
  menu-spec)

#+pwgl
(defun %install-menu (native-menu-spec menu)
  (declare (ignore menu))
  (ccl::add-PWGL-user-menu native-menu-spec))

#+om
(defun %install-menu (native-menu-spec menu)
  (let ((om::*current-lib* (om::find-library (string-downcase (string menu)))))
    (unless om::*current-lib*
      (cerror "ok - go on" "Sorry, cannot find omlib from name ~s.
You should give your menu the same name as your library."
	      (string-downcase (string menu))))
    (om::fill-library native-menu-spec)))

#-(or pwgl om)
(defun %install-menu (native-menu-spec menu)
  )

(defstruct menu
  name print-name container items)

(defvar *menus* (make-hash-table))
(defvar *menu* nil)

(defmacro get-menu (name &optional errorp)
  (if errorp
      (let ((=name= (gensym "NAME")))
	`(let* ((,=name= ,name)
		(menu (gethash ,=name= *menus*)))
	   (assert menu nil "The menu of name ~S does not exist.~
			     ~%Maybe you have forgotten to add a DEFINE-MENU~
			     ~%and an IN-MENU before your first DEFINE-BOX." ,=name=)
	   menu))
      `(gethash ,name *menus*)))

(defun menu-add-item (menu item)
  (when (symbolp menu)
    (setq menu (get-menu menu t)))
  (nconc1f (menu-items menu) item))

(defmacro define-menu (name &key print-name in)
  (check-type name symbol)
  (check-type in symbol)
  (when (keywordp name) (warn "It is not recommended to use a keyword for a menu name.
Better use a normal symbol instead."))
  (unless print-name (setq print-name (string-capitalize (string name))))
  `(eval-when (:load-toplevel :execute)
     ,@(when in `((assert (get-menu ',in))))
     (let ((new-menu (setf (get-menu ',name) (make-menu :name ',name :print-name ,print-name :container ',in))))
       (declare (ignorable new-menu))
       ,@(when in `((menu-add-item (get-menu ',in) new-menu)))
       ',name)))

(defmacro in-menu (name)
  (check-type name symbol)
  `(eval-when (:load-toplevel :execute)
     (setq *menu* (get-menu ',name t))))

(defmacro menu-separator (&key in)
  (check-type in symbol)
  `(eval-when (:load-toplevel :execute)
     (menu-add-item
      ,(if in `(get-menu ',in t) '*menu*)
      :menu-separator)))

(defgeneric menu-spec (menu)
  (:method ((menu menu))
    (cons (menu-print-name menu)
	  (mapcar #'menu-spec (menu-items menu))))
  (:method (obj) obj))

(defun install-menu* (menu)
  (assert (symbolp menu))
  (%install-menu (menu-spec2native (menu-spec (get-menu menu t)))
		 menu))

(defmacro install-menu (name)
  (check-type name symbol)
  `(eval-when (:load-toplevel :execute)
     (install-menu* ',name)))

(defmacro menu-add-symbol (symbol)
  (check-type symbol symbol)
  `(eval-when (:load-toplevel :execute)
     (export ',symbol)
     (menu-add-item *menu* ',symbol)))
