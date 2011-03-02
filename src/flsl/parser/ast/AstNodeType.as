package flsl.parser.ast 
{
	import crystalscript.etc.Enum;
	
	/**
	 * @see doc/Grammar.txt
	 */
	public class AstNodeType extends Enum
	{

		{
			initEnum(AstNodeType);
		}
	
	
	public static const NONE              : AstNodeType = new AstNodeType();
	public static const ROOT_NODE         : AstNodeType = new AstNodeType();
	
	/**
	 * BASIC TYPES
	 */
	
	// Branch Nodes
	public static const BLOCK             : AstNodeType = new AstNodeType();
	public static const ASSIGNMENT        : AstNodeType = new AstNodeType();
	public static const FUNCTION_CALL     : AstNodeType = new AstNodeType();
	public static const IF_BLOCK          : AstNodeType = new AstNodeType();
	public static const LOOP_BLOCK        : AstNodeType = new AstNodeType();
	public static const WHILE_BLOCK       : AstNodeType = new AstNodeType();
	public static const EXPRESSION        : AstNodeType = new AstNodeType();
	public static const EXPR_OR           : AstNodeType = new AstNodeType();
	public static const EXPR_AND          : AstNodeType = new AstNodeType();
	public static const EXPR_COMPARE      : AstNodeType = new AstNodeType();
	public static const EXPR_ADD          : AstNodeType = new AstNodeType();
	public static const EXPR_MUL          : AstNodeType = new AstNodeType();
	public static const EXPR_UNARY        : AstNodeType = new AstNodeType();
	public static const EXPR_FUNCTIONCALL : AstNodeType = new AstNodeType();
	public static const RETURN            : AstNodeType = new AstNodeType();
	
	// Leaf Nodes
	public static const IDENTIFIER        : AstNodeType = new AstNodeType();
	public static const NUMBER_LITERAL    : AstNodeType = new AstNodeType();
	public static const BREAK             : AstNodeType = new AstNodeType();
	public static const CONTINUE          : AstNodeType = new AstNodeType();
	
	
	/**
	 * SUB TYPES
	 */
	public static const NO_SUBTYPE      : AstNodeType = new AstNodeType();
	 
	public static const UNARY_NOT       : AstNodeType = new AstNodeType();
	public static const UNARY_NEGATE    : AstNodeType = new AstNodeType();
	
	public static const MUL_DIVIDE      : AstNodeType = new AstNodeType();
	public static const MUL_MULTIPLTY   : AstNodeType = new AstNodeType();
	
	public static const ADD_ADD         : AstNodeType = new AstNodeType();
	public static const ADD_SUBTRACT    : AstNodeType = new AstNodeType();

	public static const COMPARE_EQUAL   : AstNodeType = new AstNodeType();
	public static const COMPARE_LESS    : AstNodeType = new AstNodeType();
	public static const COMPARE_GREATER : AstNodeType = new AstNodeType();
	public static const COMPARE_LESSEQ  : AstNodeType = new AstNodeType();
	public static const COMPARE_GREATEQ : AstNodeType = new AstNodeType();
	public static const COMPARE_NOTEQ   : AstNodeType = new AstNodeType();
	
	}
	
}
