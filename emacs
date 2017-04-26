;;;;;;;;;;;;;;;env
(setq exec-path (append  '("/usr/bin/" "/usr/local/bin" "~/workspaces/gopjt/bin") exec-path))

;;;;;;;;;;;;;;;el-get
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(unless (require 'el-get nil 'noerror)
(with-current-buffer
(url-retrieve-synchronously
	       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
       (goto-char (point-max))
(eval-print-last-sexp)))

(setq my-el-get-packages
      '(auto-complete cl-lib company-mode el-get fuzzy gnuplot-mode go-autocomplete go-company go-def go-mode paredit popup pymacs rope ropemacs ropemode yasnippet))

;(el-get 'sync my-el-get-packages)

;;;;;;;;;;;;;;;;;;;;;;;; mac specific settings
(when (eq system-type 'darwin)
  (setq mac-option-modifier 'alt)
  (setq mac-command-modifier 'meta)
  (global-set-key [kp-delete] 'delete-char) ;; sets fn-delete to be right-delete
  )
;;;;;;;;;;;;;;;;;;;;;;;
;; (when (eq system-type 'gnu/linux)
;;   (setq x-super-keysym 'meta)
;;   )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;mirrors
(when (>= emacs-major-version 24)
  (require 'package)
  (package-initialize)
  (setq package-archives '(("gnu"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
			   ("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
			   ("org" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/org/")
			   ("gnu" . "https://elpa.gnu.org/packages/")
			   ("melpa" . "https://melpa.org/packages/")
			   ("marmalade" . "https://marmalade-repo.org/packages/")
			   )))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(display-time-mode t)
(flyspell-prog-mode)
(global-prettify-symbols-mode 1)
(setq user-full-name "fikgol")
(setq user-mail-address "hit.cs.lijun@gmail.com")
(global-set-key "\C-c\C-c" 'comment-region)
(global-set-key "\C-c\C-v" 'uncomment-region)
(global-set-key "\C-h" 'delete-backward-char)
(global-set-key "\M-h" 'backward-kill-word)
(global-set-key (kbd "C-c r") 'rename-buffer)
(global-set-key "\M-`" nil)
;;(setq shell-file-name "/bin/bash")
;;以server模式启动
;;(server-start)
(put 'set-goal-column 'disabled nil)
(put 'erase-buffer 'disabled nil)
(add-to-list 'load-path "~/.emacs.d/auto-save-list/")
(require 'linum) ;显示列号
(global-linum-mode 1)
(setq column-number-mode t)
(setq line-number-mode t)
;;高亮显示成对括
;; 以 y/n代表 yes/no
(fset 'yes-or-no-p 'y-or-n-p)
;;语法加亮
(global-font-lock-mode t)
;;ctrl-shift-space to set-mark
(global-set-key [?\s- ] 'set-mark-command)
;; ;;c-x b
(iswitchb-mode 1)
;;c-c c-b;c-x c-f
(require 'bs)
(global-set-key (kbd "C-c C-b") 'bs-show)
(when (fboundp 'winner-mode)
  (winner-mode)
  (windmove-default-keybindings))
(icomplete-mode)
;;reflash the buffer
(defun refresh-file ()
  (interactive)
  (revert-buffer t (not (buffer-modified-p)) t))
(global-set-key [(control f5)] 'refresh-file)

;;stardict for emacs
;;1.sdcv :apt-get
(global-set-key (kbd "C-c c") 'kid-sdcv-to-buffer)
(defun kid-sdcv-to-buffer ()
  (interactive)
  (let ((word (if mark-active
		  (buffer-substring-no-properties (region-beginning) (region-end))
		(current-word nil t))))
					;(setq word (read-string (format "Search the dictionary for (default %s): " word)
					;nil nil word))
    (set-buffer (get-buffer-create "*sdcv*"))
    (buffer-disable-undo)
    (erase-buffer)
    (let ((process (start-process-shell-command "sdcv" "*sdcv*" "sdcv" "-n" word)))
      (set-process-sentinel
       process
       (lambda (process signal)
	 (when (memq (process-status process) '(exit signal))
	   (unless (string= (buffer-name) "*sdcv*")
	     (setq kid-sdcv-window-configuration (current-window-configuration))
	     (switch-to-buffer-other-window "*sdcv*")
	     (local-set-key (kbd "d") 'kid-sdcv-to-buffer)
	     (local-set-key (kbd "q") (lambda ()
					(interactive)
					(bury-buffer)
					(unless (null (cdr (window-list))) ; only one window
					  (delete-window)))))
	   (goto-char (point-min))))))))
;;设置tab为4个空格的宽度
(setq indent-tabs-mode nil)
(setq tab-width 4)

;;备份设置
(setq
 backup-by-copying t ; 自动备份
 backup-directory-alist
 '(("." . "~/.saves")) ; 自动备份在目录"~/.saves"下
 delete-old-versions t ; 自动删除旧的备份文件
 kept-new-versions 6 ; 保留最近的6个备份文件
 kept-old-versions 2 ; 保留最早的2个备份文件
 version-control t) ; 多次备份


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;auto-complete
(require 'auto-complete-config)
(ac-config-default)

;;m-n and m-p
;;c-s to filter
;;self dict
;;~/.dict
;;ac-clear-dictionary-cache


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;org-mode
(setq org-html-validation-link nil)
(setq org-export-html-postamble nil)

;;org-todo set
(add-hook 'org-mode-hook (lambda () (setq truncate-lines nil)))
(setq org-agenda-files (list "~/documents/org/agenda/"))
(global-set-key "\C-ca" 'org-agenda)
(define-key global-map "\C-cl" 'org-store-link)
					;todo done with time
(setq org-log-done t)
					;indented
					;(setq org-startup-indented t)
;;iimage mode
(autoload 'iimage-mode "iimage" "Support Inline image minor mode." t)
(autoload 'turn-on-iimage-mode "iimage" "Turn on Inline image minor mode." t)
					;org-export set
(setq org-image-actual-width nil)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;python coding
;;complete use M-/
;; config the ~/.ropeproject/config.py, to add the path of python lib but,Defalut is not need:
;;such as  prefs.add('python_path','/usr/lib/python2.7')
;;show the document use c-c d;c-c p to lookup pydoc; M-/ to rope complete

(require 'pymacs)
(autoload 'pymacs-apply "pymacs")
(autoload 'pymacs-call "pymacs")
(autoload 'pymacs-eval "pymacs" 0 t)
(autoload 'pymacs-exec "pymacs" 0 t)
(autoload 'pymacs-load "pymacs" 0 t)
;; ;; Initialize Rope
(pymacs-load "ropemacs" "rope-")
(setq ropemacs-enable-autoimport t)
					;lookup pydoc
(defun hohe2-lookup-pydoc ()
  (interactive)
  (let ((curpoint (point)) (prepoint) (postpoint) (cmd))
    (save-excursion
      (beginning-of-line)
      (setq prepoint (buffer-substring (point) curpoint)))
    (save-excursion
      (end-of-line)
      (setq postpoint (buffer-substring (point) curpoint)))
    (if (string-match "[_a-z][_\\.0-9a-z]*$" prepoint)
	(setq cmd (substring prepoint (match-beginning 0) (match-end 0))))
    (if (string-match "^[_0-9a-z]*" postpoint)
	(setq cmd (concat cmd (substring postpoint (match-beginning 0) (match-end 0)))))
    (if (string= cmd "") nil
      (let ((max-mini-window-height 0))
        (shell-command (concat "pydoc " cmd))))))

;; (defun py-test-save-hook()
;;   "python Test of save hook"
;;   (when (eq major-mode 'python-mode)
;;     (shell-command (concat "source ~/workspaces/baidu/spock/build/pythonenv/bin/activate ;python -m doctest " (buffer-file-name)))))

(add-hook 'python-mode-hook
          (lambda ()
            (setq elpy-rpc-python-command "python2")
            (elpy-enable)
	    (auto-complete-mode nil)
            (setq indent-tabs-mode nil)
            (setq tab-width 4)
            (setq-default python-indent 4)
            (setq-default py-indent-offset 4)
            (setq py-guess-indent-offset 4)
            (setq py-autopep8-options '("--max-line-length=79"))
            (add-to-list 'write-file-functions 'delete-trailing-whitespace)
            (local-set-key (kbd "C-c p") 'hohe2-lookup-pydoc)
	    (local-set-key (kbd "M-n") (next-mode-buffer "py"))
            ;(add-hook 'before-save-hook 'py-autopep8-buffer nil t);install py-autopep8
            ))


;;;;;;;;;;;;;dash;;;;;
(autoload 'dash-at-point "dash-at-point"
  "Search the word at point with Dash." t nil)
(global-set-key "\C-c\C-s" 'dash-at-point)
(global-set-key "\C-c\C-p" 'dash-at-point-with-docset)


;;;;;;gnuplot mode
(require 'gnuplot)
(local-set-key "\M-\C-g" 'org-plot/gnuplot)
(autoload 'gnuplot-mode "gnuplot" "gnuplot major mode" t)
(autoload 'gnuplot-make-buffer "gnuplot" "open a buffer in gnuplot-mode" t)
(setq auto-mode-alist (append '(("\\.gp$" . gnuplot-mode))
			      auto-mode-alist))

;;;;;;;;;;;;;;;;;;;;;;;;org mode
(add-hook 'org-mode-hook (lambda ()
			   (setq truncate-lines nil)))
(setq org-src-fontify-natively t)
(setq org-log-done 'time)
(setq org-log-done 'note)
;; active Babel languages
(org-babel-do-load-languages
 'org-babel-load-languages
 '((sh .t)
   (python .t)
   (emacs-lisp .t)
   ))

					; export html with custom inline css
(defun my-inline-custom-css-hook ()
  "insert custom inline css content into org export"
  (let* ( (working-path (ignore-errors (file-name-directory (buffer-file-name))))
	  (custom-css (concat working-path "style.css"))
	  (custom-css-flag (and (not (null working-path)) (not (null (file-exists-p custom-css)))))
	  (target-css (if custom-css-flag
			  custom-css
			"~/.emacs.d/org-style.css")))
    ;; (setq org-export-html-style-include-default nil)
    (setq org-html-head (concat
			 "<style type=\"text/css\">\n"
			 "<!--/*--><![CDATA[/*><!--*/\n"
			 (with-temp-buffer
			   (insert-file-contents target-css)
			   (buffer-string))
			 "/*]]>*/-->\n"
			 "</style>\n"))))
(add-hook 'org-mode-hook 'my-inline-custom-css-hook)

;;;;;;;;;;;;;;;;;;;;;;html5 org-html5present
					;(add-to-list 'load-path "~/.emacs.d/org-html5presentation.el")
					;(require 'ox-html5presentation)

;; haskell mode ==============================
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
;; xelatex ==========================
;; add this to support chinese
;; #+LATEX_HEADER:\usepackage{fontspec}
;; #+LATEX_HEADER: \setromanfont{Songti TC}
;; #+LATEX_HEADER:\XeTeXlinebreaklocale "zh"
;; #+LATEX_HEADER:\XeTeXlinebreakskip = 0pt plus 1pt minus 0.1pt
;; beamer support for chinese
;; #+LATEX_HEADER: \usepackage{xeCJK}
;; #+LATEX_HEADER: \setCJKmainfont{STHeiti:style=Light}
;; #+LATEX_HEADER: \XeTeXlinebreaklocale "zh"
;; #+LATEX_HEADER: \XeTeXlinebreakskip = 0pt plus 1pt minus 0.1pt
;; #+latex_header: \mode<beamer>{\usetheme{Berkeley}}
;; #+latex_header: \mode<beamer>{\usecolortheme{seagull}}
;; #+startup: beamer
;; #+LaTeX_CLASS: beamer
;; #+LaTeX_CLASS_OPTIONS: [bigger]

;; (setq latex-run-command "xelatex")
;; (setq org-latex-to-pdf-process '("xelatex %f"))

;; evaluation for dot
;; 1.C-c C-c to evaluate dot code
;; 2.C-c C-x C-v to toggle display of inline images
;;;;;;;;;;;;;;;;;;;;;;;;image-base64;;;;;;;;;;;;;;;;;;;;;;;
;; #+BEGIN_SRC python :results output raw :exports results
;; with open('eg-cors-1.png', 'rb') as image:
;;   from base64 import b64encode
;;   data = image.read()
;;   print '<img width="1000px" height="800px" src="data:image/*;base64,%s">' % b64encode(data)
;; #+END_SRC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;latex pdf;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; #+OPTIONS: ':nil *:t -:t ::t <:t H:3 \n:nil ^:t arch:nil
;; #+OPTIONS: author:t c:nil creator:comment d:(not "LOGBOOK") date:t
;; #+OPTIONS: e:t email:nil f:t inline:t num:nil p:nil pri:nil stat:t
;; #+OPTIONS: tags:t tasks:t tex:t timestamp:t toc:nil todo:t |:t
;; #+DESCRIPTION:
;; #+KEYWORDS:
;; #+LANGUAGE: en
;; #+SELECT_TAGS: export
;; #+LATEX_CLASS: article
;; #+LATEX_CLASS_OPTIONS:
;; #+LATEX_HEADER: \usepackage{fontspec}
;; #+LATEX_HEADER: \setromanfont{STHeiti:style=Light}
;; #+LATEX_HEADER:\XeTeXlinebreaklocale "zh"
;; #+LATEX_HEADER:\XeTeXlinebreakskip = 0pt plus 1pt minus 0.1pt
;; #+LATEX_HEADER_EXTRA:


(org-babel-do-load-languages
 'org-babel-load-languages
 '((dot . t)))

;; html 4 space
(add-hook 'html-mode-hook
	  (lambda()
	    (setq sgml-basic-offset 4)
	    (setq indent-tabs-mode t)))


;;org-present
(autoload 'org-present "org-present" nil t)
(add-hook 'org-present-mode-hook
	  (lambda ()
	    (org-present-big)
	    (org-display-inline-images)))
(add-hook 'org-present-mode-quit-hook
	  (lambda ()
	    (org-present-small)
	    (org-remove-inline-images)))

;;org-publish
(require 'ox-publish)
(setq org-publish-project-alist
      '(

	;; ... add all the components here (see below)...
	("org-notes"
	 :base-directory "/Users/fikgol/documents/mysite/"
	 :base-extension "org"
	 :publishing-directory "/Users/fikgol/documents/mysite/publish_html"
	 :recursive t
	 :publishing-function org-html-publish-to-html
	 :headline-levels 4             ; Just the default for this project.
	 :auto-preamble t
	 :auto-sitemap t                ; Generate sitemap.org automagically...
	 :sitemap-filename "sitemap.org"  ; ... call it sitemap.org (it's the default)...
	 :sitemap-title "Sitemap"         ; ... with title 'Sitemap'.
	 :style "<link rel=\"stylesheet\"
href=\"/Users/fikgol/documents/mysite/publish_html/css/stylesheet.css\"
type=\"text/css\"/>"
	 )
	("org-static"
	 :base-directory "/Users/fikgol/documents/mysite/"
	 :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
	 :publishing-directory "/Users/fikgol/documents/mysite/publish_html"
	 :recursive t
	 :publishing-function org-publish-attachment
	 )
	("org" :components ("org-notes" "org-static"))
	)
      )
;;;;;;;;;;;;;;;;;;;;;;;clojure;;;;;;;;;;;;;;;;;
;;http://cider.readthedocs.org/en/latest/configuration/#auto-completion

(add-hook 'clojure-mode-hook
	  (lambda ()
	    ;(smartparens-mode)
        (setq paredit-mode t)
	    (setq company-mode t)
	    (setq eldoc-mode t)))




;;;;;;;;;;;;golang;;;;;;;;;;;;;;
(require 'go-autocomplete)
(require 'go-guru)

(add-hook 'go-mode-hook
	  (lambda ()
	    (setq tab-width 4)
	    (add-hook 'after-save-hook 'gofmt-before-save)
	    (local-set-key (kbd "M-n") (next-mode-buffer ".go"))
	    (go-guru-hl-identifier-mode)
	    (local-set-key (kbd "C-c C-j") 'go-guru-definition)
	    ))
;(go-gopath-set-gopath "~/workspaces/gopjt")

;;;;;;;;;;;;;;sawfish-mode;;;;;;;;;;;;;;;;;
(autoload 'sawfish-mode "sawfish" "sawfish-mode" t)
(put 'upcase-region 'disabled nil)

;;;;;;;;;;;;;;;draft;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'yasnippet)
(yas-minor-mode)
(global-set-key (kbd "M-*") 'pop-tag-mark)
(global-set-key (kbd "M-p") 'previous-buffer)
(global-set-key (kbd "M-n") 'previous-buffer)

;; Unconditionally kill unmodified buffers.
(defun volatile-kill-buffer ()
   "Kill current buffer unconditionally."
   (interactive)
   (let ((buffer-modified-p nil))
     (kill-buffer (current-buffer))))
(global-set-key (kbd "C-x k") 'volatile-kill-buffer)

;; Move to the next buffer with the spec suffix
(defun find-match(l mode-suffix)
  (when l
    (if (string-suffix-p mode-suffix (car l))
	(car l)
      (find-match (cdr l) mode-suffix))))

(defun find-match-after-current(l mode-suffix)
  (setq-local local-pos (seq-position l  (buffer-name (current-buffer))))
  (setq-local next-l
	      (seq-concatenate
	       'list
	       (seq-subseq l  (+ 1 local-pos))
	      (seq-subseq l 0 local-pos))
	      )
  (find-match next-l mode-suffix)
  )

(defun swtich-to-next-mode-buffer (mode-suffix)
  (setq-local sort-l (sort (mapcar 'buffer-name (buffer-list)) 'string<))
  ;(setq-local l (mapcar 'buffer-name (buffer-list)))
  (setq-local dst-buffer (find-match-after-current sort-l mode-suffix))
  (switch-to-buffer dst-buffer)
  )

(defun next-mode-buffer (mode-suffix)
  (lexical-let ((mode-suffix mode-suffix))
    (lambda (&optional windows)
      (interactive)
      (swtich-to-next-mode-buffer mode-suffix))))

;(helm-mode nil)
;(global-set-key (kbd "M-x") 'helm-M-x)
;(global-set-key (kbd "C-x C-f") 'helm-find-files)
;; elisp
(add-hook 'emacs-lisp-mode-hook
	  (lambda ()
	    ;(smartparens-mode)
        (paredit-mode t)
	(company-mode t)
	(eldoc-mode t)))

;; do not ask me "symbolic link to git-controlled source file ..."
(setq vc-follow-symlinks nil)
;; disable scroball bar at right handle
(scroll-bar-mode -1)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;display
(set-face-attribute 'default nil
 		    :family "PragmataPro" :height 140 :weight 'normal)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(custom-safe-themes
   (quote
    ("1b4ebe753ab8c750ba014c0e80c0c5272b63f1a6e0cba0e0d992e34d36203ee6" default)))
 '(display-time-mode t)
 '(package-selected-packages
   (quote
    (imenu-list yasnippet-bundle w3m swiper smartparens scala-mode2 sbt-mode robots-txt-mode python-docstring pyenv-mode py-autopep8 paredit ox-rst ox-reveal org-tree-slide org-preview-html org-present org-ac nurumacs nose markdown-preview-mode markdown-preview-eww magit-gitflow magit-gerrit lua-mode json-mode jedi-direx helm-gitlab helm-cscope haskell-mode graphviz-dot-mode golint go-rename go-guru go-gopath go-errcheck go-complete go-autocomplete gnuplot-mode gnuplot git flymake-python-pyflakes exec-path-from-shell elpy elpa-mirror elein company-go color-theme clojure-cheatsheet auto-yasnippet ac-cider 4clojure)))
 '(show-paren-mode t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
