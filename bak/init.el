;(setq debug-on-error t)
;(setq byte-compile-warnings nil)
(package-initialize)
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on t)

(setq my-lisp-root "~/.emacs.d/elisp")
(global-set-key (kbd "C-x M-y")
		(lambda ()
		  (interactive)
		  (insert-string (ns-get-pasteboard))))

(global-set-key (kbd "C-x M-w")
		(lambda ()
		  (interactive)
		  (when (region-active-p)
		    (ns-set-pasteboard
		     (buffer-substring (region-beginning)
				       (region-end))))))

;;setenv
(setenv "PATH" (concat (getenv "PATH") ";" (expand-file-name "~/.emacs.d/bin/glo662wb/bin")))

(add-to-list 'exec-path "c:/.emacs.d/bin/glo662wb/bin")

(setenv "PID" nil)

(setq package-archives
      '(("melpa-cn" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
        ("org-cn"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/org/")
        ("gnu-cn"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
        ;("gnu"      . "http://elpa.gnu.org/packages/")
        ))

(require 'package)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
(set-face-attribute 'default nil :height 200)

;;add load path
(add-to-list 'load-path "~/emacs-config")

(global-font-lock-mode t);语法高亮
(setq column-number-mode t);显示列号
(setq default-fill-column 120) ;默认显示 120列就换行
(setq tab-width 4) ; or any other preferred value
(setq-default indent-tabs-mode nil)
(setq default-tab-width 4);设置Tab宽度为4
(setq x-select-enable-clipboard t);支持emacs和外部程序的粘贴
;(setq frame-title-format "liqt@%b");在标题栏提示你目前在什么位置。你要把zhan改成自己的用户名
(tool-bar-mode 0);去掉那个大大的工具栏
(scroll-bar-mode 0);去掉滚动条
(display-time-mode 1)  ;;时间显示设置  启用时间显示设置，在minibuffer上面的那个杠上
(setq display-time-24hr-format t)  ;;时间使用24小时制
(setq display-time-day-and-date t)  ;;时间显示包括日期和具体时间
(setq display-time-format "%02m-%02d:%A:%H:%M") ;;显示时间的格式
(fset 'yes-or-no-p 'y-or-n-p) ;;所有的问题用y/n方式，不用yes/no方式。有点懒，只想输入一个字母
(mouse-avoidance-mode 'animate);光标靠近鼠标指针时，让鼠标指针自动让开，别挡住视线。很好玩阿，这个功能
(auto-image-file-mode t) ;;允许自动打开图片，如wiki里面
(show-paren-mode t);显示括号匹配
(ansi-color-for-comint-mode-on) ;; eshell 乱码问题
;; 设置主题颜色
(require 'color-theme)
(color-theme-initialize)
(color-theme-comidia)

(set-language-environment 'UTF-8)
(setenv "LC_CTYPE" "zh_CN.UTF-8")

;;
(setq-default buffer-file-coding-system 'utf-8-unix)
;;set the default text coding system
(setq default-buffer-file-coding-system 'utf-8-unix)

(if (string-equal system-type "windows-nt")
;	(setq file-name-coding-system 'euc-cn)
  (setq file-name-coding-system 'utf-8-unix))

(prefer-coding-system 'cp950)
(prefer-coding-system 'gb2312)
(prefer-coding-system 'cp936)
(prefer-coding-system 'gb18030)
(prefer-coding-system 'utf-16)
(prefer-coding-system 'utf-8-dos)
(prefer-coding-system 'utf-8-unix)

;;
;;页面平滑滚动， scroll-margin 5 靠近屏幕边沿3行时开始滚动，可以很好的看到上下文。
(setq scroll-margin 5
      scroll-conservatively 10000)
;; show line number
(require 'linum)
(setq linum-format "%4d ")
(global-linum-mode 1)
;;;;;; Emacs 中 shell 结束之后，自动关闭 shell buffer
(add-hook 'shell-mode-hook 'wcy-shell-mode-hook-func)
(defun wcy-shell-mode-hook-func  ()
  (set-process-sentinel (get-buffer-process (current-buffer))
						#'wcy-shell-mode-kill-buffer-on-exit)
  )
(defun wcy-shell-mode-kill-buffer-on-exit (process state)
  (message "%s" state)
  (if (or
       (string-match "exited abnormally with code.*" state)
       (string-match "finished" state))
      (kill-buffer (current-buffer))))

;;去掉行末空格
(add-hook 'before-save-hook 'delete-trailing-whitespace)
;;;;;
;;objc-mode
(add-to-list 'auto-mode-alist '("\\.mm\\'" . objc-mode))
(add-to-list 'auto-mode-alist '("\\.jeff\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.jmat\\'" . c++-mode))
;; Function to copy lines
;; "C-c w" copy one line, "C-u 5 C-c w" copy 5 lines
(defun copy-lines(&optional arg)
  (interactive "p")
  (save-excursion
	(beginning-of-line)
	(set-mark (point))
	(if arg
		(next-line (- arg 1)))
	(end-of-line)
	(kill-ring-save (mark) (point))
	)
  )
;; set key
(global-set-key (kbd "C-c w") 'copy-lines)
(global-set-key (kbd "C-c r") 'replace-string)

(global-set-key (kbd "C-9") 'ns-fullscreen)
(defun ns-fullscreen ()
  "Toggle full screen"
  (interactive)
  (set-frame-parameter
   nil 'fullscreen
   (when (not (frame-parameter nil 'fullscreen)) 'fullboth)))

;;org
(setq org-startup-indented t)
(setq org-src-fontify-natively t)
;; kill all other buffers
(defun kill-other-buffers ()
  "Kill all other buffers."
  (interactive)
  (mapc 'kill-buffer
		(delq (current-buffer)
			  (remove-if-not 'buffer-file-name (buffer-list)))))

(require 'ido)
(ido-mode t)

;iedit
(require 'iedit)

;cua
(cua-mode t)
(setq cua-auto-tabify-rectangles nil) ;; Don't tabify after rectangle commands
(transient-mark-mode 1) ;; No region when it is not highlighted
(setq cua-keep-region-after-copy t) ;; Standard Windows behaviour
;(cua-selection-mode t)

;;ctypes.el  可以识别你的 C 文件里的类型定义 (typedef)。自动对 它们进行语法加亮。
(require 'ctypes)
(ctypes-auto-parse-mode 1)

;;
;; cedet
(require 'cedet)
(require 'semantic/db)
(require 'semantic/tag)
(require 'semantic/lex)

(defgroup semantic nil
  "Parser Generator and parser framework."
  :group 'tools)

(defgroup semantic-faces nil
  "Faces used for Semantic enabled tools."
  :group 'semantic)

(require 'semantic/fw)
(global-ede-mode 1)                      ; Enable the Project management system
(require 'semantic)

;;下面配置一下semantic分析结果文件的存放目录.注意这个目录是要自己建立的
(setq semanticdb-default-save-directory
	  (expand-file-name "~/emacs-config/semanticdb"))

;;
;;
;;lua mode
(require 'lua-mode)
(autoload 'lua-mode "lua-mode" "Lua editing mode." t)
(add-to-list 'auto-mode-alist '("\\.lua$" . lua-mode))
(add-to-list 'interpreter-mode-alist '("lua" . lua-mode))
(setq lua-indent-level 4)
(require 'lua-block)
(lua-block-mode t)

;; csharp-mode
(defun my-csharp-mode-hook ()
  ;; enable the stuff you want for C# here
  (electric-pair-mode 1))
(add-hook 'csharp-mode-hook 'my-csharp-mode-hook)

;; ;; do overlay
(setq lua-block-highlight-toggle 'overlay)
;; ;; display to minibuffer
(setq lua-block-highlight-toggle 'minibuffer)
;; ;; display to minibuffer and do overlay
(setq lua-block-highlight-toggle t)

;;括号自动配对
;(add-hook 'c-mode-hook 'hs-minor-mode)
(defun my-c-mode-auto-pair ()
  (interactive)
  (setq skeleton-pair-alist nil)
  (make-local-variable 'skeleton-pair-alist)

  (setq skeleton-pair-alist '(
							  (?\'? _ "\'">)
							  (?\" _ "\"">)
							  (?\( _ ")">)
							  (?\[ _ "]">)
							  (?{ \n > _ \n ?} >)
							  ;(?\{ _ "}" >)
							  ))

  (setq skeleton-pair t)
  (local-set-key (kbd "(") 'skeleton-pair-insert-maybe)
  (local-set-key (kbd "{") 'skeleton-pair-insert-maybe)
  (local-set-key (kbd "\`") 'skeleton-pair-insert-maybe)
  (local-set-key (kbd "\"") 'skeleton-pair-insert-maybe)
  (local-set-key (kbd "[") 'skeleton-pair-insert-maybe))


(add-hook 'c-mode-hook 'my-c-mode-auto-pair)
(add-hook 'c++-mode-hook 'my-c-mode-auto-pair)
(add-hook 'java-mode-hook 'my-c-mode-auto-pair)
(add-hook 'lua-mode-hook 'my-c-mode-auto-pair)
(add-hook 'objc-mode-hook 'my-c-mode-auto-pair)
(add-hook 'csharp-mode-hook 'my-c-mode-auto-pair)
(add-hook 'lua-mode-hook 'my-c-mode-auto-pair)
(add-hook 'python-mode-hook 'my-c-mode-auto-pair)
(add-hook 'json-mode-hook 'my-c-mode-auto-pair)

(define-skeleton quoted-brace
  "Insert { ... }."
  nil "{" _ "}")
(global-set-key "\C-c{" 'quoted-brace)

;;gtags
(add-to-list 'load-path "~/.emacs.d/elisp")
(autoload 'gtags-mode "gtags" "" t)
(autoload 'gtags-mode "gtags" "" t)
(add-hook 'gtags-select-mode-hook
  '(lambda ()
        (setq hl-line-face 'underline)
        (hl-line-mode 1)
        ))

; Customization
(setq gtags-suggested-key-mapping t)
(setq gtags-auto-update t)

(defun gtagsHook ()
  (gtags-mode 1)
  )

(add-hook 'c-mode-hook 'gtagsHook)
(add-hook 'c++-mode-hook 'gtagsHook)
(add-hook 'lua-moode-hook 'gtagsHook)
(add-hook 'csharp-moode-hook 'gtagsHook)

(global-set-key (kbd "C-c j d") 'gtags-find-tag-from-here)
(global-set-key (kbd "C-c j e") 'gtags-select-tag)
(global-set-key (kbd "C-c j p") 'gtags-pop-stack)

(global-set-key (kbd "C-c g d") 'gtags-find-tag-from-here)
(global-set-key (kbd "C-c g f s") 'gtags-find-symbol)
(global-set-key (kbd "C-c g p") 'gtags-pop-stack)
;;mark
(global-set-key (kbd "C-c m f ") 'mark-defun)

(defun auto-comment-anything ()
  (interactive)
  (if (or (null transient-mark-mode) mark-active)
	  (comment-or-uncomment-region (region-beginning) (region-end))
	(comment-line)))

(add-hook 'csharp-mode-hook
          (lambda ()
            (linum-mode t)
            (local-set-key  (kbd "C-c C-c") 'auto-comment-anything)))

(add-hook 'c++-mode-hook
          (lambda ()
            (linum-mode t)
            (local-set-key  (kbd "C-c C-c") 'auto-comment-anything)))

(add-hook 'lua-mode-hook
          (lambda ()
            (linum-mode t)
            (local-set-key  (kbd "C-c C-c") 'auto-comment-anything)))

(global-set-key (kbd "C-c C-c")'auto-comment-anything)
(global-set-key (kbd "C-j")'goto-line)
(global-set-key (kbd "C-c f f")'gtags-find-file)


;; revert
(global-auto-revert-mode 1)
(setq auto-revert-verbose nil)
(global-set-key (kbd "C-c b r") 'revert-buffer)
;;

;;;;;;----psvn----;;;;
;(add-to-list 'load-path "~/dev/emacs-config/")
;(require 'psvn)
;;;;;;;;;;;;

(require 'yasnippet)
(yas-global-mode 1)
;;
(add-hook 'after-init-hook 'global-company-mode)
(setq company-idle-delay 0.5)
(setq company-minimum-prefix-length 2)
(setq company-dabbrev-ignore-case t)
(setq company-dabbrev-downcase nil)

(add-hook 'c-mode-hook 'company-mode)
(add-hook 'c++-mode-hook 'company-mode)
(add-hook 'lua-mode-hook 'company-mode)
(add-hook 'csharp-mode-hook 'company-mode)

(add-to-list 'load-path "~/emacs-config/pos-tip")
(require 'pos-tip)

;(setq global-auto-complete-mode nil)

(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)


;; began new tem bufer
(defvar scratch-run-alist
  '(("java"   . java-mode)
    ("c++"    . c++-mode)
    ("perl"   . perl-mode)
    ("python" . python-mode)
    ("js"     . javascript-mode)
    ("j"      . j-mode)
    ("tcl"    . tcl-mode))
  "生成草稿buffer的简短mode名称列表")
(defun scratch-run ()
  "Run a scratch"
  (interactive)
  (let ((mode (ido-completing-read
               "What kind of scratch mode ?:"
               (append (all-completions ""
                                        obarray
                                        (lambda (s)
                                          (and (fboundp s)
                                               (string-match "-mode$" (symbol-name s)))))
                       (mapcar 'car scratch-run-alist)))))
    (pop-to-buffer (get-buffer-create (format "* scratch * %s *" mode)))
    (funcall (if (assoc mode scratch-run-alist)
                 (cdr (assoc mode scratch-run-alist))
               (intern mode)))
    ))
;; end
;; Change the default eshell prompt
(setq eshell-prompt-function
      (lambda ()
        (concat (eshell/pwd) "\n $ ")))


(require 'session)
(add-hook 'after-init-hook 'session-initialize)
;;c++ mode style
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.vsh\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.fsh\\'" . c++-mode))


; style I want to use in c++ mode
(c-add-style "my-style"
	     '("linux"
	       (indent-tabs-mode . nil)        ; use spaces rather than tabs
	       (c-basic-offset . 4)            ; indent by four spaces
		   (c-set-offset 'substatement-open 0)
	       (c-offsets-alist . ((inline-open . 0)  ; custom indentation rules
				   (brace-list-open . 0)
				   (statement-case-open . +)))))

(defun my-c++-mode-hook ()
  (c-set-style "my-style")        ; use my-style defined above
  (auto-fill-mode))

;(add-hook 'c++-mode-hook 'my-c++-mode-hook)
(add-hook 'objc-mode-hook 'my-c++-mode-hook)
(add-hook 'java-mode-hook 'my-c++-mode-hook)

(add-to-list 'load-path "~/.emacs.d/elisp")
(require 'google-c-style)
(add-hook 'c-mode-common-hook 'google-set-c-style)
;; 80 colum
;;/Users/liqt/.emacs.d/elpa/column-marker-20121128.43
;(add-hook 'c-mode-hook 'font-lock-mode)
;(add-hook 'c++-mode-hook 'font-lock-mode)
;(add-hook 'lua-mode-hook 'font-lock-mode)

(add-to-list 'load-path "~/.emacs.d/elpa/column-marker-20121128.43")
(require 'column-marker)

;(set-face-background 'column-marker-1 "red")
(add-hook 'c++-mode-hook (lambda () (interactive) (column-marker-1 80)))
(add-hook 'c-mode-hook (lambda () (interactive) (column-marker-1 80)))
(add-hook 'lua-mode-hook (lambda () (interactive) (column-marker-1 120)))
(add-hook 'java-mode-hook (lambda () (interactive) (column-marker-1 120)))
										;(global-set-key [?\C-c ?m] 'column-marker-1)

(add-hook 'c-mode-hook 'column-enforce-mode)
(add-hook 'c++-mode-hook 'column-enforce-mode)
(add-hook 'lua-mode-hook 'column-enforce-mode)
(setq column-enforce-column 120)

;;yaml mode
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))

;;
;;------------------------------------------------------------------------------
;;代码折叠
;;------------------------------------------------------------------------------

(add-hook 'c++-mode-hook 'hs-minor-mode)
(add-hook 'csharp-mode-hook 'hs-minor-mode)
(add-hook 'c-mode-hook 'hs-minor-mode)
(add-hook 'java-mode-hook 'hs-minor-mode)
(add-hook 'lua-mode-hook 'hs-minor-mode)
(add-hook 'typescript-mode-hook 'hs-minor-mode)
(add-hook 'js2-mode-hook 'hs-minor-mode)
(add-hook 'yaml-mode-hook 'hs-minor-mode)
(global-set-key (kbd "C-c , h") 'hs-toggle-hiding)

;(autoload 'hideshowvis-enable "hideshowvis" "Highlight foldable regions")
;(autoload 'hideshowvis-symbols "hideshowvis" "Highlight foldable regions")
(add-to-list 'load-path "~/.emacs.d/elpa/hideshowvis-20130824.500")
(require 'hideshowvis)
(hideshowvis-symbols)

(autoload 'hideshowvis-minor-mode
  "hideshowvis"
  "Will indicate regions foldable with hideshow in the fringe."
  'interactive)

(add-to-list 'hs-special-modes-alist
			 '(ruby-mode
			   "\\(def\\|do\\|{\\)" "\\(end\\|end\\|}\\)" "#"
			   (lambda (arg) (ruby-end-of-block)) nil))

(dolist (hook (list 'emacs-lisp-mode-hook
                      'lisp-mode-hook
                      'ruby-mode-hook
                      'perl-mode-hook
                      'php-mode-hook
                      'html-mode-hook
                      ;'web-mode-hook
					  'sh-mode-hook
                      ;'multi-web-mode-hook
                      'python-mode-hook
                      ;'lua-mode-hook
                      'c-mode-hook
                      ;'java-mode-hook
                      'js-mode-hook
                      ;'css-mode-hook
                      'c++-mode-hook
					  'csharp-mode-hook
					  'objc-mode-hook))
    (add-hook hook 'hideshowvis-enable))

;change -/+ to ▼/▶
;(define-fringe-bitmap 'hideshowvis-hideable-marker [0 0 254 124 56 16 0 0])
;(define-fringe-bitmap 'hs-marker [0 32 48 56 60 56 48 32])

;(custom-set-faces
;    '(hs-fringe-face ((t (:foreground "#afeeee" :box (:line-width 2 :color "grey75" :style released-button)))))
;    '(hs-face ((t (:background "#444" :box t))))
;    '(hideshowvis-hidable-face ((t (:foreground "#2f4f4f"))))
;)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(hideshowvis-hidable-face ((t (:foreground "#00ff00"))))
 '(hs-face ((t (:background "#00ff00" :box t))))
 '(hs-fringe-face ((t (:foreground "#00ff00" :box (:line-width 2 :color "grey75" :style released-button))))))

(provide 'conf-hideshowvis)


;(hideshowvis-symbols)

;;remove all cr
(defun xsteve-remove-control-M ()
  "Remove ^M at end of line in the whole buffer."
  (interactive)
  (save-match-data
    (save-excursion
      (let ((remove-count 0))
        (goto-char (point-min))
        (while (re-search-forward (concat (char-to-string 13) "$") (point-max) t)
          (setq remove-count (+ remove-count 1))
          (replace-match "" nil nil))
        (message (format "%d ^M removed from buffer." remove-count))))))


;; magit
(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-x M-g") 'magit-dispatch-popup)

(defface hi-red-b '((t (:foreground "#e50062"))) t)

;; use emacs copy paste
(setq cua-enable-cua-keys nil)

;; active Org-babel languages
(org-babel-do-load-languages
 'org-babel-load-languages
 '(;; other Babel languages
   (plantuml . t)))

(setq plantuml-jar-path
      (expand-file-name "~/.emacs.d/bin/plantuml.jar"))

;; Enable plantuml-mode for PlantUML files
(add-to-list 'auto-mode-alist '("\\.plantuml\\'" . plantuml-mode))

(setq org-plantuml-jar-path
      (expand-file-name "~/.emacs.d/bin/plantuml.jar"))
(setq org-ditaa-jar-path
      (expand-file-name "~/.emacs.d/bin/ditaa0_9.jar"))
;;end plantuml
;;ditaa
(org-babel-do-load-languages
 'org-babel-load-languages
 '(;; other Babel languages
   (ditaa . t)
   (plantuml . t)
                                        ;(dot . t)
                                        ;(xxx . t)
   ))
                                        ;ditaa0_9.jar

                                        ;生成图像时不予提示
(setq org-confirm-babel-evaluate nil)

                                        ;预览图像
(add-hook 'org-babel-after-execute-hook 'bh/display-inline-images 'append)
                                        ; Make babel results blocks lowercase
(setq org-babel-results-keyword "results")

(defun bh/display-inline-images ()
  (condition-case nil
      (org-display-inline-images)
    (error nil)))


;;org-mode
(defun org-insert-src-block (src-code-type)
  "Insert a `SRC-CODE-TYPE' type source code block in org-mode."
  (interactive
   (let ((src-code-types
          '("emacs-lisp" "python" "C" "sh" "java" "js" "clojure" "C++" "css"
            "calc" "asymptote" "dot" "gnuplot" "ledger" "lilypond" "mscgen"
            "octave" "oz" "plantuml" "R" "sass" "screen" "sql" "awk" "ditaa"
            "haskell" "latex" "lisp" "matlab" "ocaml" "org" "perl" "ruby"
            "scheme" "sqlite")))
     (list (ido-completing-read "Source code type: " src-code-types))))
  (progn
    (newline-and-indent)
    (insert (format "#+BEGIN_SRC %s\n" src-code-type))
    (newline-and-indent)
    (insert "#+END_SRC\n")
    (previous-line 2)
    (org-edit-src-code)))

(add-hook 'org-mode-hook '(lambda ()
                            ;; turn on flyspell-mode by default
                            (flyspell-mode 1)
                            ;; C-TAB for expanding
                            (local-set-key (kbd "C-<tab>")
                                           'yas/expand-from-trigger-key)
                            ;; keybinding for editing source code blocks
                            (local-set-key (kbd "C-c s e")
                                           'org-edit-src-code)
                            ;; keybinding for inserting code blocks
                            (local-set-key (kbd "C-c s i")
                                           'org-insert-src-block)
                            ))

(setq org-src-fontify-natively t) ;语法高亮
(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "|" "DOING(i)" "|" "DONE(d)" "|" "FAIL(f)" "|" "PASS(p)")
              (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)" "PHONE" "MEETING"))))
(setq org-todo-keyword-faces
      (quote (("TODO" :foreground "red" :weight bold)
              ("DOING" :foreground "yellow" :weight bold)
              ("DONE" :foreground "forest green" :weight bold)
              ("BUG" :foreground "red" :weight bold)
              ("OPENED" :foreground "yellow" :weight bold)
              ("FIXED" :foreground "forest freen" :weight bold)
              ("CANCELLED" :foreground "blue" :weight bold)
              ("WAITING" :foreground "orange" :weight bold)
              ("HOLD" :foreground "magenta" :weight bold)
              ("CANCELLED" :foreground "forest green" :weight bold)
              ("MEETING" :foreground "forest green" :weight bold)
              ("OPEN" :foreground "forest green" :weight bold)
              ("FAIL" :foreground "red" :weight bold)
              ("PHONE" :foreground "forest green" :weight bold))))
;;end

(require 'window-number)
(window-number-mode 1)
;; customize
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (projectile highlight plantuml-mode magit ggtags anything-replace-string typescript-mode js2-mode csharp-mode company-lua youdao-dictionary bing-dict window-number org json-mode iedit helm-w3m w3m python-mode yasnippet ztree android-mode pos-tip markdown-mode hideshowvis fold-this fold-dwim column-marker column-enforce-mode))))


;;bing dic
(global-set-key (kbd "C-c d") 'bing-dict-brief)
(setq bing-dict-show-thesaurus 'both)
(setq bing-dict-pronunciation-style 'uk)

;;youdao dic
;; Enable Cache
(setq url-automatic-caching t)
;waka time
;(global-wakatime-mode)
;(custom-set-variables ’(wakatime-api-key "845f5cb0-83b0-48af-b66b-9357518721c4"))
;; Example Key binding
(global-set-key (kbd "C-c y") 'youdao-dictionary-search-at-point)

(global-set-key (kbd "C-x f") 'find-file-in-repository)
(global-set-key (kbd "C-c f l") 'find-file-in-project)
(global-set-key (kbd "C-x C-x") 'eshell)

 (defun grep2 ()
   "Run a grep using the Windows findstr command."
   (interactive)
   (let ((grep-command '("findstr /n /s   *.cpp *.c *.h" . 15)))
     (call-interactively 'grep)))
;; Integrate with popwin-el (https://github.com/m2ym/popwin-el)
;; (push "*Youdao Dictionary*" popwin:special-display-config)

;; Set file path for saving search history
;; (setq youdao-dictionary-search-history-file "~/.emacs.d/.youdao")

;; Enable Chinese word segmentation support (支持中文分词)
;; (setq youdao-dictionary-use-chinese-word-segmentation t)
;;
(setq switch-keymap (make-sparse-keymap))
  (define-key switch-keymap (kbd "<tab>") 'popup-next)
  (define-key switch-keymap (kbd "C-n") 'popup-next)
  (define-key switch-keymap (kbd "C-p") 'popup-previous)
  (define-key switch-keymap (kbd "<return>") 'popup-select)
  (setq buffer-switch-max 5)

  (defun buffer-switch ()
    (interactive)
    ;; all the buffers
    (setq full-buffer-list (mapcar (function buffer-name) (buffer-list)))
    (if buffer-switch-max
        (progn
          ;; if max specified, only take n buffers
          (setq buffer-select-list (subseq full-buffer-list 0 (- buffer-switch-max 1)))
          )
      ;; if not specified, take all
      (setq buffer-select-list full-buffer-list)
      )
    (setq dest-buffer (popup-menu* buffer-select-list :keymap switch-keymap))
    (switch-to-buffer dest-buffer)
    )
(desktop-save-mode)
;;这个东西必须放在最后
;;desktop.el是一个可以保存你上次emacs关闭时的状态，下一次启动时恢复为上次关闭的状态。就和vmware的suspend一样。
(load "desktop")
(desktop-load-default)
(desktop-read)
