#!/usr/bin/env newlisp

(setf input (open "input.txt" "read")
      max-value 0
      acc 0)

(while (read-line input)
  (cond
    ((empty? (current-line))
     (when (> acc max-value)
       (setf max-value acc))
     (setf acc 0))

    (true
      (inc acc (int (current-line) 0 10)))))

(close input)

(when (> acc max-value)
  (setf max-value acc))

(println max-value)

(exit 0)
