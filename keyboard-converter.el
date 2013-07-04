;;; -*- coding: utf-8; mode: emacs-lisp; -*-
;;; keyboard-converter.el --- package to define keybind that it converted from 104/109 to 109/104

;; Copyright (C) 2013 by Yuta Yamada

;; Author: Yuta Yamada <cokesboy"at"gmail.com>
;; Version: 0.0.1
;;; License:
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

(eval-when-compile (require 'cl))

(defvar keyboard-converter-104:109-keyboard-alist
  '(("@" . "\"")
    ("\\^" . "&")
    ("&" . "'")
    ("*" . "(")
    ("(" . ")")
    ("_" . "=")
    ("=" . "^")
    ("+" . "~")
    ("\\[" . "@")
    ("{" . "`")
    ("]" . "[")
    ("}" . "{")
    (":" . "+")
    ("`" . "*")))

(defvar keyboard-converter-109:104-keyboard-alist
  '(("\"" . "@")
    ("&" . "^")
    ("'" . "&")
    ("(" . "*")
    (")" . "(")
    ("=" . "_")
    ("\\^" . "=")
    ("~" . "+")
    ("@" . "[")
    ("`" . "{")
    ("\\[" . "]")
    ("{" . "}")
    ("+" . ":")
    (":" . "'")
    ("*" . "`")))

(defun keyboard-converter-find (key  &optional keyboard)
  (cl-loop
   for (from . to) in (or keyboard keyboard-converter-104:109-keyboard-alist)
   if (string-match from key)
   do (return (replace-regexp-in-string from to key))
   finally return (message key)))

(defun keyboard-converter-setup-keybinds (key-and-func-alist
                                         &optional keymap keyboard-alist)
  (loop for (key function) in key-and-func-alist
        for func = (if function
                       function
                     '(lambda () (interactive) nil))
        for converted-key = (kbd (keyboard-converter-find key keyboard-alist))
        if keymap
        do   (define-key keymap converted-key func)
        else do (global-set-key converted-key func)))

;; Test
;; (equal (kbd (keyboard-converter-find "C-@"))
;;        (kbd "C-\""))

(provide 'keyboard-converter)
