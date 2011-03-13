package flsl.parser.ast 
{

	public class BranchNode extends AstNode
	{
		
		private var _children:Vector.<AstNode>;
		
		public function BranchNode(type:AstNodeType, subtype:AstNodeType = null) 
		{
			super(type, subtype);
			_children = new Vector.<AstNode>();
			_isLeaf = false;
		}
		
		public function addChild(bn:AstNode):void
		{
			_children.push(bn);
		}
		
		public function get children():Vector.<AstNode> { return _children; }
		
		public function set children(value:Vector.<AstNode>):void 
		{
			_children = value;
		}
		
		public override function toString(level:Number = 0):String
		{
			var out:String = "";
			for (var i:Number = 0; i < level; i++) 
				out += "   ";
				
			out += "<" + _type.name
			if (_sub != AstNodeType.NO_SUBTYPE)
				out += ":" + _sub.name;
			out += ">\n";
			
			level++;
			
			for each(var m:AstNode in _children) 
			{
				out += m.toString(level);
			}
			return out;
		}
	}
	
}
