package flsl.parser.ast 
{

	public class AstOptimizer 
	{
		
		private var _tree:BranchNode;
		
		public function AstOptimizer(tree:BranchNode) 
		{
			_tree = tree;
		}
		
		public function run():void 
		{
			
		}
		
		private function foldConstants(branch:BranchNode = null):void 
		{
			if (!branch) branch = _tree;
			
			for each(var child:AstNode in branch.children) 
			{
				if (child.isLeaf == true) continue;
				if (child.type == AstNodeType.EXPRESSION) 
				{
					foldExpression(child);
					continue;
				}
				foldConstants(child);
			}
		}
		
		private function foldExpression(expr:BranchNode):void 
		{
			var branches:Vector.<BranchNode> = new Vector.<BranchNode>();
			
			// TODO: Complete this.
		}
	}
}
