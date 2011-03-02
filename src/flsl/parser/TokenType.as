package flsl.parser 
{
	import crystalscript.etc.Enum;

	public class TokenType extends Enum
	{

		{
			initEnum(TokenType);
		}

		public static const NONE:TokenType = new TokenType();
		
		public static const EOF:TokenType = new TokenType();
		
		/**
		 * An identifier, such as a variable name, reserved word.
		 * A series of letters, numbers, and underscores, can't start w/ number
		 */
		public static const IDENTIFIER:TokenType = new TokenType();
		
		/**
		 * A number, whether it be an integer or float
		 */
		public static const NUMBER:TokenType = new TokenType();
		
		
		/**
		 * Reserved words
		 */
		public static const NOT      /* not   */ :TokenType = new TokenType();
		public static const MODULO   /* mod   */ :TokenType = new TokenType();
		public static const WHILE    /* while */ :TokenType = new TokenType();
		public static const LOOP     /* loop  */ :TokenType = new TokenType();
		public static const AND      /* and   */ :TokenType = new TokenType();
		public static const OR       /* or    */ :TokenType = new TokenType();
		public static const IF       /* if    */ :TokenType = new TokenType();
		public static const END      /* end   */ :TokenType = new TokenType();
		public static const BREAK    /* break   */ :TokenType = new TokenType();
		public static const RETURN   /* return   */ :TokenType = new TokenType();
		public static const CONTINUE /* continue   */ :TokenType = new TokenType();
		
		/**
		 * Grouping, delimiting stuff
		 */
		public static const LPAREN  /* ( */  :TokenType = new TokenType();
		public static const RPAREN  /* ) */  :TokenType = new TokenType();
		public static const COMMA   /* , */  :TokenType = new TokenType();
		
		/**
		 * Operators
		 */
		public static const PLUS         /* +   */ :TokenType = new TokenType();
		public static const MINUS        /* -   */ :TokenType = new TokenType();
		public static const STAR         /* *   */ :TokenType = new TokenType();
		public static const SLASH        /* /   */ :TokenType = new TokenType();
		public static const LESS         /* <   */ :TokenType = new TokenType();
		public static const GREATER      /* >   */ :TokenType = new TokenType();
		public static const EQUAL        /* =   */ :TokenType = new TokenType();
		public static const EQUALEQUAL   /* ==  */ :TokenType = new TokenType();
		public static const LESSEQUAL    /* <=  */ :TokenType = new TokenType();
		public static const GREATEREQUAL /* >=  */ :TokenType = new TokenType();
		public static const NOTEQUAL     /* !=  */ :TokenType = new TokenType();

	}
	
}
