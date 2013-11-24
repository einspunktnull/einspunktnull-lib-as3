package net.einspunktnull.data.ds 
{

	/**
	 * @author Albrecht Nitsche
	 */
	public class NettoQueue extends Queue 
	{
		private var depth : uint = 0;
		private var back : Object;

		public function peek2() : Object 
		{
			if (isEmpty()) 
			{
				trace("Error: \n\t Objects of type Queue must contain data before you can peek.");
				return null;
			}
			return first.next.data;
		}

		public function length() : uint
		{
			if(isEmpty())return 0;
			else
			{
				depthCount(first);
				var count : uint = depth;
				depth = 0;
				return count;
			}
		}

		private function depthCount(element : Object) : void
		{
			depth++;
			if(element.next != null)depthCount(element.next);
			else return;
		}
		
		public function getElement(index : uint) : Object
		{
			if (isEmpty()) return null;
			else
			{
				depthGrab(first,index);
				return back;
			}
		}

		private function depthGrab(element : Object,index:uint):void
		{
			if(depth<index)
			{
				depth++;
				if (element.next != null)depthGrab(element.next,index);
				else 
				{
					trace("Warning: NettoQueue - Out of Bounds!");
					back = null;
				}
			}
			else back = element.data;
		}
	}
}
