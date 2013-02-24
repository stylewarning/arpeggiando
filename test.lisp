(in-package :portaudio)

(defparameter +frames-per-buffer+ 1024)
(defparameter +sample-rate+ 44100d0
  "Audio samples per second.")
(defparameter +seconds+ 15)
(defparameter +sample-format+ :float)
(defparameter +num-channels+ 2)


(defun test-echo (time-in-seconds)
  "Record input into an array; Separate array to channels; Merge
channels into array; Play last array."
  (with-audio
    (format t "~%=== Wire on. Will run ~D seconds . ===~%" +seconds+) 
    (with-default-audio-stream (astream +num-channels+ +num-channels+
                                :sample-format +sample-format+
                                :sample-rate +sample-rate+
                                :frames-per-buffer +frames-per-buffer+) 
      (dotimes (i (round (* time-in-seconds +sample-rate+) +frames-per-buffer+))
        (write-stream
         astream
         (merge-channels-into-array
          astream
          (separate-array-to-channels astream
                                      (read-stream astream))))))))

(defun read-microphone (time-in-seconds)
  (with-audio
    (with-default-audio-stream (astream +num-channels+ +num-channels+
                                :sample-format +sample-format+
                                :sample-rate +sample-rate+
                                :frames-per-buffer +frames-per-buffer+)
      (loop :repeat (round (* time-in-seconds +sample-rate+)
                           +frames-per-buffer+)
            :do (format t "~F~%" (aref (read-stream astream) 0))))))

(let ((a (make-array
          (* +frames-per-buffer+ +num-channels+)
          :element-type 'single-float
          :initial-contents (loop :for i :below 2048.0s0
                                  :collect (* 32.0s0 (sin 
                                                      (/ (* 2.0s0 spi i)
                                                         2048.0s0)))))))
  (defun play-sound (time-in-seconds)
    (with-audio
      (with-default-audio-stream (astream +num-channels+ +num-channels+
                                  :sample-format +sample-format+
                                  :sample-rate +sample-rate+
                                  :frames-per-buffer +frames-per-buffer+)
        (loop :repeat (round (* time-in-seconds +sample-rate+)
                             +frames-per-buffer+)
              :do (write-stream astream a))))))

(defun play-samples (samples)
    (with-audio
      (with-default-audio-stream (astream +num-channels+ +num-channels+
                                  :sample-format +sample-format+
                                  :sample-rate +sample-rate+
                                  :frames-per-buffer +frames-per-buffer+)
        (dolist (sample samples)
          (write-stream astream sample)))))

(defun record-microphone (time-in-seconds)
  (with-audio
    (with-default-audio-stream (astream +num-channels+ +num-channels+
                                :sample-format +sample-format+
                                :sample-rate +sample-rate+
                                :frames-per-buffer +frames-per-buffer+)
      (loop :repeat (round (* time-in-seconds +sample-rate+)
                           +frames-per-buffer+)
            :collect (read-stream astream)))))

(defun echo-for (time-in-seconds)
  (format t "RECORDING...~%")
  (force-output)
  (let ((samples (record-microphone time-in-seconds)))
    (format t "DONE.~%PLAYING...~%")
    (force-output)
    (play-samples samples)
    (format t "DONE.~%")
    (force-output)))
