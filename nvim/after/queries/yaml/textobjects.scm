;; extends

(_
  key: _ @key
  value: _ @value
)

(block_sequence_item
  "-" @item_dash (block_node) @item_inner
) @item_outer
