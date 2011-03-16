package flsl.parser 
{
	
	public class AstNode
	{
		
		protected var _type:AstNodeType;
		protected var _value:String;
		private var _children:Vector.<AstNode>;
		
		public function AstNode(type:AstNodeType, value:String = null) 
		{
			_type = type;
			_value = value;
			_children = new Vector.<AstNode>();
		}
		
		public function addChild(bn:AstNode):void
		{
			_children.push(bn);
		}
			
		public function toString(level:Number = 0):String
		{
			var out:String = "";
			for (var i:Number = 0; i < level; i++) 
				out += "   ";
			
			if (_value)
				out += "<" + _type.name + " \"" + _value + "\">\n";
			else
				out += "<" + _type.name + ">\n";
				
			level++;
			for each(var m:AstNode in _children) 
				out += m.toString(level);
			return out;
		}
		
		public function get type():AstNodeType { return _type; }
		
		public function set type(value:AstNodeType):void 
		{
			_type = value;
		}
		
		public function get children():Vector.<AstNode> { return _children; }
		
		public function set children(value:Vector.<AstNode>):void 
		{
			_children = value;
		}
		
		public function get value():String { return _value; }
		
		public function set value(value:String):void 
		{
			_value = value;
		}
		
	}
	
}
