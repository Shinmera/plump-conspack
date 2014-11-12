#|
 This file is a part of Plump
 (c) 2014 Shirakumo http://tymoon.eu (shinmera@tymoon.eu)
 Author: Nicolas Hafner <shinmera@tymoon.eu>
|#

(in-package #:cl)
(asdf:defsystem plump-conspack
  :name "Plump-Conspack"
  :version "0.1.0"
  :license "Artistic"
  :author "Nicolas Hafner <shinmera@tymoon.eu>"
  :maintainer "Nicolas Hafner <shinmera@tymoon.eu>"
  :description "Conspack storage support for the Plump DOM."
  :homepage "https://github.com/Shinmera/plump-conspack"
  :serial T
  :components ((:file "plump-conspack"))
  :depends-on (:plump :cl-conspack :closer-mop))
