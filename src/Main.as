package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flsl.parser.Tokenizer;
	import teapot.com.adobe.utils.AGALMiniAssembler;
	import teapot.TeaPot;
	
	public class Main extends Sprite 
	{
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			var src:XML = <data><![CDATA[
				attribute Float4 pos;
				attribute Float4 norm;
				attribute Float4 uv;

				uniform Matrix mpos;
				uniform Matrix mproj;
				uniform Float4 light;

				varying Float4 tuv;
				varying Float4 lpow;

				shader vertex
				{
					out = pos * mpos * mproj;
					Float4 tnorm = normalize(norm * pos);
					lpow = max(dot(light, tnorm), 0);
					tuv = uv;
				}

				shader fragment
				{
					out = texture(tex, tuv) * (lpow * 0.8 + 0.2);
				}
			]]></data>;

			Tokenizer.debugSource(src.toString());
			
		}
		
	}
	
}
