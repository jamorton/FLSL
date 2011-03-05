package flsl.parser 
{
	
	public class Token 
	{
		
		private var _value:String;
		private var _type:TokenType;
		private var _line:Number;
		
		public function Token(type:TokenType, val:String, line:Number = 0) 
		{
			_type = type;
			_value = val;
			_line = line;
		}
		
		public function equals(type:TokenType, value:String):Boolean
		{
			return (type == _type && value == _value);
		}
		
		public function equalsToken(token:Token):Boolean
		{
			return (_type == token.type && value == token.value);
		}
		
		public function set line(value:Number):void 
		{
			_line = value;
		}
		
		public function toString():String
		{
			return "<" + type.toString() + " " + _value + ">";
		}
		
		public function get type():TokenType { return _type; }
		public function get value():String { return _value; }
		public function get line():Number { return _line; }
		
	}
	
}
