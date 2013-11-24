package net.einspunktnull.ai.pathfinding.data
{
	import net.einspunktnull.data.util.ArrayUtil;
	/**
	 * @author Albrecht Nitsche
	 */
	public class Net
	{
		private var _nodes : Array = new Array();

		public function addNode(node : Node) : void
		{
			if (!hasNode(node)) _nodes.push(node);
		}

		public function removeNode(node : Node) : void
		{
			if (hasNode(node)) _nodes.splice(_nodes.indexOf(node), 1);
		}

		private function hasNode(node1 : Node) : Boolean
		{
			for each (var node2 : Node in _nodes)
			{
				if (node2 == node1) return true;
			}
			return false;
		}

		public function get nodes() : Array
		{
			return _nodes;
		}

		public function addData(data : XML) : void
		{
			var nodes : XML = XML(data.child('nodes'));
			for each (var node:XML in nodes.elements("node")) 
			{
				addNode(new Node(node.attribute("id"), Number(node.attribute("x")), Number(node.attribute("y"))));
			}
			
			var connections : XML = XML(data.child('connections'));
			for each (var connection:XML in connections.elements("connection")) 
			{
				var nod:Node = ArrayUtil.getElementsByProperty(_nodes, "id", String(connection.attribute("node_id")))[0];
				var sib:Node = ArrayUtil.getElementsByProperty(_nodes, "id", String(connection.attribute("sibling_id")))[0];
				nod.addSibling(sib);
			}
		}
	}
}
