package net.einspunktnull.data.ds 
{

	/**
	 * @author Albrecht Nitsche
	 */
	public class Queue 
	{
		protected var first : Node;
		protected var last : Node;

		public function isEmpty() : Boolean
		{
			return (first == null);
		}

		public function enqueue(data : Object) : void
		{
			var node : Node = new Node();
			node.data = data;
			node.next = null;
			if (isEmpty()) 
			{
				first = node;
				last = node;
			} 
			else 
			{
				last.next = node;
				last = node;
			}
		}

		public function dequeue() : Object
		{
			if (isEmpty()) 
			{
				trace("Error: \n\t Objects of type Queue must contain data before being dequeued.");
				return null;
			}
			var data : Object = first.data;
			first = first.next;
			return data;
		}

		public function peek() : Object
		{
			if (isEmpty()) 
			{
				trace("Error: \n\t Objects of type Queue must contain data before you can peek.");
				return null;
			}
			return first.data;
		}
		
	}
}
