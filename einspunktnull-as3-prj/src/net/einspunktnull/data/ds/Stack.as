package net.einspunktnull.data.ds 
{

	/**
	 * @author Albrecht Nitsche
	 */
	public class Stack 
	{
		private var first : Node;

		public function isEmpty():Boolean
		{
			return first == null;
		}

		public function push(data : Object):void
		{
			var oldFirst : Node = first;
			first = new Node();
			first.data = data;
			first.next = oldFirst;
		}

		public function pop() : Object 
		{
			if (isEmpty())
			{
				trace("Error: \n\t Objects of type Stack must containt data before you attempt to pop");
				return null;
			}
			var data:Object = first.data;
			first = first.next;
			return data;
		}

		public function peek() : Object 
		{
			if (isEmpty())
			{
				trace("Error: \n\t Objects of type Stack must containt data before you attempt to peek");
				return null;
			}
			return first.data;
		}
	}
}
