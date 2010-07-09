(let ((*default-pathname-defaults* *load-truename*))
  ;; using om::compile&load did not work
  (load (compile-file "package.lisp"))
  (load (compile-file "menu.lisp"))
  (load (compile-file "define-box.lisp"))
  (load (compile-file "file-dialog.lisp"))
  (load (compile-file "pprint-define-box.lisp")))
