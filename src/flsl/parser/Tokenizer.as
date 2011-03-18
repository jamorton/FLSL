package flsl.parser 
{

	import flsl.parser.exception.UnexpectedTokenException;

	public class Tokenizer
	{
		
		private var _tokenRegex:Array = [
			[TokenType.IDENTIFIER, /[a-zA-Z_][a-zA-Z0-9_]*/],
			[TokenType.NUMBER, /[-+]?[0-9]+[.]?[0-9]*([eE][-+]?[0-9]+)?/],
			// grouping
			[TokenType.COLON, /:/],
			[TokenType.SEMI, /;/],
			[TokenType.LBRACE, /{/],
			[TokenType.RBRACE, /}/],
			[TokenType.LPAREN, /\(/],
			[TokenType.RPAREN, /\)/],
			[TokenType.COMMA,  /,/],
			// operators
			[TokenType.DOT, /\./],
			[TokenType.PLUS, /\+/],
			[TokenType.MINUS, /-/],
			[TokenType.STAR, /\*/],
			[TokenType.SLASH, /\//],
			[TokenType.EQUAL, /=/]
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
			next();
		}
		
		private function buildRegex():void {
			var reg:String = new String();
			
			reg += "^(";
			
			for (var i:int = 0; i < _tokenRegex.length; i++)
			{
				reg += "?P<" + _tokenRegex[i][0].name + ">" + _tokenRegex[i][1].source;
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
		}
		
		private function reservedWords(text:String, type:TokenType):TokenType 
		{
			switch (text)
			{
				case "shader":
					return TokenType.SHADER;
				case "Texture":
				case "Matrix":
				case "Float4":
					return TokenType.TYPE;
				case "attribute":
				case "varying":
					return TokenType.SPECIFIER;
			}
			return type;
		}
		
		public function peek():Token 
		{
			return _nextToken;
		}
		
		public function expect(type:TokenType):void 
		{
			if (_token.type != type)
				throw new UnexpectedTokenException(_token, type);
		}
		
		public function accept(type:TokenType):Token
		{
			var t:Token = _token;
			expect(type);
			next();
			return t;
		}
		
		public static function debugSource(src:String):void
		{
			var tok:Tokenizer = new Tokenizer(src);
			while (tok.token.type != TokenType.EOF)
			{
				trace(tok.token);
				tok.next();
			}
		}
		
		public function get source():String { return _source; }
		
		public function set source(value:String):void 
		{
			_source = value;
		}
		
		public function get token():Token { return _token; }
		
	}
	
}
