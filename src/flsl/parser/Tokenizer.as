package flsl.parser 
{
	
	import crystalscript.etc.Util;
	import crystalscript.parser.exception.UnexpectedTokenException;

	public class Tokenizer
	{
		
		private var _tokenRegex:Array = [
			// letter or underscore followed by zero or more alphanumeric/underscore
			[TokenType.IDENTIFIER, /[a-zA-Z_]\w*/],
			// floats with exponent support etc.
			[TokenType.NUMBER, /[-+]?[0-9]+[.]?[0-9]*([eE][-+]?[0-9]+)?/],
			// grouping
			[TokenType.LPAREN, /\(/],
			[TokenType.RPAREN, /\)/],
			[TokenType.COMMA,  /,/],
			// operators
			[TokenType.PLUS, /\+/],
			[TokenType.MINUS, /-/],
			[TokenType.STAR, /\*/],
			[TokenType.SLASH, /\//],
			[TokenType.LESS, /</],
			[TokenType.GREATER, />/],
			[TokenType.EQUALEQUAL, /==/], // must come before '='!
			[TokenType.EQUAL, /=/],
			[TokenType.LESSEQUAL, /<=/],
			[TokenType.GREATEREQUAL, />=/],
			[TokenType.NOTEQUAL, /!=/]
		];
		
		private var _finalRegex:RegExp;
		
		private var _source:String;
		private var _position:Number;
		
		private var _token:Token;
		private var _nextToken:Token;
		
		private var _line:Number;
		
		public function Tokenizer(source:String = "") 
		{
			_source    = source;
			_position  = 0;
			_line      = 1;
			_token     = new Token(TokenType.NONE, "<NONE>");
			_nextToken = new Token(TokenType.NONE, "<NONE>");
			buildRegex();
		}
		
		private function buildRegex():void {
			var reg:String = new String();
			
			reg += "^(";
			
			var i:Number = 0;
			for each (var g:Array in _tokenRegex)
			{
				i++;
				reg += "?P<" + g[0].name + ">" + g[1].source;
				if (i < _tokenRegex.length)
					reg += ")|^(";
			}
			
			reg += ")";
			
			_finalRegex = new RegExp(reg, "");
		}
		
		public function scan():Vector.<Token>
		{
			var tokens:Vector.<Token> = new Vector.<Token>();
			if (_source.length < 1) return tokens;
			_position = 0;
			
			while (true)
			{		
				next();
				tokens.push(_token);
				
				if (_token.type == TokenType.EOF) break;
			}
			
			tokens.push(new Token(TokenType.NONE, "<END>"));
			return tokens;
		}
		
		public function next():void
		{
			// skip spaces
			while (_source.charCodeAt(_position) <= 32) 
			{
				if (_source.charAt(_position) == "\n") _line++;
				_position++;
			}
			
			// end of script
			if (_position > _source.length) 
			{
				trace("yes");
				_nextToken = new Token(TokenType.NONE, "<NONE>");
				_token = new Token(TokenType.EOF, "<EOF>");
				return;
			}
			
			if (_position == source.length)
			{
				_token = _nextToken;
				_nextToken = new Token(TokenType.EOF, "<EOF>");
				return;
			}

			var result:Object = _finalRegex.exec(_source.substr(_position));
			_position += result[0].length;
			
			var type:TokenType = null;
			for each (var i:Array in _tokenRegex) 
			{
				// TODO: make this faster
				if (result[i[0].name] == result[0]) 
				{
					type = i[0];
				}
			}
			
			type = reservedWords(result[0], type);
			var token:Token = new Token(type, result[0]);
			token.line = _line;
			
			_token = _nextToken;
			_nextToken = token;
			
			// happens on first next
			if (_token.type == TokenType.NONE)
				next();
		}
		
		private function reservedWords(text:String, type:TokenType):TokenType 
		{
			switch (text)
			{
				case "not":      return TokenType.NOT;
				case "mod":      return TokenType.MODULO;
				case "while":    return TokenType.WHILE;
				case "loop":     return TokenType.LOOP;
				case "or":       return TokenType.OR;
				case "if":       return TokenType.IF;
				case "end":      return TokenType.END;
				case "break":    return TokenType.BREAK;
				case "continue": return TokenType.CONTINUE;
				case "and":      return TokenType.AND;
				case "return":   return TokenType.RETURN;
				default:         return type;
			}
		}
		
		public function peek():Token 
		{
			return _nextToken;
		}
		
		public function expect(type:TokenType):Boolean 
		{
			if (_token.type == type)
				return true;
			throw new UnexpectedTokenException(_token, type);
			return false;
		}
		
		public function get source():String { return _source; }
		
		public function set source(value:String):void 
		{
			_source = value;
		}
		
		public function get token():Token { return _token; }
		
	}
	
}
