package flsl.parser 
{
	import flash.system.IMEConversionMode;
	import flsl.parser.ast.*;
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
		private var _tree:BranchNode;
		public static var LOG_TRACK:Boolean = false;
		
		public function Parser(source:String)
		{
			_tok  = new Tokenizer(source);
			_tree = new BranchNode(AstNodeType.ROOT_NODE);
		}
		
		public function parse():void 
		{
			_tok.next();
			program(_tree);
		}
		
		private function log_track(where:String):void
		{
			if (LOG_TRACK)
				trace(where);
		}
		
		/**
		 * program    = { shader | shader_var };
		 */
		private function program(ctx:BranchNode):void
		{
			log_track("program");
			
			while (_tok.token.type != TokenType.EOF)
			{
				if (_tok.token.type = TokenType.SHADER)
					shader(ctx);
				else
					shaderVar(ctx);
			}
		}
		
		/**
		 * shader     = 'shader' Identifier block;
		 */
		private function shader(ctx:BranchNode):void
		{
			log_track("shader");
			_tok.accept(TokenType.IDENTIFIER); // SKIP 'shader'
			var bn:BranchNode = new BranchNode(AstNodeType.SHADER);
			var ln:LeafNode = new LeafNode(_tok.accept(TokenType.IDENTIFIER).value, AstNodeType.IDENTIFIER);
			ctx.addChild(bn);
			bn.addChild(ln);
			block(ctx);
		}
		
		/**
		 * shader_var = Specifier Type Identifier ';';
		 */
		private function shaderVar(ctx:BranchNode):void
		{
			log_track("shader_var");
			var bn:BranchNode = new BranchNode(AstNodeType.SHADER_VAR);
			bn.addChild(new LeafNode(_tok.accept(TokenType.SPECIFIER).value, AstNodeType.IDENTIFIER));
			bn.addChild(new LeafNode(_tok.accept(TokenType.TYPE).value, AstNodeType.IDENTIFIER));
			bn.addChild(new LeafNode(_tok.accept(TokenType.IDENTIFIER).value, AstNodeType.IDENTIFIER));
			ctx.addChild(bn);
		}
		
		/**
		 * block      = '{' {statement} '}';
		 */
		private function block(ctx:BranchNode):void  
		{
			log_track("block");
			_tok.accept(TokenType.LBRACE);
			while (_tok.token.type != TokenType.RBRACE)
				statement(ctx)
			_tok.next();
		}
		
		/**
		 * statement     = (declaration | assignment | function_call) ';';
		 */
		private function statement(ctx:BranchNode):void
		{
			log_track("statement");
			
			var t:TokenType = _tok.token.type;
			
			if (t == TokenType.EOF)
				throw new Error("Unexpected end of file, missing end of block '}'");
				
			if (t != TokenType.IDENTIFIER)
				throw new UnexpectedTokenException(_tok.token);
			
			
			// all statements begin with an identifier (not on purpose though)
			//_tok.expect(TokenType.IDENTIFIER);
			switch (_tok.token.type) 
			{
				case TokenType.EOF:
					
					
				// function call or assignment
				default:
					var nex:Token = _tok.peek();
					if (nex.type == TokenType.EQUAL)
						assignment(ctx);
					else if (nex.type == TokenType.LPAREN)
						functionCall(ctx);
					else {
						throw new UnexpectedTokenException(_tok.token);
						return false;
					}
						
					break;
			}
			
			return true;
		}
		
		/**
		 * assignment    = [declaration | Identifier] '=' expression;
		 */
		private function assignment(ctx:BranchNode):void
		{
			log_track("assignment");
			var bn:BranchNode = new BranchNode(AstNodeType.ASSIGNMENT);
			ctx.children.push(bn);
			bn.children.push(new LeafNode(_tok.token.value, AstNodeType.IDENTIFIER));
			_tok.next(); // SKIP identifier
			_tok.next(); // SKIP '='
			expression(bn);
		}
		
		/**
		 * function_call = Identifier '(' [expression] {',' expression} ')';
		 */
		private function functionCall(ctx:BranchNode):void 
		{
			log_track("functionCall");
			
			var bn:BranchNode = new BranchNode(AstNodeType.FUNCTION_CALL);
			ctx.children.push(bn);
			bn.children.push(new LeafNode(_tok.token.value, AstNodeType.IDENTIFIER));
			
			_tok.next(); // SKIP identifier
			_tok.next(); // SKIP '('
			
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
		private function expression(ctx:BranchNode):void 
		{
			log_track("expression");
			ctx.children.push(addExpression());
		}
		
		private function addExpression():AstNode 
		{
			var ret:AstNode = mulExpression();
			while (true)
			{
				var bn:BranchNode;
				if (_tok.token.type == TokenType.PLUS)
					bn = new BranchNode(AstNodeType.EXPR_ADD, AstNodeType.ADD_ADD);
				else if (_tok.token.type == TokenType.MINUS)
					bn = new BranchNode(AstNodeType.EXPR_ADD, AstNodeType.ADD_SUBTRACT);
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
				var bn:BranchNode;
				if (_tok.token.type == TokenType.STAR)
					bn = new BranchNode(AstNodeType.EXPR_MUL, AstNodeType.MUL_MULTIPLTY);
				else if (_tok.token.type == TokenType.SLASH)
					bn = new BranchNode(AstNodeType.EXPR_MUL, AstNodeType.MUL_DIVIDE);
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
			var bn:BranchNode;
			if (_tok.token.type == TokenType.MINUS)
				bn = new BranchNode(AstNodeType.UNARY_NEGATE);
			else if (_tok.token.type == TokenType.NOT)
				bn = new BranchNode(AstNodeType.UNARY_NOT);
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
					var temp:BranchNode = new BranchNode(AstNodeType.NONE);
					functionCall(temp);
					ret =  temp.children[0];
				}
				// variable
				else 
				{
					ret = new LeafNode(_tok.token.value, AstNodeType.IDENTIFIER);
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
				ret = new LeafNode(_tok.token.value, AstNodeType.NUMBER_LITERAL);
				_tok.next(); // SKIP number literal
			}
			else
			{
				throw new UnexpectedTokenException(_tok.token);
			}
			return ret;
		}		
		
		public function get tree():BranchNode { return _tree; }
	}
}
