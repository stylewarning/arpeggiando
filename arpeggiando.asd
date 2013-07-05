;;;; arpeggiando.asd
;;;; Copyright (c) 2013 Robert Smith

#+#:ignore
(push #P"/Users/quad/Source/My/arpeggiando/lib/"
      cffi:*foreign-library-directories*)

(asdf:defsystem #:arpeggiando
  :serial t
  :description "A library for musical visualization."
  :author "Robert Smith <quad@symbo1ics.com>"
  :license "Richard Stallman License"
  :components ((:file "package")
               (:file "arpeggiando"))
  :depends-on ("cl-portaudio" "iolib.trivial-sockets"))

