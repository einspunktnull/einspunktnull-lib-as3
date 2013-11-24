package net.einspunktnull.ai.pathfinding.data
{
	/**
	 * @author Albrecht Nitsche
	 */
	public class NodeList
	{
		private var list : Array = new Array();

		public function add(node : Node) : void
		{
			list.push(node);
		}

		public function get isEmpty() : Boolean
		{
			if (list.length == 0) return true;
			return false;
		}

		public function removeMin() : Node
		{
			var f : Number = 0;

			for each (var node1 : Node in list)
			{
				if (node1.f > f) f = node1.f;
			}

			for each (var node2 : Node in list)
			{
				if (node2.f < f) f = node2.f;
			}
			for each (var node3 : Node in list)
			{
				if (node3.f == f)
				{
					list.splice(list.indexOf(node3), 1);
					return node3;
				}
			}
			return null;
		}

		public function contains(node1 : Node) : Boolean
		{
			for each (var node2 : Node in list)
			{
				if (node1 == node2) return true;
			}
			return false;
		}

		public function clear() : void
		{
			while (list.length) list.pop();
		}

		public function get length() : uint
		{
			return list.length;
		}
	}
}
