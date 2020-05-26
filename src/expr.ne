@builtin "whitespace.ne" # `_` means arbitrary amount of whitespace
@builtin "number.ne"     # `int`, `decimal`, and `percentage` number primitives
@builtin "string.ne" # `_` means arbitrary amount of whitespace

main -> 
	arith_expr {% id %}  
	|  "if" _ "(" _ boolean_expression _ "," _ arith_expr _ "," _ arith_expr _ ")"
		{%
            d => ({
                type: "if",
                condition: d[4],
                trueExpr: d[8],
                falseExpr: d[12]
            })
        %}

boolean_expression
    ->  or_expression {% id %}
	|  par_boolean_expression

par_boolean_expression
	->	"(" _ boolean_expression _ ")"  {% d =>({oper:"()", left:d[2]} )%}

and_expression ->      
      comparison_expression {% id %}
	| par_boolean_expression {% id %}
	| and_expression _ "and" _ and_expression {% function(d) {return {oper:d[2], left: d[0],  right:d[4]}} %}

or_expression ->
      and_expression {% id %}
    | or_expression _ "or" _ and_expression{% function(d) {return {oper:d[2], left: d[0], right:d[4]}} %}

comparison_expression
    ->  arith_expr _ comparison_operator _ arith_expr
        {%
            d => ({
                oper: d[2],
                left: d[0],
                right: d[4]
            })
        %}


arith_expr -> 
		unary_expression {% id %}
	|	additive_expression {% id %}
	| 	multiplicative_expression {% id %}

multiplicative_expression -> 
      unary_expression _ [*/] _ multiplicative_expression {% function(d) {return {oper:d[2], left: d[0], right:d[4]}} %}
    | unary_expression {% id %}

additive_expression -> 
      multiplicative_expression    {% id %}
    | multiplicative_expression _ [+-] _ additive_expression {% function(d) {return {oper:d[2], left: d[0], right:d[4]}} %}
    
unary_expression ->
    tableColumn {% id %}
    | int {% id %} 
    | dqstring {% id %} 
	| identifier _ "(" _ arith_expr _ ")" {% d =>( {type:"function", oper:d[0], left:d[4]} )%}   
    |  "(" _ arith_expr _ ")"  {% d =>({oper:"()", left:d[2]} )%}   

comparison_operator
    -> ">"   {% id %}
    |  ">="  {% id %}
    |  "<"   {% id %}
    |  "<="  {% id %}
    |  "=="  {% id %}
	|  "<>"  {% id %}

tableColumn -> ("[" _ identifier _ "]" "."):* "[" _ identifier _ "]" {% d =>(d.join().replace(/[\[,\]]/g, ''))%}   

identifier -> [a-zA-Z] [a-zA-Z0-9]:+ {% d=>(d[0] + d[1].join("")) %} 
