package flsl.parser.exception 
{
	import flsl.parser.Token;
	import flsl.parser.TokenType;
	
	public class UnexpectedTokenException extends Error
	{
		
		public function UnexpectedTokenException(tok:Token = null, expected:TokenType = null) 
		{
			super();
			if (tok == null)
				tok = new Token(TokenType.NONE, "<NONE>");
			message = "Unexpected token " + tok.type.name + " on line " + tok.line;				
			if (expected != null)
				message += ", expected " + expected.name;
		}
		
	}
	
}
