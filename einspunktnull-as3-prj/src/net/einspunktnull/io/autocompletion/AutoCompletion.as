package net.einspunktnull.io.autocompletion
{
	import net.einspunktnull.data.util.StringUtil;

	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	/**
	 * @author Albrecht Nitsche
	 */
	public class AutoCompletion extends EventDispatcher
	{
		private var _entries : Dictionary = new Dictionary(true);
		public var ignoreCase : Boolean;
		public var numLetters : uint;

		public function AutoCompletion(entries : Array = null, ignoreCase : Boolean = true)
		{
			if (entries) this.entries = entries;
			this.ignoreCase = ignoreCase;
			this.numLetters = numLetters;
		}

		public function addEntry(entry : String) : void
		{
			if (entry) _entries[entry] = entry;
		}

		public function removeEntry(entry : String) : void
		{
			if (entry) entry = null;
		}

		public function parse(text : String) : Array
		{
			var ret : Array = new Array();
			for each (var entry : String in _entries)
			{
				var searchEntry : String = ignoreCase ? entry.toLowerCase() : entry;
				var searchText : String = ignoreCase ? text.toLowerCase() : text;
				if (searchText == "" || StringUtil.beginsWith(searchEntry, searchText))
				{
					ret.push(entry);
				}
			}
			ret.sort(Array.CASEINSENSITIVE); 
			return ret;
		}


		/*
		 * GETTER/SETTER
		 */

		public function get entries() : Array
		{
			var entries : Array = new Array();
			for each (var entry:String in _entries)
			{
				entries.push(entry);
			}
			return entries;
		}

		public function set entries(entries : Array) : void
		{
			for each (var entry : String in entries)
			{
				addEntry(entry);
			}
		}

	}
}
