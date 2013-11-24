/*
Copyright (c) 2008 NascomASLib Contributors.  See:
    http://code.google.com/p/nascomaslib

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

package be.nascom.air.data
{
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.filesystem.File;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import mx.collections.ArrayCollection;
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	/** 
	 * The EntityManager maps a class in AS to a Table in a SQLite Database.
	 * <p>Map of metadata information for each class used by the application. The class is used as 
	 * the map key. The information maintained for each class includes: 
	 * table: name of the database table used to persist the object information.
	 * identity: object that maps the table primary key to the name of the corresponding class field.  
	 * fields: list of objects that map field names of the class to the corresponding database colums.</p>
	 * 
	 * @author Alain Hufkens
	 * @email alain.hufkens@nascom.be
	 * 	 
	 */
	public class EntityManager
	{
		private static var logger:ILogger = Log.getLogger("EntityManager");
		
		private var map:Object = new Object();
		private var _sqlConnection:SQLConnection;

		
		/**
		 * Constructor. Enforce the singleton pattern by throwing an error if the class is not instantiated using getInstance().
		 * */
		public function EntityManager()
		{
							
		}
		
		/**
		 * Clears all data for a specified class.
		 * 
		 * @param c Type of object
		 * */	
		public function clearAll(c:Class):void
		{
			// If not yet done, load the metadata for this class
			if (!map[c]) loadMetadata(c);
			var identity:Object = map[c].identity;
			var stmt:SQLStatement = map[c].clearStmt;
			stmt.execute();			
		}

		/**
		 * Retrieves all records for a specified class.
		 * 
		 * @param c Type of object
		 * */
		public function findAll(c:Class):ArrayCollection
		{
			// If not yet done, load the metadata for this class
			if (!map[c]) loadMetadata(c);
			var stmt:SQLStatement = map[c].findAllStmt;
			stmt.execute();
			// Return typed objects			
			var result:Array = stmt.getResult().data;
			return typeArray(result,c);
		}
		
		/**
		 * Retrieves all records for a specified class, sorted by the specified field.
		 * 
		 * @param c Type of object
		 * @param field name of field to sort on
		 * */
		public function findAllSortBy(c:Class, field:String):ArrayCollection
		{
			// If not yet done, load the metadata for this class
			if (!map[c]) loadMetadata(c);
			var stmt:SQLStatement = map[c].findAllStmt;
			stmt.text += " ORDER BY lower(" + field + ")";
			stmt.execute();
			// Return typed objects			
			var result:Array = stmt.getResult().data;
			return typeArray(result,c);
		}
		
		/**
		 * Saves an object to the database.
		 * 
		 * @param o Object to save to the database
		 * */
		public function save(o:Object):void
		{
			var c:Class = Class(getDefinitionByName(getQualifiedClassName(o)));
			// If not yet done, load the metadata for this class
			if (!map[c]) loadMetadata(c);
			var identity:Object = map[c].identity;
			// Check if the object has an identity
			if (o[identity.field]>0)
			{
				// If yes, we deal with an update
				updateItem(o,c);
			}
			else
			{
				// If no, this is a new item
				createItem(o,c);
			}
		}
		
		private function updateItem(o:Object, c:Class):void
		{
			var stmt:SQLStatement = map[c].updateStmt;
			var fields:ArrayCollection = map[c].fields;
			for (var i:int = 0; i<fields.length; i++)
			{
				var field:String = fields.getItemAt(i).field;
				stmt.parameters[":" + field] = o[field];
			}
			stmt.execute();
		}

		private function createItem(o:Object, c:Class):void
		{
			var stmt:SQLStatement = map[c].insertStmt;
			var identity:Object = map[c].identity;
			var fields:ArrayCollection = map[c].fields;
			for (var i:int = 0; i<fields.length; i++)
			{
				var field:String = fields.getItemAt(i).field;
				if (field != identity.field)
				{
					stmt.parameters[":" + field] = o[field];					
				}
			}
			stmt.execute();
			o[identity.field] = stmt.getResult().lastInsertRowID;
		}
		
		/**
		 * Removes an object from the database.
		 * 
		 * @param o Object to remove from the database
		 * */
		public function remove(o:Object):void
		{
			var c:Class = Class(getDefinitionByName(getQualifiedClassName(o)));
			// If not yet done, load the metadata for this class
			if (!map[c]) loadMetadata(c);
			var identity:Object = map[c].identity;
			var stmt:SQLStatement = map[c].deleteStmt;
			stmt.parameters[":"+identity.field] = o[identity.field];
			stmt.execute();			
		}			
		
		private function loadMetadata(c:Class):void
		{
			map[c] = new Object();
			var xml:XML = describeType(new c());
			var table:String = xml.metadata.(@name=="Table").arg.(@key=="name").@value;
			map[c].table = table;
			map[c].fields = new ArrayCollection();
			var variables:XMLList = xml.accessor;

			var insertParams:String = "";						
			var updateSQL:String = "UPDATE " + table + " SET ";
			var insertSQL:String = "INSERT INTO " + table + " (";
			var createSQL:String = "CREATE TABLE IF NOT EXISTS " + table + " (";

            for (var i:int = 0 ; i < variables.length() ; i++) 
            {
            	if (variables[i].metadata.(@name=="Ignore").length()==0)
				{
	            	var field:String = variables[i].@name.toString();
					var column:String;   					
					         	
	            	if (variables[i].metadata.(@name=="Column").length()>0)
	            	{
	            		column = variables[i].metadata.(@name=="Column").arg.(@key=="name").@value.toString().toUpperCase(); 
	            	} 
	            	else
	            	{
						column = field.toUpperCase();
	            	}
	        		map[c].fields.addItem({field: field, column: column});
	
	            	if (variables[i].metadata.(@name=="Id").length()>0)
	            	{
	            		map[c].identity = {field: field, column: column};
						createSQL += column + " INTEGER PRIMARY KEY AUTOINCREMENT,";
	            	}
					else            	
					{
						insertSQL += column + ",";
						insertParams += ":" + field + ",";
						updateSQL += column + "=:" + field + ",";	
						createSQL += column + " " + getSQLType(variables[i].@type) + ",";
					}
				}
            }
            
            createSQL = createSQL.substring(0, createSQL.length-1) + ")";
            logger.debug("createSQL: " + createSQL);
            
            insertSQL = insertSQL.substring(0, insertSQL.length-1) + ") VALUES (" + insertParams;
            insertSQL = insertSQL.substring(0, insertSQL.length-1) + ")";
            logger.debug("insertSQL: " + insertSQL);
            
			updateSQL = updateSQL.substring(0, updateSQL.length-1);
			updateSQL += " WHERE " + map[c].identity.column + "=:" + map[c].identity.field;
			logger.debug("updateSQL: " + updateSQL);

			var deleteSQL:String = "DELETE FROM " + table + " WHERE " + map[c].identity.column + "=:" + map[c].identity.field;
			logger.debug("deleteSQL: " + deleteSQL);
			
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = insertSQL;		
			map[c].insertStmt = stmt;
			
			stmt = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = updateSQL;
			map[c].updateStmt = stmt;
			
			stmt = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = deleteSQL;
			map[c].deleteStmt = stmt;
			
			stmt = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = "SELECT * FROM " + table;
			map[c].findAllStmt = stmt;
			
			stmt = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = "DELETE FROM " + table;
			map[c].clearStmt = stmt;
			
			stmt = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = createSQL;
			stmt.execute();
		}
		
		private function typeArray(a:Array, c:Class):ArrayCollection
		{
			if (a==null) return null;
			var ac:ArrayCollection = new ArrayCollection();
			for (var i:int=0; i<a.length; i++)
			{
				ac.addItem(typeObject(a[i],c));
			}
			return ac;			
		}

		private function typeObject(o:Object,c:Class):Object
		{
			var instance:Object = new c();
			var fields:ArrayCollection = map[c].fields;
			
			for (var i:int; i<fields.length; i++)
			{
				var item:Object = fields.getItemAt(i);			
				instance[item.field] = o[item.column];									
					
			}
			return instance;
		}
		
		private function getSQLType(asType:String):String
		{
			if (asType == "int" || asType == "uint")
				return "INTEGER";
			else if (asType == "Number")
				return "REAL";
			else if (asType == "Boolean")
				return "BOOLEAN";
			else
				return "TEXT";				
		}
		/**
		 * Gets/sets the underlying SQL Connection
		 * */
		public function get sqlConnection():SQLConnection
		{
			if (!_sqlConnection)
			{
				var dbFile:File = File.applicationStorageDirectory.resolvePath("default.db");  
				_sqlConnection = new SQLConnection(); 
				_sqlConnection.open(dbFile);
			}
			return _sqlConnection;
		}		
		
		public function set sqlConnection(sqlConnection:SQLConnection):void
		{
			_sqlConnection = sqlConnection;
		}
		
		/**
		 * Begins the transaction
		 * */
		public function beginTransaction():void
		{
			return _sqlConnection.begin()
		}
		
		/**
		 * Commits the transaction
		 * */
		public function commitTransaction():void
		{
			return _sqlConnection.commit()
		}
		
		/**
		 * Rolls back the transaction
		 * */
		public function rollbackTransaction():void
		{
			return _sqlConnection.rollback()
		}
		
			
		
	}
}