; extends

(expression_statement
  (call
    function: (attribute
      object: (identifier) @_spark_object (#eq? @_spark_object "spark_session")
      attribute: (identifier) @_run_attribute (#eq? @_run_attribute "run"))
    arguments: (argument_list
      (call
        function: (attribute
          object: (identifier)
          attribute: (identifier))
        arguments: (argument_list
          (string
            (string_content) @injection.content)))))
  (#set! injection.language "python")
) @_spark_string

