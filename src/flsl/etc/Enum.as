
package flsl.etc 
{
	import flash.utils.describeType;
	
	/**
	 * Simple enum system that supports integer ids and toString
	 * @author  Scott Bilas (http://scottbilas.com/2008/06/01/faking-enums-in-as3/)
	 */
	public class Enum 
	{

		public function get name():String
			{ return _name; }
			
		public function get id():Number
			{ return _id; }

		public function toString():String // override
			{ return name; }

		protected static function initEnum(i_type:*):void
		{
			var type:XML = flash.utils.describeType(i_type);
			var i:Number = 0;
			for each (var constant:XML in type.constant)
			{
				var enumConstant:Enum = i_type[constant.@name];

				// if 'text' is already initialized, then we're probably
				// calling initEnum() on the same type twice by accident,
				// likely a copy-paste bonehead mistake.
				if (enumConstant.name != null)
				{
					throw new Error("Can't initialize '" + i_type + "' twice");
				}

				// if the types don't match then probably have another
				// copy-paste error.
				var enumConstantObj:* = enumConstant;
				if (enumConstantObj.constructor != i_type)
				{
					throw new Error(
						"Constant type '" + enumConstantObj.constructor + "' " +
						"does not match its enum class '" + i_type + "'");
				}

				enumConstant._name = constant.@name;
				enumConstant._id = i;
				i++;
			}
		}
		
		private var _id:Number = 0;
		private var _name:String = null;
	}
}
