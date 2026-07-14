; mini.ai treesitter textobjects for KEY=value files (used by `env` filetype)
(property) @assignment.outer

(property
  (key) @assignment.lhs @key)

(property
  (value) @assignment.rhs @assignment.inner @value)
