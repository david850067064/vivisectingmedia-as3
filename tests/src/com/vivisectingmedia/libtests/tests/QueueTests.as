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
 * The Original Code is Flex 3 QueueTests version 1.0.
 *
 * The Initial Developer of the Original Code is
 * James Polanco (www.vivisectingmedia.com).
 * Report issues to james [at] vivisectingmedia.com
 * Portions created by James Polanco are Copyright (C) 2008
 * James Polanco. All Rights Reserved.
 *
 *
 * ***** END LICENSE BLOCK ***** */
package com.vivisectingmedia.libtests.tests
{
	import com.vivisectingmedia.flexunit.TestUtils;
	import com.vivisectingmedia.framework.datastructures.utils.Queue;
	
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;

	public class QueueTests extends TestCase
	{		
		public function QueueTests(methodName:String=null)
		{
			super(methodName);
		}
		
		/**
		 * Test adding a single item to the queue, call next() to retrieve 
		 * the item using LIFO mode, and then verify that the Queue is empty. 
		 * 
		 */
		public function testSingleItemUsingNextLIFO():void
		{
			// create queue and test item
			var queue:Queue = new Queue(Queue.LIFO);
			var item:Object = {key:"item"};
			
			// add the item to the queue, call next() verify item is returned
			queue.add(item);
			assertTrue("The proper item was not returned.", (item == queue.next()));
		}
		
		/**
		 * Test adding a single item to the queue, call next() to retrieve 
		 * the item using FIFO mode, and then verify that the Queue is empty. 
		 * 
		 */
		public function testSingleItemUsingNextFIFO():void
		{
			// create queue and test item
			var queue:Queue = new Queue(Queue.FIFO);
			var item:Object = {key:"item"};
			
			// add the item to the queue, call next() verify item is returned
			queue.add(item);
			assertTrue("The proper item was not returned.", (item == queue.next()));
		}
		
		/**
		 * Test adding a single item to the queue, call last() to retrieve 
		 * the item using FIFO mode, and then verify that the Queue is empty. 
		 * 
		 */
		public function testSingleItemUsingLastLIFO():void
		{
			// create queue and test item
			var queue:Queue = new Queue(Queue.LIFO);
			var item:Object = {key:"item"};
			
			// add the item to the queue, call next() verify item is returned
			queue.add(item);
			assertTrue("The proper item was not returned.", (item == queue.last()));
		}
		
		/**
		 * Test adding a single item to the queue, call last() to retrieve 
		 * the item using LIFO mode, and then verify that the Queue is empty. 
		 * 
		 */
		public function testSingleItemUsingLastFIFO():void
		{
			// create queue and test item
			var queue:Queue = new Queue(Queue.FIFO);
			var item:Object = {key:"item"};
			
			// add the item to the queue, call next() verify item is returned
			queue.add(item);
			assertTrue("The proper item was not returned.", (item == queue.last()));
		}
		
		/**
		 * Test that adding multiple items to the queue and then calling 
		 * next() pulls items from first in to last out.
		 * 
		 */
		public function testMultipleItemsUsingNextLIFO():void
		{
			// create queue and test items
			var queue:Queue = new Queue(Queue.LIFO);
			var item1:Object = {key:"item1"};
			var item2:Object = {key:"item2"};
			var item3:Object = {key:"item3"};
			var item4:Object = {key:"item4"};
			
			// add the items in order to the queue
			queue.add(item1);
			queue.add(item2);
			queue.add(item3);
			queue.add(item4);
			
			// retrieve and verify that the last one is the first item
			// pulled out of the queue calling next()
			assertTrue("The item4 was not returned.", (item4 == queue.next()));
			assertTrue("The item3 was not returned.", (item3 == queue.next()));
			assertTrue("The item2 was not returned.", (item2 == queue.next()));
			assertTrue("The item1 was not returned.", (item1 == queue.next()));
		}
		
		/**
		 * Test that adding multiple items to the queue and then calling 
		 * next() pulls last item first working to first out last.
		 * 
		 */
		public function testMultipleItemsUsingNextFIFO():void
		{
			// create queue and test items
			var queue:Queue = new Queue(Queue.FIFO);
			var item1:Object = {key:"item1"};
			var item2:Object = {key:"item2"};
			var item3:Object = {key:"item3"};
			var item4:Object = {key:"item4"};
			
			// add the items in order to the queue
			queue.add(item1);
			queue.add(item2);
			queue.add(item3);
			queue.add(item4);
			
			// retrieve and verify that the last one is the first item
			// pulled out of the queue calling next()
			assertTrue("The item1 was not returned.", (item1 == queue.next()));
			assertTrue("The item2 was not returned.", (item2 == queue.next()));
			assertTrue("The item3 was not returned.", (item3 == queue.next()));
			assertTrue("The item4 was not returned.", (item4 == queue.next()));
		}
		
		/**
		 * Test that adding multiple items to the queue and then calling last() 
		 * pulls the first item in the queue and then works forward.
		 * 
		 */
		public function testMultipleItemsUsingLastLIFO():void
		{
			// create queue and test items
			var queue:Queue = new Queue(Queue.LIFO);
			var item1:Object = {key:"item1"};
			var item2:Object = {key:"item2"};
			var item3:Object = {key:"item3"};
			var item4:Object = {key:"item4"};
			
			// add the items in order to the queue
			queue.add(item1);
			queue.add(item2);
			queue.add(item3);
			queue.add(item4);
			
			// retrieve and verify that the last one is the first item
			// pulled out of the queue calling next()
			assertTrue("The item1 was not returned.", (item1 == queue.last()));
			assertTrue("The item2 was not returned.", (item2 == queue.last()));
			assertTrue("The item3 was not returned.", (item3 == queue.last()));
			assertTrue("The item4 was not returned.", (item4 == queue.last()));
		}
		
		/**
		 * Test that adding multiple items to the queue and then calling last() 
		 * pulls the last item from the list and works backwards.
		 * 
		 */
		public function testMultipleItemsUsingLastFIFO():void
		{
			// create queue and test items
			var queue:Queue = new Queue(Queue.FIFO);
			var item1:Object = {key:"item1"};
			var item2:Object = {key:"item2"};
			var item3:Object = {key:"item3"};
			var item4:Object = {key:"item4"};
			
			// add the items in order to the queue
			queue.add(item1);
			queue.add(item2);
			queue.add(item3);
			queue.add(item4);
			
			// retrieve and verify that the last one is the first item
			// pulled out of the queue calling next()
			assertTrue("The item4 was not returned.", (item4 == queue.last()));
			assertTrue("The item3 was not returned.", (item3 == queue.last()));
			assertTrue("The item2 was not returned.", (item2 == queue.last()));
			assertTrue("The item1 was not returned.", (item1 == queue.last()));
		}
		
		/**
		 * Test that calling next() and last() on an empty queue throws 
		 * no errors and returns null.
		 * 
		 */
		public function testNextAndLastOnEmptyQueue():void
		{
			var queue:Queue = new Queue(Queue.FIFO);
			var item1:Object = {key:"item1"};
			
			// verify the empty queue returns null
			assertNull("The result was not a null value", queue.next());
			assertNull("The result was not a null value", queue.last());
			
			// add an item, pull it and verify next() and last() are null
			queue.add(item1);
			assertTrue("The item4 was not returned.", (item1 == queue.next()));
			
			// verify the empty queue returns null
			assertNull("The result was not a null value", queue.next());
			assertNull("The result was not a null value", queue.last());
		}
		
		/**
		 *  Test that an item can be added to the start of the queue 
		 * when content in the queue already exists using FIFO
		 * 
		 */
		public function testAddItemAtStartOfQueueFIFO():void
		{
			// create queue and test items
			var queue:Queue = new Queue(Queue.FIFO);
			var item1:Object = {key:"item1"};
			var item2:Object = {key:"item2"};
			var item3:Object = {key:"item3"};
			var item4:Object = {key:"item4"};
			
			// add the items in order to the queue
			queue.add(item1);
			queue.add(item2);
			queue.add(item3);
			
			// add the last item at the start of the queue
			queue.addAt(item4, 0);
			
			// verify that item 4 was added to the start of the queue
			assertTrue("The item4 was not returned.", (item4 == queue.next()));
			assertTrue("The item1 was not returned.", (item1 == queue.next()));
			assertTrue("The item2 was not returned.", (item2 == queue.next()));
			assertTrue("The item3 was not returned.", (item3 == queue.next()));
		}
		
		/**
		 * Test that an item can be added to the start of the queue 
		 * when content in the queue already exists using LIFO
		 * 
		 */
		public function testAddItemAtStartOfQueueLIFO():void
		{
			// create queue and test items
			var queue:Queue = new Queue(Queue.LIFO);
			var item1:Object = {key:"item1"};
			var item2:Object = {key:"item2"};
			var item3:Object = {key:"item3"};
			var item4:Object = {key:"item4"};
			
			// add the items in order to the queue
			queue.add(item1);
			queue.add(item2);
			queue.add(item3);
			
			// add the last item at the start of the queue
			queue.addAt(item4, 0);
			
			// verify that item 4 was added to the start of the queue, but is returned last
			assertTrue("The item3 was not returned.", (item3 == queue.next()));
			assertTrue("The item2 was not returned.", (item2 == queue.next()));
			assertTrue("The item1 was not returned.", (item1 == queue.next()));
			assertTrue("The item4 was not returned.", (item4 == queue.next()));
		}
		
	}
}