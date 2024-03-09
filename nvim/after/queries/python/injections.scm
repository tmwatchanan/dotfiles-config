;; extends

; (expression_statement
;   (call
;     function: (attribute
;       object: (identifier) @_spark_object (#match? @_spark_object ".*spark.*")
;       attribute: (identifier) @_run_attribute (#eq? @_run_attribute "run"))
;     arguments: (argument_list
;       (call
;         function: (attribute
;           object: (identifier)
;           attribute: (identifier))
;         arguments: (argument_list
;           (string
;             (string_content) @injection.content)))))
;   (#set! injection.language "python")
; ) @_spark_string
;

(string
  (string_content) @injection.content
    (#lua-match? @injection.content "^# *python")
    (#set! injection.language "python")
) @_python_string_injection

