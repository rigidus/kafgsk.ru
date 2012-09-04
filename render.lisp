(in-package #:kafgsk)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; default-render
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defclass kafgsk-render () ())

(defparameter *default-render-method* (make-instance 'kafgsk-render))


;; (defmethod restas:render-object ((designer kafgsk-render) (data list))
;;   (destructuring-bind (headtitle navpoints content) data
;;     (tpl:root (list :headtitle headtitle
;;                     :content (tpl:base (list :navpoints navpoints
;;                                              :content content
;;                                              :stat (tpl:stat)))))))




