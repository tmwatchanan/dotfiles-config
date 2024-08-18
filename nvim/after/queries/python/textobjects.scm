;; extends

(assignment) @local_variable_declaration

(dictionary
  (pair
    key: (_) @field_name
    value: (_) @field_value
  ) @field
)

(for_in_clause
  left: (_) @for_in_clause_left
  right: (_) @for_in_clause_right
) @for_in_clause

(if_clause
  (comparison_operator) @comparison_operator
) @if_clause

(type) @type

(keyword_argument
    name: (_) @keyword_argument_name
    value: (_) @keyword_argument_value
) @keyword_argument

(typed_parameter
  (identifier) @typed_parameter_identifier
  type: (_) @typed_parameter_type
) @typed_parameter

(assignment
    left: (_) @assignment_left
    type: (_) @assignment_type
) @assignment
