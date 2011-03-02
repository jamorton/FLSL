package flsl.parser.ast 
{

	public class LeafNode extends AstNode
	{
		
		private var _text:String = "";
		
		public function LeafNode(text:String, type:AstNodeType, subtype:AstNodeType = null) 
		{
			super(type, subtype);
			_text = text;
			_isLeaf = true;
		}
		
		public function get text():String { return _text; }
		
		public function set text(value:String):void 
		{
			_text = value;
		}
		
		public override function toString(level:Number = 0):String
		{
			var out:String = "";
			for (var i:Number = 0; i < level; i++) 
				out += "    ";
				
			out += "<" + _type.name
			if (_sub != AstNodeType.NO_SUBTYPE)
				out += ":" + _sub.name;
			out += "> \"" + text + "\"\n";
			return out;
		}
	}
	
}
