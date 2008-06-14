/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is ActionScript 3 ServiceController version 1.0.
 *
 * The Initial Developer of the Original Code is
 * James Polanco (www.vivisectingmedia.com).
 * Report issues to james [at] vivisectingmedia.com
 * Portions created by James Polanco are Copyright (C) 2008
 * James Polanco. All Rights Reserved.
 *
 *
 * ***** END LICENSE BLOCK ***** */
package com.vivisectingmedia.framework.datastructures.utils
{
	/**
	 * The Queue is a datastructure that allows items to be added
	 * in a specified order then retrived by calling the next() method.
	 * The Queue is defined as either "First in First Out" (FIFO) or
	 * "Last in First Out" (LIFO).  A FIFO structure removes items in
	 * the order they were added, the first item added will be the first
	 * item returned when next() is called.  A LIFO strucutre returns
	 * the last item added when next() is called.
	 * 
	 * @author James Polanco
	 * 
	 */
	public class Queue
	{
		/* STATIC PROPERTIES */
		static public const FIFO:String = "FIFO";
		static public const LIFO:String = "LIFO";
		
		/* PRIVATE PROPERTIES */
		private var _table:Array;
		private var _direction:String;
		
		/**
		 * Creates a new Queue passing in the direction of Queue.
		 * The default direction is FIFO, accepted values are FIFO
		 * and LIFO.
		 * 
		 * @param direction The order items are removed by the nex() call.
		 * 
		 */
		public function Queue(direction:String = FIFO)
		{
			_table = new Array();
			_direction = direction;
		}
		
		/**
		 * Adds an item to the Queue.  The order the items are added
		 * to the queue is important because this determines the order
		 * they are removed when next() is called.
		 * 
		 * @param item The item to add to the end of the Queue.
		 * 
		 */
		public function add(item:*):void
		{
			_table.push(item);
		}
		
		/**
		 * Adds an item to the Queue at the location specified.  If the value
		 * is less then zero the item is put at the beginning of the queue. If
		 * the value is equal to or greater then the length of the Queue then
		 * the item is put at the end of the Queue.
		 * 
		 * @param item The item to add to the Queue.
		 * @param position The position to place the item at.
		 * 
		 */
		public function addAt(item:*, position:int = -1):void
		{
			switch(true)
			{
				case position < 0:
					// add to the beginning of the queue
					_table.unshift(item);
				break;
				
				case position >= _table.length:
					// add to the end
					_table.push(item);
				break;
				
				default:
					// add at the requested postion
					_table.splice(position, 0, item);
			}
		}
		
		/**
		 * Removes the specfied item from the queue.  If the item is in the
		 * Queue more then one time then the numberOfItems value is used to
		 * determine how many of the repeated items should be remove.  The
		 * default is all items are removed from the queue.  Passing 1 or more
		 * will then determine how many times the item is removed.
		 * 
		 * <p>The order items are removed depends on the direction of the the
		 * Queue.  If the Queue is FIFO then the removal starts at the beginning
		 * of the Queue to find items to remove.  If the Queue is LIFO the method
		 * starts at the end of the Queue and works forward.</p>
		 *  
		 * @param item The item to find and remove.
		 * @param numberOfItems The number of instances of the item to remove.
		 * 
		 */
		public function remove(item:*, numberOfItems:int = int.MAX_VALUE):void
		{
			// verify that we are removing at least one item (negatives not allowed)
			if(numberOfItems < 1) return;
			
			// create the clone array
			var clone:Array = new Array();
			var count:int = 0;
			var len:int = _table.length;
			var i:int;
			main:switch(_direction)
			{
				// process from the first to the last
				case LIFO:
					for(i = 0; i < len; i++)
					{
						if(_table[i] == item)
						{
							if(++count > numberOfItems)
							{
								// push the rest and end
								clone.concat(_table.slice((i+1)));
								break main;
							}
						} else {
							clone.push(_table[i]);
						}
					}
				break;
				
				// process from the last to the first
				case FIFO:
					for(i = len; i > -1; i--)
					{
						if(_table[i] == item)
						{
							if(++count > numberOfItems)
							{
								// push the rest and end
								clone.concat(_table.slice(0, (i-1)));
								break main;
							}
						} else {
							clone.push(_table[i]);
						}
					}
				break;
			}
			
			// reset the table
			_table = clone;
		}
		
		/**
		 * Removes an item at the specified position.  If the position
		 * is invalid then a false value is returned stating that the item
		 * was not removed at the provided position.  If the position is valid
		 * the method returns a true for success.
		 *  
		 * @param position The position in the Queue to remove.
		 * @return True for successful removal, false for an invalid position.
		 * 
		 */
		public function removeAt(position:int):Boolean
		{
			// verify that it is a valid position
			if(position > _table.length || position < 0) return false;
			_table.splice(position, 1);
			return true;
		}
		
		/**
		 * This method is used to access the next item in the Queue
		 * depending upon the direction of the Queue.  If the Queue
		 * is typed FIFO (default) the first item in the Queue, i.e.
		 * position 0, is returned.  If the the Queue is typed LIFO
		 * then the last item in the queue, i.e. position length -1, 
		 * is returned.
		 *  
		 * @return The next item in the Queue dependent upon the direction.
		 * 
		 */
		public function next():*
		{
			if(!hasItems) return null;
			switch(_direction)
			{
				case FIFO:
					return _table.shift();
				break;
				
				case LIFO:
					return _table.pop();
				break;
			}
		}
		
		/**
		 * This method is used to access the last item in the Queue
		 * depending upon the direction of the Queue.  If the Queue
		 * is typed FIFO (default) the last item in the Queue, i.e.
		 * length -1, is returned.  If the the Queue is typed LIFO
		 * then the first item in the queue, i.e. position 0, 
		 * is returned.
		 *  
		 * @return The last item in the Queue dependent upon the direction.
		 * 
		 */
		public function last():*
		{
			if(!hasItems) return null;
			switch(_direction)
			{
				case FIFO:
					return _table.pop();
				break;
				
				case LIFO:
					return _table.shift();
				break;
			}
		}
		
		/**
		 * Removes all items from the queue. 
		 * 
		 */
		public function removeAll():void
		{
			_table = new Array();
		}
		
		/**
		 * Used to determine if items are currently stored inside the
		 * Queue.
		 *  
		 * @return True if items are in the Queue, false if the queue is empty.
		 * 
		 */
		public function get hasItems():Boolean
		{
			return (_table.length > 0) ? true : false;
		}
		
		/**
		 * The number of items currently in the Queue.
		 *  
		 * @return The length of the Queue.
		 * 
		 */
		public function get length():int
		{
			return _table.length;
		}

	}
}