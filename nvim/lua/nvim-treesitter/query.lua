local M = {}

local function split_path(path)
    local parts = {}
    for part in string.gmatch(path, '([^.]+)') do
        table.insert(parts, part)
    end
    return parts
end

local function insert_to_path(object, path, value)
    local current = object
    for index = 1, (#path - 1) do
        local key = path[index]
        if current[key] == nil then
            current[key] = {}
        end
        current = current[key]
    end
    current[path[#path]] = value
end

local function get_at_path(object, path)
    if path == '' then
        return object
    end

    local current = object
    for _, part in ipairs(split_path(path)) do
        if type(current) ~= 'table' then
            return nil
        end
        current = current[part]
    end

    return current
end

local TSRange = {}
TSRange.__index = TSRange

function TSRange.from_nodes(start_node, end_node)
    local start_pos = start_node and { start_node:start() } or { end_node:start() }
    local end_pos = end_node and { end_node:end_() } or { start_node:end_() }

    return setmetatable({
        start_pos = { start_pos[1], start_pos[2], start_pos[3] },
        end_pos = { end_pos[1], end_pos[2], end_pos[3] },
    }, TSRange)
end

function TSRange:start()
    return unpack(self.start_pos)
end

function TSRange:end_()
    return unpack(self.end_pos)
end

function TSRange:range()
    return self.start_pos[1], self.start_pos[2], self.end_pos[1], self.end_pos[2]
end

local function range_from_match_nodes(nodes)
    if type(nodes) ~= 'table' then
        return nodes
    end

    local first = nodes[1]
    local last = nodes[#nodes]
    if not first and not last then
        return nil
    end

    return TSRange.from_nodes(first, last)
end

local function iter_prepared_matches(query, root, bufnr, start_row, end_row)
    local matches = query:iter_matches(root, bufnr, start_row, end_row, { all = false })

    return function()
        local pattern, match, metadata = matches()
        if pattern == nil then
            return
        end

        local prepared_match = {}

        for id, node in pairs(match) do
            local name = query.captures[id]
            if name ~= nil then
                insert_to_path(prepared_match, split_path(name .. '.node'), range_from_match_nodes(node))
                insert_to_path(prepared_match, split_path(name .. '.metadata'), metadata[id])
            end
        end

        local patterns = query.info and query.info.patterns
        local preds = patterns and patterns[pattern]
        if preds then
            for _, pred in pairs(preds) do
                if pred[1] == 'set!' and type(pred[2]) == 'string' then
                    insert_to_path(prepared_match, split_path(pred[2]), pred[3])
                end

                if pred[1] == 'make-range!' and type(pred[2]) == 'string' and #pred == 4 then
                    local start_nodes = match[pred[3]]
                    local end_nodes = match[pred[4]]
                    local start_node = type(start_nodes) == 'table' and start_nodes[1] or start_nodes
                    local end_node = type(end_nodes) == 'table' and end_nodes[#end_nodes] or end_nodes

                    if start_node or end_node then
                        insert_to_path(
                            prepared_match,
                            split_path(pred[2] .. '.node'),
                            TSRange.from_nodes(start_node, end_node)
                        )
                    end
                end
            end
        end

        return prepared_match
    end
end

local function get_capture_matches(bufnr, captures, query_group, root, lang)
    if type(captures) == 'string' then
        captures = { captures }
    end

    local strip_captures = {}
    for i, capture in ipairs(captures) do
        if capture:sub(1, 1) ~= '@' then
            error('Captures must start with "@"')
        end
        strip_captures[i] = capture:sub(2)
    end

    local query = vim.treesitter.query.get(lang, query_group)
    if not query then
        return {}
    end

    local start_row, _, end_row, _ = root:range()
    local matches = {}

    for prepared_match in iter_prepared_matches(query, root, bufnr, start_row, end_row + 1) do
        for _, capture in ipairs(strip_captures) do
            local insert = get_at_path(prepared_match, capture)
            if insert then
                table.insert(matches, insert)
            end
        end
    end

    return matches
end

function M.get_capture_matches_recursively(bufnr, capture_or_fn, query_type)
    local type_fn
    if type(capture_or_fn) == 'function' then
        type_fn = capture_or_fn
    else
        type_fn = function()
            return capture_or_fn, query_type
        end
    end

    local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
    if not ok or not parser then
        return {}
    end

    local matches = {}
    parser:parse(true)
    parser:for_each_tree(function(tree, lang_tree)
        local capture, type_ = type_fn(lang_tree:lang(), tree, lang_tree)
        if not capture then
            return
        end

        vim.list_extend(matches, get_capture_matches(bufnr, capture, type_, tree:root(), lang_tree:lang()))
    end)

    return matches
end

return M
