package flsl.parser.ast 
{
	import flsl.etc.Enum;
	
	/**
	 * @see doc/Grammar.txt
	 */
	public class AstNodeType extends Enum
	{

		{
			initEnum(AstNodeType);
		}
	
public static const NONE      : AstNodeType = new AstNodeType();
public static const ROOT_NODE : AstNodeType = new AstNodeType();

/**
 * BASIC TYPES
 */

// Branch Nodes
public static const SHADER            : AstNodeType = new AstNodeType();
public static const BLOCK             : AstNodeType = new AstNodeType();
public static const DECLARATION       : AstNodeType = new AstNodeType();
public static const ASSIGNMENT        : AstNodeType = new AstNodeType();
public static const FUNCTION_CALL     : AstNodeType = new AstNodeType();
public static const EXPR_ADD          : AstNodeType = new AstNodeType();
public static const EXPR_MUL          : AstNodeType = new AstNodeType();
public static const EXPR_NEG          : AstNodeType = new AstNodeType();
public static const ACCESS            : AstNodeType = new AstNodeType();
public static const SHADER_VAR        : AstNodeType = new AstNodeType();

// Leaf Nodes
public static const IDENTIFIER        : AstNodeType = new AstNodeType();
public static const NUMBER_LITERAL    : AstNodeType = new AstNodeType();

/**
 * Subtypes
 */
public static const NO_SUBTYPE    : AstNodeType = new AstNodeType();

public static const MUL_DIVIDE    : AstNodeType = new AstNodeType();
public static const MUL_MULTIPLTY : AstNodeType = new AstNodeType();

public static const ADD_ADD       : AstNodeType = new AstNodeType();
public static const ADD_SUBTRACT  : AstNodeType = new AstNodeType();
	
	}
	
}
