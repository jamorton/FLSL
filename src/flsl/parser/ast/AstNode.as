package flsl.parser.ast 
{
	
	public class AstNode
	{
		
		protected var _type:AstNodeType;
		protected var _sub:AstNodeType;
		
		protected var _isLeaf:Boolean = false;
		
		public function AstNode(type:AstNodeType, subtype:AstNodeType = null) 
		{
			_type = type;
			_sub = subtype;
			if (subtype == null)
				_sub = AstNodeType.NO_SUBTYPE;
		}
		
		public function get type():AstNodeType { return _type; }
		
		public function set type(value:AstNodeType):void 
		{
			_type = value;
		}
		
		public function get sub():AstNodeType { return _sub; }
		
		public function set sub(value:AstNodeType):void 
		{
			_sub = value;
		}
		
		public function get isLeaf():Boolean { return _isLeaf; }
		
		public function toString(level:Number = 0):String
		{
			return "<AstNode " + _type.toString() + ">";
		}
		
	}
	
}
