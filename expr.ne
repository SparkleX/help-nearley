

@builtin "whitespace.ne" # `_` means arbitrary amount of whitespace
@builtin "number.ne"     # `int`, `decimal`, and `percentage` number primitives
@builtin "string.ne" # `_` means arbitrary amount of whitespace

main -> expression {% id %}   

expression -> boolean_expression {% id %} 

boolean_expression
    -> comparison_expression     {% id %}
    |  comparison_expression _ boolean_operator _ boolean_expression
        {%
            d => ({
                type: "boolean_expression",
                operator: d[2],
                left: d[0],
                right: d[4]
            })
        %}

comparison_expression
    -> additive_expression    {% id %}
    |  additive_expression _ comparison_operator _ comparison_expression
        {%
            d => ({
                type: "comparison_expression",
                operator: d[2],
                left: d[0],
                right: d[4]
            })
        %}

boolean_operator
    -> "and"      {% id %}
    |  "or"       {% id %}

multiplicative_expression -> 
      unary_expression _ [*/] _ multiplicative_expression {% function(d) {return {left: d[0], oper:d[2], right:d[4]}} %}
    | unary_expression {% id %}

additive_expression -> 
      multiplicative_expression    {% id %}
    | multiplicative_expression _ [+-] _ additive_expression {% function(d) {return {left: d[0], oper:d[2], right:d[4]}} %}
    
unary_expression ->
    tableColumn {% id %}
    | int {% id %} 
    | dqstring {% id %} 
    |  "(" _ expression _ ")"  {% d =>({left:d[2], oper:"()"} )%}   

comparison_operator
    -> ">"   {% id %}
    |  ">="  {% id %}
    |  "<"   {% id %}
    |  "<="  {% id %}
    |  "=="  {% id %}

tableColumn -> identifier "." identifier {% d=>({type:"column", table:d[0], column:d[2]}) %} 

identifier -> [a-zA-Z] [a-zA-Z0-9]:+ {% d=>(d[0] + d[1].join("")) %} 
