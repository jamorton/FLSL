package flsl.parser
{
	
	import flsl.parser.exception.UnexpectedTokenException;
	
	public class Parser 
	{
		
		/**
		 * NOTE: next()/accept() etiquette! Always leave the current token on the
		 *       FIRST token of the grammar rule function you are
		 *       recursing to. Always leave the current token on the token
		 *       AFTER your grammar rule's last token when returning from a
		 *       function.
		 */
		
		private var _tok:Tokenizer;
		public static var LOG_TRACK:Boolean = false;
		
		public function Parser(tok:Tokenizer)
		{
			_tok = tok;
			tok.next();
		}
		
		public static function parse(source:String):AstNode 
		{
			var t:Tokenizer = new Tokenizer(source);
			var p:Parser = new Parser(t);
			return p.exec();
		}
		
		private function log_track(where:String):void
		{
			if (LOG_TRACK)
				trace(where);
		}
		
		public function exec():AstNode
		{
			var ctx:AstNode = new AstNode(AstNodeType.PROGRAM);
			program(ctx);
			return ctx;
		}
		
		/**
		 * program = { shader | shader_var };
		 */
		private function program(ctx:AstNode):void
		{
			log_track("program");
			
			while (_tok.token.type != TokenType.EOF)
			{
				if (_tok.token.type == TokenType.SHADER)
					shader(ctx);
				else
					shaderVar(ctx);
			}
		}
		
		/**
		 * shader = 'shader' Identifier [':' declaration {',' declaration}] block;
		 */
		private function shader(ctx:AstNode):void
		{
			log_track("shader");
			_tok.accept(TokenType.SHADER); // SKIP 'shader'
			var bn:AstNode = new AstNode(AstNodeType.SHADER);
			bn.addChild(new AstNode(AstNodeType.IDENTIFIER, _tok.accept(TokenType.IDENTIFIER).value));
			
			if (_tok.token.type == TokenType.COLON)
			{
				_tok.next();
				bn.children.push(declaration());
				
				while (_tok.token.type != TokenType.LBRACE) 
				{
					_tok.accept(TokenType.COMMA);
					bn.children.push(declaration());
				}
			}
			
			ctx.addChild(bn);
			block(bn);
		}
		
		/**
		 * shader_var = Specifier Type Identifier ';';
		 */
		private function shaderVar(ctx:AstNode):void
		{
			log_track("shader_var");
			var bn:AstNode = new AstNode(AstNodeType.SHADER_VAR);
			bn.addChild(new AstNode(AstNodeType.IDENTIFIER, _tok.accept(TokenType.SPECIFIER).value));
			bn.addChild(new AstNode(AstNodeType.IDENTIFIER, _tok.accept(TokenType.TYPE).value));
			bn.addChild(new AstNode(AstNodeType.IDENTIFIER, _tok.accept(TokenType.IDENTIFIER).value));
			_tok.accept(TokenType.SEMI); // skip ';'
			ctx.addChild(bn);
		}
		
		/**
		 * block      = '{' {statement} '}';
		 */
		private function block(ctx:AstNode):void  
		{
			log_track("block");
			_tok.accept(TokenType.LBRACE);
			while (_tok.token.type != TokenType.RBRACE)
				statement(ctx)
			_tok.next();
		}
		
		/**
		 * statement     = (declaration | assignment | function_call) ';';
		 * declaration   = Type Identifier;
		 * assignment    = [declaration | Identifier] '=' expression;
		 * function_call = Identifier '(' [expression] {',' expression} ')';
		 */
		private function statement(ctx:AstNode):void
		{
			log_track("statement");
			
			var t:TokenType = _tok.token.type;
			var bn:AstNode;
			
			if (t == TokenType.EOF)
				throw new Error("Unexpected end of file, missing end of block '}'");
			
			else if (t == TokenType.TYPE)
			{
				var decl:AstNode = declaration();
				
				// plain declaration
				if (_tok.token.type == TokenType.SEMI)
					ctx.addChild(decl);
				// assignment with declaration
				else
				{
					bn = new AstNode(AstNodeType.ASSIGNMENT);
					bn.addChild(decl);
					_tok.accept(TokenType.EQUAL);
					expression(bn);
					ctx.addChild(bn);
				}
			}
			// assignment w/o declaration
			else if (_tok.peek().type == TokenType.EQUAL)
			{
				bn = new AstNode(AstNodeType.ASSIGNMENT);
				bn.addChild(new AstNode(AstNodeType.IDENTIFIER, _tok.accept(TokenType.IDENTIFIER).value));
				_tok.accept(TokenType.EQUAL); // SKIP '='
				expression(bn);
				ctx.addChild(bn);
			}
			// function call
			else
				functionCall(ctx);
				
			_tok.accept(TokenType.SEMI);
		}
		
		private function declaration():AstNode
		{
			var bn:AstNode = new AstNode(AstNodeType.DECLARATION);
			bn.addChild(new AstNode(AstNodeType.IDENTIFIER, _tok.accept(TokenType.TYPE).value));
			bn.addChild(new AstNode(AstNodeType.IDENTIFIER, _tok.accept(TokenType.IDENTIFIER).value));
			return bn;
		}
		
		/**
		 * function_call = Identifier '(' [expression] {',' expression} ')';
		 */
		private function functionCall(ctx:AstNode):void 
		{
			log_track("functionCall");
			
			var bn:AstNode = new AstNode(AstNodeType.FUNCTION_CALL);
			ctx.children.push(bn);
			bn.children.push(new AstNode(AstNodeType.IDENTIFIER, _tok.accept(TokenType.IDENTIFIER).value));
			
			_tok.accept(TokenType.LPAREN); // SKIP '('
			
			while (_tok.token.type != TokenType.RPAREN) 
			{
				expression(bn);
				if (_tok.token.type == TokenType.COMMA)
					_tok.next(); // SKIP ','
			}
			_tok.next(); // SKIP ')'
		}
		
		/**
		 * expression       = add_expression
		 * add_expression   = mul_expression {('+' | '-') mul_expression};
		 * mul_expression   = unary_expression {('*' | '/') unary_expression};
		 * unary_expression = ['-'] atom_expression;
		 * atom_expression  = Identifier | function_call | '(' expression ')' | literal | access;
		 */
		private function expression(ctx:AstNode):void 
		{
			log_track("expression");
			ctx.children.push(addExpression());
		}
		
		private function addExpression():AstNode 
		{
			var ret:AstNode = mulExpression();
			while (true)
			{
				var bn:AstNode;
				if (_tok.token.type == TokenType.PLUS)
					bn = new AstNode(AstNodeType.ADD);
				else if (_tok.token.type == TokenType.MINUS)
					bn = new AstNode(AstNodeType.SUBTRACT);
				else
					return ret;
					
				log_track("addExpression");
				_tok.next(); // SKIP '+' or '-'
				bn.children.push(ret);
				bn.children.push(mulExpression());
				ret = bn;
			}
			return ret;
		}
		
		private function mulExpression():AstNode 
		{			
			var ret:AstNode = unaryExpression();
			while (true)
			{
				var bn:AstNode;
				if (_tok.token.type == TokenType.STAR)
					bn = new AstNode(AstNodeType.MULTIPLTY);
				else if (_tok.token.type == TokenType.SLASH)
					bn = new AstNode(AstNodeType.DIVIDE);
				else
					return ret;
					
				log_track("mulExpression");
				_tok.next(); // SKIP '*' or '/'
				bn.children.push(ret);
				bn.children.push(unaryExpression());
				ret = bn;
			}
			return ret;
		}
		
		private function unaryExpression():AstNode
		{			
			var bn:AstNode;
			if (_tok.token.type == TokenType.MINUS)
				bn = new AstNode(AstNodeType.NEG);
			else
				return atomExpression();
				
			log_track("unaryExpression");
			_tok.next(); // SKIP '-' or 'not'
			bn.children.push(atomExpression());
			return bn;
		}

		private function atomExpression():AstNode
		{
			log_track("atomExpression");
			
			var ret:AstNode;
			// TODO: Clean this up.
			
			// identifer is either a function call or a variable.
			if (_tok.token.type ==  TokenType.IDENTIFIER)
			{
				var t:Token = _tok.peek();
				// function call
				if (t.type == TokenType.LPAREN)
				{
					// bad hack to capture functionCall output
					var temp:AstNode = new AstNode(AstNodeType.NONE);
					functionCall(temp);
					ret =  temp.children[0];
				}
				else if (t.type == TokenType.DOT)
				{
					var bn:AstNode = new AstNode(AstNodeType.ACCESS);
					bn.addChild(new AstNode(AstNodeType.IDENTIFIER, _tok.accept(TokenType.IDENTIFIER).value));
					_tok.accept(TokenType.DOT); // SKIP 'dot'
					bn.addChild(new AstNode(AstNodeType.IDENTIFIER, _tok.accept(TokenType.IDENTIFIER).value));
					ret = bn;
				}
				// variable
				else 
				{
					ret = new AstNode(AstNodeType.IDENTIFIER, _tok.token.value);
					_tok.next(); // SKIP identifier
				}
			}
			// grouping parens
			else if (_tok.token.type == TokenType.LPAREN) 
			{
				_tok.next(); // SKIP '('
				ret = addExpression();
				_tok.next(); // SKIP ')'
			}
			// number literal
			else if (_tok.token.type == TokenType.NUMBER)
			{
				ret = new AstNode(AstNodeType.NUMBER_LITERAL, _tok.token.value);
				_tok.next(); // SKIP number literal
			}
			else
			{
				throw new UnexpectedTokenException(_tok.token);
			}
			return ret;
		}
	}
}
