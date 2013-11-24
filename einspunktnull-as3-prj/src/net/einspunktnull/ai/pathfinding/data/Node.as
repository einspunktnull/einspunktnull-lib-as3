package net.einspunktnull.ai.pathfinding.data
{
	/**
	 * @author Albrecht Nitsche
	 */
	public class Node
	{
		public static const SELECTED : String = "selected";
		public var used : Boolean = false;
		private var _siblings : Array = new Array();
		private var _id : String;
		private var _x : Number = 0;
		private var _y : Number = 0;
		// vorgaenger
		public var pre : Node;
		// kürzesterWeg, wenn günstig f = g+h
		public var f : Number = 0;
		// bisherige Kosten vom Startknoten aus
		public var g : Number = 0;
		// geschätzer weg: Luftlinie
		public var h : Number = 0;

		public function Node(id : String, x : Number, y : Number)
		{
			this._id = id;
			_x = x;
			_y = y;
		}

		public function addSibling(siblingNode : Node) : void
		{
			if (!hasSibling(siblingNode)) _siblings.push(siblingNode);
		}

		public function removeSibling(siblingNode : Node) : void
		{
			if (hasSibling(siblingNode)) _siblings.splice(_siblings.indexOf(siblingNode), 1);
		}

		private function hasSibling(sibling1 : Node) : Boolean
		{
			for each (var sibling2 : Node in _siblings)
			{
				if (sibling1 == sibling2) return true;
			}
			return false;
		}

		public function get x() : Number
		{
			return _x;
		}

		public function get y() : Number
		{
			return _y;
		}

		public function get id() : String
		{
			return _id;
		}

		public function get siblings() : Array
		{
			return _siblings;
		}
	}
}
