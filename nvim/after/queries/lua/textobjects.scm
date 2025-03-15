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
    (expression_list) @assignment_expression
) @assignment.outer

(variable_list
  name: (identifier) @variable_list_inner . "," @variable_list_comma
  (#make-range! "variable_list_outer" @variable_list_inner @variable_list_comma)
)
