package flsl.parser.exception 
{
	import crystalscript.parser.Token;
	import crystalscript.parser.TokenType;
	
	public class UnexpectedTokenException extends Error
	{
		
		public function UnexpectedTokenException(tok:Token = null, expected:TokenType = null) 
		{
			super();
			if (tok == null)
				tok = new Token(TokenType.NONE, "<NONE>");
			if (expected != null)
				message = "Unexpected token " + tok.type.name + " on line " + tok.line + ", expected " + expected.name;
			else
				message = "Unexpected token " + tok.type.name + " on line " + tok.line;
		}
		
	}
	
}
