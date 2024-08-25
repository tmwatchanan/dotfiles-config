;; extends

(chunk
  (_) @block.outer
)

(variable_declaration) @local_variable_declaration


((field) @field_inner . "," @field_comma
    (#make-range! "field_outer" @field_inner @field_comma)
)

(field
  name: (_) @field_name.inner . "=" @field_name.symbol
    (#make-range! "field_name.outer" @field_name.inner @field_name.symbol)
  value: (_) @field_value
)

(assignment_statement
    (variable_list) @assignment_variable_id
)
