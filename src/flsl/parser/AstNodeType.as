package flsl.parser 
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
public static const PROGRAM   : AstNodeType = new AstNodeType();

/**
 * BASIC TYPES
 */

// Branch Nodes
public static const SHADER        : AstNodeType = new AstNodeType();
public static const BLOCK         : AstNodeType = new AstNodeType();
public static const DECLARATION   : AstNodeType = new AstNodeType();
public static const ASSIGNMENT    : AstNodeType = new AstNodeType();
public static const FUNCTION_CALL : AstNodeType = new AstNodeType();
public static const ACCESS        : AstNodeType = new AstNodeType();
public static const SHADER_VAR    : AstNodeType = new AstNodeType();
public static const DIVIDE        : AstNodeType = new AstNodeType();
public static const MULTIPLTY     : AstNodeType = new AstNodeType();
public static const ADD           : AstNodeType = new AstNodeType();
public static const SUBTRACT      : AstNodeType = new AstNodeType();
public static const NEG           : AstNodeType = new AstNodeType();

// Leaf Nodes
public static const IDENTIFIER        : AstNodeType = new AstNodeType();
public static const NUMBER_LITERAL    : AstNodeType = new AstNodeType();
	
	}
	
}
