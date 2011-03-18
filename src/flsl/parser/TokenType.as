package flsl.parser 
{
	import flsl.etc.Enum;

	public class TokenType extends Enum
	{
		{
			initEnum(TokenType);
		}

public static const NONE:TokenType = new TokenType();
public static const EOF:TokenType = new TokenType();

public static const IDENTIFIER:TokenType = new TokenType();
public static const NUMBER:TokenType = new TokenType();

/**
 * Reserved words
 */
public static const TYPE:TokenType = new TokenType();
public static const SPECIFIER:TokenType = new TokenType();
public static const SHADER:TokenType = new TokenType();

/**
 * Grouping, delimiting
 */
public static const COLON   /* : */ :TokenType = new TokenType();
public static const DOT     /* . */ :TokenType = new TokenType();
public static const SEMI    /* ; */ :TokenType = new TokenType();
public static const LBRACE  /* { */ :TokenType = new TokenType();
public static const RBRACE  /* } */ :TokenType = new TokenType();
public static const LPAREN  /* ( */ :TokenType = new TokenType();
public static const RPAREN  /* ) */ :TokenType = new TokenType();
public static const COMMA   /* , */ :TokenType = new TokenType();

/**
 * Operators
 */
public static const PLUS   /* +   */ :TokenType = new TokenType();
public static const MINUS  /* -   */ :TokenType = new TokenType();
public static const STAR   /* *   */ :TokenType = new TokenType();
public static const SLASH  /* /   */ :TokenType = new TokenType();
public static const EQUAL  /* =   */ :TokenType = new TokenType();

	}
	
}
